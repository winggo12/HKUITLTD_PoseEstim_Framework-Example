//
//  ViewController.swift
//  Example
//
//  Created by hkuit155 on 3/7/2020.
//  Copyright © 2020 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import UIKit
import HKUITLTD_PoseEstim_Framework
import AVFoundation

class ViewController: UIViewController {
    
    @IBOutlet weak var overlayView: OverlayView!
    @IBOutlet weak var previewView: PreviewView!
    
    //Storing location for 'overlayView' and 'previewView'
    private var overlayViewFrame: CGRect?
    private var previewViewFrame: CGRect?
    
    // MARK: Controllers that manage functionality
    // Handles all the camera related functionality
    private lazy var cameraCapture = CameraFeedManager(previewView: previewView)
    // Handles all data preprocessing and makes calls to run inference.
    private var thisModel: RunthisModel?
    
    //Variables for controlling the use of Threading and GPU
    var threadCount: Int = Constants.defaultThreadCount
    var delegate: Delegates = Constants.defaultDelegate
    // Minimum score to render the skelton keypoints.
    private let minimumScore: Float = 0.5
    

    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //Initialize the AI Model Interface and Camera Capture
        thisModel = RunthisModel()
        cameraCapture.delegate = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      cameraCapture.checkCameraConfigurationAndStartSession()
    }

    override func viewWillDisappear(_ animated: Bool) {
      cameraCapture.stopSession()
    }
    override func viewDidLayoutSubviews() {
        overlayViewFrame = overlayView.frame
        previewViewFrame = previewView.frame

        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        print(orientation)

        switch (orientation) {
        case .portrait:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        case .landscapeRight:
            previewView.previewLayer.connection?.videoOrientation = .landscapeLeft

            
        case .landscapeLeft:
            previewView.previewLayer.connection?.videoOrientation = .landscapeRight

        default:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        }
        
    }


}


extension ViewController: CameraFeedManagerDelegate {
    func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager) {
        
    }
    
    func cameraFeedManager(_ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool) {
        
    }
    
    func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager) {
        
    }
    
    func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager) {
        
    }
    
    func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager) {
        
    }

    //Obtain the CVPixelBuffer of the Image
    func cameraFeedManager(_ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer) {
        
        DispatchQueue.main.async {
            
            self.overlayViewFrame = self.overlayView.frame
            self.previewViewFrame = self.previewView.frame

        }
        
        let (result,times) = (thisModel?.Run(pb: pixelBuffer, olv: self.overlayViewFrame!, pv: self.previewViewFrame!))!
        //let (result,times) = (thisModel?.Run(pb: pixelBuffer, olv: overlayViewFrame!, pv: previewViewFrame!))!
        
        var userselectedpose: Pose = Pose.ardha_uttanasana
        var givefeedback = GiveFeedBack(user_input_result: result, user_input_pose: userselectedpose)
        var score: Double = givefeedback.getScore()
        var comments: [String] = givefeedback.getComments()
        
            DispatchQueue.main.async {
                if result.score < self.minimumScore {
                    self.overlayView.clear()
                    return
                }
                self.overlayView.drawResult(result: result)

            }
  }
    
}


