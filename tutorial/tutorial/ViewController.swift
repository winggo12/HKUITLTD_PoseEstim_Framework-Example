//
//  ViewController.swift
//  tutorial
//
//  Created by hkuit155 on 9/10/2020.
//

import UIKit
import AVFoundation
import HKUITLTD_PoseEstim_Framework

class ViewController: UIViewController {

    /// Test Cases
    public let la = [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    public let ra = [0, 0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0]
    public let ll = [0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 0, 0]
    public let rl = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1]
    public let ls = [0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    public let rs = [0, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0]
    public let lw = [0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0]
    public let rw = [0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0]
    ///
    
    @IBOutlet weak var previewView: PreviewView!
    @IBOutlet weak var overlayview: OverlayView!
    @IBOutlet weak var comment1: UILabel!
    @IBOutlet weak var comment2: UILabel!
    @IBOutlet weak var comment3: UILabel!
    @IBOutlet weak var pose: UILabel!
    @IBOutlet weak var score: UILabel!
    @IBAction func switchCamera(_ sender: UIButton) {
        self.cameraCapture.switchCamera()
    }
    
    private var overlayViewFrame:CGRect?
    private var previewViewFrame:CGRect?
    
    private lazy var cameraCapture = CameraFeedManager(previewView: previewView)
    private var thisModel: RunthisModel?
    
    var threadCount: Int = Constants.defaultThreadCount
    var delegate: Delegates = Constants.defaultDelegate
    
    private let minScore: Float = 0.6
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
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
        overlayViewFrame = overlayview.frame
        previewViewFrame = previewView.frame
        
        let orientation: UIDeviceOrientation = UIDevice.current.orientation
        
        switch orientation {
        case .portrait:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        case .portraitUpsideDown:
            previewView.previewLayer.connection?.videoOrientation = .portraitUpsideDown
        case .landscapeLeft:
            previewView.previewLayer.connection?.videoOrientation = .landscapeRight
        case .landscapeRight:
            previewView.previewLayer.connection?.videoOrientation = .landscapeLeft
        default:
            previewView.previewLayer.connection?.videoOrientation = .portrait
        }
    }

}

extension ViewController: CameraFeedManagerDelegate {
    func cameraFeedManagerDidEndSessionInterruption(_ manager: CameraFeedManager) {
        
    }
    
    func cameraFeedManagerDidEncounterSessionRunTimeError(_ manager: CameraFeedManager) {
        
    }
    
    func presentCameraPermissionsDeniedAlert(_ manager: CameraFeedManager) {
        
    }
    
    func presentVideoConfigurationErrorAlert(_ manager: CameraFeedManager) {
        
    }
    
    func cameraFeedManager(_ manager: CameraFeedManager, sessionWasInterrupted canResumeManually: Bool) {
        
    }
    
    func cameraFeedManager(_ manager: CameraFeedManager, didOutput pixelBuffer: CVPixelBuffer) {
        DispatchQueue.main.async {
            self.overlayViewFrame = self.overlayview.frame
            self.previewViewFrame = self.previewView.frame
        }
        
        let (result, _) = (thisModel?.Run(pb: pixelBuffer, olv: self.overlayViewFrame!, pv: self.previewViewFrame!))!
        let userSelectedPose = Pose.VirabhadrasanaALeft // select any one pose you like
        let feedback = GiveFeedBack(user_input_result: result, user_input_pose: userSelectedPose)
        let score = feedback.getScore()
        let comments = feedback.getComments()
        let colorBit = feedback.getColorBit()
            
        DispatchQueue.main.async {
            if result.score >= self.minScore {
                self.pose.text = userSelectedPose.rawValue
                self.score.text = String(score)
                self.comment1.text = comments[0]
//                self.comment2.text = comments[1]
//                self.comment3.text = comments[2]
                
                let position = self.cameraCapture.showCurrentInput()
                self.overlayview.drawResult(result: result, bounds: self.overlayview.bounds, position: position, wrong: colorBit)
            }
            else {
                self.overlayview.clear()
                return
            }
        }
    }
}
