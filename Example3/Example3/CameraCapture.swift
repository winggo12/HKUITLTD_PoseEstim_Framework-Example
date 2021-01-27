//
//  CameraCapture.swift
//  Example3
//
//  Created by admin on 27/01/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import UIKit
import AVFoundation
import HKUITLTD_PoseEstim_Framework


@objc public protocol PoseEstimationDelegate: class {

    @objc optional func poseEstimation(
        _ manager: CameraCapture, didOutput pixelBuffer: CVPixelBuffer
    )
    
}


private enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
}


public class CameraCapture: NSObject {
    
    // Camera Capture Related Instance Variables
    private let sessionQueue = DispatchQueue(label: "session queue")
    private let captureSession = AVCaptureSession()
    private lazy var videoOutput = AVCaptureVideoDataOutput()
    
    private var setupResult: SessionSetupResult = .notAuthorized
    private var isSessionRunning = false
    private var videoDeviceInput: AVCaptureDeviceInput?
    private var cameraCurrentPosition: AVCaptureDevice.Position = .unspecified
    var windowOrientation = UIApplication.shared.statusBarOrientation
    
    // Captured Video View
    private var previewView: PreviewView!
    
    // Captured Video Frame
    private var previewViewFrame: CGRect?

    
    public weak var delegate: PoseEstimationDelegate?
    
    
    public func getCameraPosition() -> AVCaptureDevice.Position { return self.cameraCurrentPosition }
    
    
    
    init(previewView: PreviewView) {
        
        super.init()
        
        self.previewView = previewView
    
    }
    
    
    public func startConfiguration() -> Bool {
        
        checkAuthorizationStatus()
        
        congfigureSession()
        
        self.previewView.session = captureSession
        self.previewView.previewLayer.videoGravity = .resizeAspectFill
        
        return setupResult == .success
        
    }
    
    public func runSession() {
        
        sessionQueue.async {
            self.addObservers()
            self.captureSession.startRunning()
            self.isSessionRunning = true
        }
        
    }
    
