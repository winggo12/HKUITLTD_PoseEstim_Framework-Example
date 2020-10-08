

import AVFoundation
import UIKit
import os

// MARK: - CameraFeedManagerDelegate Declaration
@objc public protocol CameraFeedManagerDelegate: class {
  /// This method delivers the pixel buffer of the current frame seen by the device's camera.
  @objc optional func cameraFeedManager(
    _ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer
  )

  /// This method initimates that a session runtime error occured.
  func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager)

  /// This method initimates that the session was interrupted.
  func cameraFeedManager(
    _ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool
  )

  /// This method initimates that the session interruption has ended.
  func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager)

  /// This method initimates that there was an error in video configurtion.
  func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager)

  /// This method initimates that the camera permissions have been denied.
  func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager)
}

/// This enum holds the state of the camera initialization.
// MARK: - Camera Initialization State Enum
private enum CameraConfiguration {
  case success
  case failed
  case permissionDenied
}

/// This class manages all camera related functionalities.
// MARK: - Camera Related Functionalies Manager
public class CameraFeedManager: NSObject {
  // MARK: Camera Related Instance Variables
  private let session: AVCaptureSession = AVCaptureSession()
  private let previewView: PreviewView
  private let sessionQueue = DispatchQueue(label: "sessionQueue")
  private var cameraConfiguration: CameraConfiguration = .failed
  private lazy var videoDataOutput = AVCaptureVideoDataOutput()
  private var isSessionRunning = false

    private var currentCamera: AVCaptureDevice.Position = .unspecified
    
  // MARK: CameraFeedManagerDelegate
  public weak var delegate: CameraFeedManagerDelegate?

  // MARK: Initializer
  public init(previewView: PreviewView) {
    self.previewView = previewView
    super.init()

    // Initializes the session
    session.sessionPreset = .high
    self.previewView.session = session
    //    self.previewView.previewLayer.connection?.videoOrientation = .landscapeLeft
        self.previewView.previewLayer.connection?.videoOrientation = .portrait
        
        self.previewView.previewLayer.videoGravity = .resizeAspectFill
    self.attemptToConfigureSession()
  }

  // MARK: Session Start and End methods

  /// This method starts an AVCaptureSession based on whether the camera configuration was successful.
  public func checkCameraConfigurationAndStartSession() {
    sessionQueue.async {
      switch self.cameraConfiguration {
      case .success:
        self.addObservers()
        self.startSession()
      case .failed:
        DispatchQueue.main.async {
          self.delegate?.presentVideoConfigurationErrorAlert(self)
        }
      case .permissionDenied:
        DispatchQueue.main.async {
          self.delegate?.presentCameraPermissionsDeniedAlert(self)
        }
      }
    }
  }

  /// This method stops a running an AVCaptureSession.
  public func stopSession() {
    self.removeObservers()
    sessionQueue.async {
      if self.session.isRunning {
        self.session.stopRunning()
        self.isSessionRunning = self.session.isRunning
      }
    }

  }

  /// This method resumes an interrupted AVCaptureSession.
  private func resumeInterruptedSession(withCompletion completion: @escaping (Bool) -> Void) {
    sessionQueue.async {
      self.startSession()

      DispatchQueue.main.async {
        completion(self.isSessionRunning)
      }
    }
  }

  /// This method starts the AVCaptureSession
  private func startSession() {
    self.session.startRunning()
    self.isSessionRunning = self.session.isRunning
  }

