//
//  CaptureViewController.swift
//  Example3
//
//  Created by admin on 26/01/2021.
//  Copyright © 2021 Hong Kong Univisual Intelligent Technology Limited. All rights reserved.
//

import os
import UIKit
import AVFoundation
import HKUITLTD_PoseEstim_Framework

    
class CaptureViewController: UIViewController {
    
    // Captured View & Estimated Pose View
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var overlayView: OverlayView!
    
    // Captured View Frame & Estimated Pose View Frame
    private var overlayViewFrame: CGRect?
    private var previewViewFrame: CGRect?
    
    private lazy var cameraCapture = CameraCapture(previewView: previewView)
    private var configurationSucceed = false
    
    // AI Model Related Instance Variables
    private var thisModel: RunthisModel?
    private let minimumScore: Float = 0.6
    private var givefeedback: GiveFeedBack? = nil
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurationSucceed = cameraCapture.startConfiguration()
        cameraCapture.delegate = self
        
        if configurationSucceed {
            thisModel = RunthisModel()
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraCapture.runSession()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        overlayViewFrame = overlayView.frame
        previewViewFrame = previewView.frame
        
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        cameraCapture.rotateScreen()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        cameraCapture.stopSession()
        
        self.overlayView.clear()
        
    }
    
    
    
    /// - Tag: Switch Camera
    @IBAction func switchCamera(_ cameraButton: UIButton) {

        cameraCapture.switchCamera(cameraButton: cameraButton)

    }

}
 

extension CaptureViewController: PoseEstimationDelegate {
    
    func poseEstimation(_ manager: CameraCapture, didOutput pixelBuffer: CVPixelBuffer) {

        DispatchQueue.main.async {
            self.overlayViewFrame = self.overlayView.frame
            self.previewViewFrame = self.previewView.frame
        }

        let (result,times) = (thisModel?.Run(pb: pixelBuffer, olv: self.overlayViewFrame!, pv: self.previewViewFrame!))!

        let userselectedpose: Pose = Pose.ArdhaVasisthasana
        if(givefeedback == nil) {
            givefeedback = GiveFeedBack(user_input_result: result, user_input_pose: userselectedpose)
        } else {
            givefeedback!.generateFeedback(user_input_result: result, user_input_pose: userselectedpose)
        }

        let score: Double = givefeedback!.getScore()
        let detailedscore: [Double] = givefeedback!.getDetailedScore()
        let comments: [String] = givefeedback!.getComments()
        let colorbit = givefeedback!.getColorBit()

        DispatchQueue.main.async {
            if result.score < self.minimumScore {
                self.overlayView.clear()
                return
            }
            
            self.overlayView.drawResult(result: result, bounds: self.overlayView.bounds, position: self.cameraCapture.getCameraPosition(), wrong: colorbit)

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



