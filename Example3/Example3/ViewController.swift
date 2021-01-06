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
import os
class ViewController: UIViewController {
    
    var timingFlag: Bool?
    var startTime: UInt64 = 0
    
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
    private let minimumScore: Float = 0.6
    
    private var givefeedback: GiveFeedBack? = nil

    @IBAction func switchBtn(_ sender: Any) {
        self.cameraCapture.switchCamera()
    }

    
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
//        print(orientation)Label(/*@START_MENU_TOKEN@*/"Label"/*@END_MENU_TOKEN@*/, systemImage: /*@START_MENU_TOKEN@*/"42.circle"/*@END_MENU_TOKEN@*/)

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
        
        let userselectedpose: Pose = Pose.Utkatasana

        if(givefeedback == nil){
            givefeedback = GiveFeedBack(user_input_result: result, user_input_pose: userselectedpose)
            
        }else{
            if (timingFlag == nil){
                givefeedback!.generateFeedback(user_input_result: result, user_input_pose: userselectedpose)
            }else{
                givefeedback!.generateFeedback(user_input_result: result, user_input_pose: userselectedpose, startTiming: timingFlag!, startTime: self.startTime)
            }
        }

        let score: Double = givefeedback!.getScore()
        let detailedscore: [Double] = givefeedback!.getDetailedScore()
        let comments: [String] = givefeedback!.getComments()
        timingFlag = givefeedback!.getTimingFlag()
        startTime = givefeedback!.getStartTime()
        
        DispatchQueue.main.async {
            if result.score < self.minimumScore {
                self.overlayView.clear()
                return
            }
            
            let position = self.cameraCapture.showCurrentInput()
            self.overlayView.drawResult(result: result, bounds: self.overlayView.bounds, position: position)

        }
//        os_log("Pose: %s", userselectedpose.rawValue)
//        os_log("Score: %f", score)
//        os_log("Detailed Score: ")
//        for s in detailedscore {
//            os_log("%f",s)
//        }
//        os_log("Comments: ")
//        for comment in comments {
//            os_log("%s", comment)
//        }

  }
    
}