    public func stopSession() {
        
        sessionQueue.async {
            if self.isSessionRunning == true {
                self.captureSession.stopRunning()
                self.isSessionRunning = false
                self.removeObservers()
            }
        }
        
    }
    
    
    public func switchCamera(cameraButton: UIButton) {
        
        sessionQueue.async {
            if self.videoDeviceInput != nil {
                do {
                    let currentVideoDevice = self.videoDeviceInput!.device
                    let currentPosition = currentVideoDevice.position
                    let preferredPosition: AVCaptureDevice.Position
                    
                    switch currentPosition {
                    case .unspecified, .front:
                        preferredPosition = .back
                        
                    case .back:
                        preferredPosition = .front
                        
                    @unknown default:
                        print("Unknown capture position. Defaulting to back camera.")
                        preferredPosition = .back
                    }
                    
                    self.cameraCurrentPosition = preferredPosition
                    
                    guard let cameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: preferredPosition) else {
                        print("Default video device is unavaliable.")
                        return
                    }
                    
                    guard let videoDeviceInput = try? AVCaptureDeviceInput(device: cameraDevice) else {
                        print("Couldn't input the video device to the session.")
                        return
                    }
                    
                    self.captureSession.beginConfiguration()
                    self.captureSession.removeInput(self.videoDeviceInput!)
                    
                    if self.captureSession.canAddInput(videoDeviceInput) {
                        // remove the past observer & add the latest one
                        
                        self.captureSession.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.captureSession.addInput(self.videoDeviceInput!)
                    }
                    
                    self.captureSession.commitConfiguration()
                }
                
            } else {
                print("Switch camera failed.")
                return
            }
        }
        
    }
    
    
    /// - Tag: Rotate Orientation
    public func rotateScreen() {
        
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        switch (orientation) {
        case .portrait:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        case .landscapeRight:
            previewView.previewLayer.connection?.videoOrientation = .landscapeLeft
        case .portraitUpsideDown:
            previewView.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewView.previewLayer.connection?.videoOrientation = .landscapeRight
            
        default:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        }
        
    }
    
    
    
    private func checkAuthorizationStatus() {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupResult = .success
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.setupResult = .success
            })
            
        default:
            setupResult = .notAuthorized
        }
    }
    
    
    /// - Tag: Configure Session
    private func congfigureSession() {
        
        captureSession.beginConfiguration()
        
        // configure the input
        guard configureInput() == true else {
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
        
        // configure the output
        guard configureOutput() == true else {
            setupResult = .configurationFailed
            captureSession.commitConfiguration()
            return
        }
        
        setupResult = .success
        captureSession.commitConfiguration()
        
    }
    
    private func configureInput() -> Bool {
        
        var cameraDevice: AVCaptureDevice?
        
        if let backCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
            cameraDevice = backCamera
            cameraCurrentPosition = .back
        } else if let frontCamera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
            cameraDevice = frontCamera
            cameraCurrentPosition = .front
        }
        
        guard let videoDevice = cameraDevice else {
            print("Default video device is unavaliable.")
            return false
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice), captureSession.canAddInput(videoDeviceInput) else {
            print("Couldn't add video device input to the session.")
            return false
        }
        
        captureSession.addInput(videoDeviceInput)
        self.videoDeviceInput = videoDeviceInput
        
        return true
    }
    
    private func configureOutput() -> Bool {
        
        let outputDispatchQueue = DispatchQueue(label: "setSampleBufferDelegate")
        videoOutput.setSampleBufferDelegate(self, queue: outputDispatchQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [
            String(kCVPixelBufferPixelFormatTypeKey): kCMPixelFormat_32BGRA
        ]
        
        guard captureSession.canAddOutput(videoOutput) else {
            return false
        }
        
        captureSession.sessionPreset = .high
        captureSession.addOutput(videoOutput)
        
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        
        return true
    }
    
    
    private func addObservers() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionRuntimeError), name: .AVCaptureSessionRuntimeError, object: captureSession)
   
        NotificationCenter.default.addObserver(self, selector: #selector(sessionWasInterrupted), name: .AVCaptureSessionWasInterrupted, object: captureSession)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sessionInterruptionEnded), name: .AVCaptureSessionInterruptionEnded, object: captureSession)
        
    }
    
    private func removeObservers() {
        
        NotificationCenter.default.removeObserver(self)
        
    }
    
    
    /// - Tag: HandleRuntimeError
    @objc
    func sessionRuntimeError(notification: NSNotification) {
        
        guard let error = notification.userInfo?[AVCaptureSessionErrorKey] as? AVError else { return }
        
        print("Capture session runtime error: \(error)")
        
        // If media services were reset, and the last start succeeded, restart the session.
        if error.code == .mediaServicesWereReset, self.isSessionRunning {
            sessionQueue.async {
                self.captureSession.startRunning()
                self.isSessionRunning = self.captureSession.isRunning
            }
        }
    }
    
    @objc
    func sessionWasInterrupted(notification: NSNotification) {

        if let userInfoValue = notification.userInfo?[AVCaptureSessionInterruptionReasonKey] as AnyObject?,
            let reasonIntegerValue = userInfoValue.integerValue,
            let reason = AVCaptureSession.InterruptionReason(rawValue: reasonIntegerValue) {
            print("Capture session was interrupted with reason \(reason)")
            }
        
    }
    
    @objc
    func sessionInterruptionEnded(notification: NSNotification) {
        
        print("Capture session interruption ended")
        
    }
    
}

extension CameraCapture: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// - Tag: Process Video Frames
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {

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

        connection.videoOrientation = AVCaptureVideoOrientation(rawValue: orientationValue)!

        // Converts the CMSampleBuffer to a CVPixelBuffer.
        let pixelBuffer: CVPixelBuffer? = CMSampleBufferGetImageBuffer(sampleBuffer)

        guard let imagePixelBuffer = pixelBuffer else {
            return
        }
        
        // Delegates the pixel buffer to the ViewController.
        delegate?.poseEstimation?(self, didOutput: imagePixelBuffer)
    }

}