  // MARK: Session Configuration Methods.
  /// This method requests for camera permissions and handles the configuration of the session and stores the result of configuration.
  private func attemptToConfigureSession() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      self.cameraConfiguration = .success
    case .notDetermined:
      self.sessionQueue.suspend()
      self.requestCameraAccess(completion: { granted in
        self.sessionQueue.resume()
      })
    case .denied:
      self.cameraConfiguration = .permissionDenied
    default:
      break
    }

    self.sessionQueue.async {
      self.configureSession()
    }
  }

  /// This method requests for camera permissions.
  private func requestCameraAccess(completion: @escaping (Bool) -> Void) {
    AVCaptureDevice.requestAccess(for: .video) { (granted) in
      if !granted {
        self.cameraConfiguration = .permissionDenied
      } else {
        self.cameraConfiguration = .success
      }
      completion(granted)
    }
  }

  /// This method handles all the steps to configure an AVCaptureSession.
  private func configureSession() {
    guard cameraConfiguration == .success else {
      return
    }
    session.beginConfiguration()

    // Tries to add an AVCaptureDeviceInput.
    guard addVideoDeviceInput() == true else {
      self.session.commitConfiguration()
      self.cameraConfiguration = .failed
      return
    }

    // Tries to add an AVCaptureVideoDataOutput.
    guard addVideoDataOutput() else {
      self.session.commitConfiguration()
      self.cameraConfiguration = .failed
      return
    }

    session.commitConfiguration()
    self.cameraConfiguration = .success
  }

  /// This method tries to an AVCaptureDeviceInput to the current AVCaptureSession.
  private func addVideoDeviceInput() -> Bool {
    /// Tries to get the default back camera.
    guard
      let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back)
      else {
        fatalError("Cannot find camera")
    }

    do {
      let videoDeviceInput = try AVCaptureDeviceInput(device: camera)
      
        self.currentCamera = camera.position
        
      if session.canAddInput(videoDeviceInput) {
        session.addInput(videoDeviceInput)
        return true
      } else {
        return false
      }
    } catch {
      fatalError("Cannot create video device input")
    }
  }

  /// This method tries to an AVCaptureVideoDataOutput to the current AVCaptureSession.
  private func addVideoDataOutput() -> Bool {
    let sampleBufferQueue = DispatchQueue(label: "sampleBufferQueue")
    videoDataOutput.setSampleBufferDelegate(self, queue: sampleBufferQueue)
    videoDataOutput.alwaysDiscardsLateVideoFrames = true
    videoDataOutput.videoSettings = [
      String(kCVPixelBufferPixelFormatTypeKey): kCMPixelFormat_32BGRA
    ]

    if session.canAddOutput(videoDataOutput) {
      session.addOutput(videoDataOutput)
      videoDataOutput.connection(with: .video)?.videoOrientation = .portrait

      return true
    }
    return false
  }

  // MARK: Notification Observer Handling
  private func addObservers() {
    NotificationCenter.default.addObserver(
      self, selector: #selector(CameraFeedManager.sessionRuntimeErrorOccured(notification:)),
      name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
    NotificationCenter.default.addObserver(
      self, selector: #selector(CameraFeedManager.sessionWasInterrupted(notification:)),
      name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
    NotificationCenter.default.addObserver(
      self, selector: #selector(CameraFeedManager.sessionInterruptionEnded),
      name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
  }

  private func removeObservers() {
    NotificationCenter.default.removeObserver(
      self, name: NSNotification.Name.AVCaptureSessionRuntimeError, object: session)
    NotificationCenter.default.removeObserver(
      self, name: NSNotification.Name.AVCaptureSessionWasInterrupted, object: session)
    NotificationCenter.default.removeObserver(
      self, name: NSNotification.Name.AVCaptureSessionInterruptionEnded, object: session)
  }

  // MARK: Notification Observers
  @objc func sessionWasInterrupted(notification: Notification) {
    if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey]
      as AnyObject?,
      let reasonIntegerValue = userInfoValue.integerValue,
      let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue)
    {
      os_log("Capture session was interrupted with reason: %s", type: .error, reason.rawValue)

      var canResumeManually = false
      if reason == .videoDeviceInUseByAnotherClient {
        canResumeManually = true
      } else if reason == .videoDeviceNotAvailableWithMultipleForegroundApps {
        canResumeManually = false
      }

      delegate?.cameraFeedManager(self, sessionWasInterrupted: canResumeManually)

    }
  }

  @objc func sessionInterruptionEnded(notification: Notification) {
    delegate?.cameraFeedManagerDidEndSessionInterruption(self)
  }

  @objc func sessionRuntimeErrorOccured(notification: Notification) {
    guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else {
      return
    }

    os_log("Capture session runtime error: %s", type: .error, error.localizedDescription)

    if error.code == .mediaServicesWereReset {
      sessionQueue.async {
        if self.isSessionRunning {
          self.startSession()
        } else {
          DispatchQueue.main.async {
            self.delegate?.cameraFeedManagerDidEncounterSessionRunTimeError(self)
          }
        }
      }
    } else {
      delegate?.cameraFeedManagerDidEncounterSessionRunTimeError(self)
    }
  }
    
    public func showCurrentInput() -> AVCaptureDevice.Position {
        return self.currentCamera
    }
    
    private func getCamera(with: AVCaptureDevice.Position) -> AVCaptureDevice {
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: with) else {
            fatalError("Cannot find camera")
        }
        return camera
    }
    
    public func switchCamera() {
        self.removeObservers()
        self.session.stopRunning()
        self.session.beginConfiguration()
        let currentInput = self.session.inputs.first as? AVCaptureDeviceInput
        self.session.removeInput(currentInput!)
        let newCameraDevice = currentInput?.device.position == .back ? getCamera(with: .front) : getCamera(with: .back)
        let newVideoInput = try? AVCaptureDeviceInput(device: newCameraDevice)
        self.session.addInput(newVideoInput!)
        self.session.commitConfiguration()
        self.currentCamera = newCameraDevice.position
        self.checkCameraConfigurationAndStartSession()
    }
}

/// AVCaptureVideoDataOutputSampleBufferDelegate
extension CameraFeedManager: AVCaptureVideoDataOutputSampleBufferDelegate {
  /// This method delegates the CVPixelBuffer of the frame seen by the camera currently.
    public func captureOutput(
    _ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer,
    from connection: AVCaptureConnection
  ) {
        var orientationValue : Int
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        switch (orientation) {
        case .portrait:
            orientationValue = 1
        case .portraitUpsideDown:
            orientationValue = 2
        case .landscapeRight:
            orientationValue = 4
        case .landscapeLeft:
            orientationValue = 3
        default:
            orientationValue = 1
        }
        
        connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientationValue)!;
    // Converts the CMSampleBuffer to a CVPixelBuffer.
        
    let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)
        
        
    guard let imagePixelBuffer = pixelBuffer else {
      return
    }

    // Delegates the pixel buffer to the ViewController.
    delegate?.cameraFeedManager?(self, didOutput: imagePixelBuffer)
  }
}
