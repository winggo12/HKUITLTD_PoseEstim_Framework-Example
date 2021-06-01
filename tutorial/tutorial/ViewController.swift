//
//  ViewController.swift
//  tutorial
//
//  Created by hkuit155 on 9/10/2020.
//

import UIKit
import AVFoundation
import HKUITLTD_PoseEstim_Framework
import OpalImagePicker
import Photos

class ViewController: UIViewController, OpalImagePickerControllerDelegate {

    // MARK: - TEST USE
    var imageCnt = 0
    let documentInteractionController = UIDocumentInteractionController()
    let jsoner = EvaluateUtils()
    var pickerDismissed: Bool = false
    var processFinished: Bool = false
    var nameList: [String] = [String]()
    @IBAction func outputJson(_ sender: UIBarButtonItem) {
        let _ = jsoner.genJson()
//        self.share(url: filePath)
    }
    // MARK: -
    
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
    
    @IBOutlet weak var grayView: UIImageView!
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
    @IBAction func useCamera(_ sender: Any) {
        for layer in self.previewView.layer.sublayers! {
             if layer.name == "photo" {
                  layer.removeFromSuperlayer()
             }
         }
        self.cameraCapture.checkCameraConfigurationAndStartSession()
    }
    @IBAction func usePhoto(_ sender: Any) {
        self.cameraCapture.stopSession()
        let imagePicker = OpalImagePickerController()
        imagePicker.imagePickerDelegate = self
        presentOpalImagePickerController(imagePicker, animated: true, select: { (assets) in
            //Save Images, update UI
            let imageSet = self.getAssetThumbnail(assets: assets)
            self.detectImageSet(images: imageSet)
            //Dismiss Controller
            imagePicker.dismiss(animated: true, completion: nil)
            self.pickerDismissed = true
            if self.processFinished {
                self.processFinished = false
                self.pickerDismissed = false
                self.showFinished()
            }
        }, cancel: {
           //Cancel action?
            
       })
    }
    
    private var alertController:UIAlertController?
    private let conQueue = DispatchQueue(label: "detect queue", attributes: .concurrent)
    
    private var overlayViewFrame:CGRect?
    private var previewViewFrame:CGRect?
    
    private lazy var cameraCapture = CameraFeedManager(previewView: previewView)
    private var thisModel: RunthisModel?
    
    var threadCount: Int = Constants.defaultThreadCount
    var delegate: Delegates = Constants.defaultDelegate
    
    private let minScore: Float = 0.3
    
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
    
    // MARK: - self function
    func getAssetThumbnail(assets: [PHAsset]) -> [UIImage] {
        self.nameList.removeAll()
        var arrayOfImages = [UIImage]()
        for asset in assets {
            let manager = PHImageManager.default()
            let option = PHImageRequestOptions()
            var image = UIImage()
            option.isSynchronous = true
            manager.requestImage(for: asset, targetSize: PHImageManagerMaximumSize, contentMode: .aspectFit, options: option, resultHandler: {(result, info)->Void in
                image = result!
                arrayOfImages.append(image)
            })
            self.nameList.append(asset.originalFilename ?? "nil")
        }
        return arrayOfImages
    }
    
    func detectImageSet(images: [UIImage]) {
        self.conQueue.sync {
            jsoner.clearImageData()
            for index in 0..<images.count {
                let (resSw, _) = (thisModel?.Run(pb: self.buffer(from: images[index])!, olv: self.overlayViewFrame!, pv: self.previewViewFrame!))!
                jsoner.addImageData(data: resSw, name: self.nameList[index], cnt: self.imageCnt)
                self.imageCnt += 1
            }
            self.processFinished = true
            // Show alert when finished
            if self.pickerDismissed {
                self.pickerDismissed = false
                self.processFinished = false
                showFinished()
            }
        }
    }
    
    func showFinished() {
        let finishAlert = UIAlertController(title: "Finished processing", message: "Do you want to save the result as JSON file?", preferredStyle: .alert)
        let saveOption = UIAlertAction(title: "Save", style: .default) { (_) in
            let filePath = self.jsoner.genJson()
//            self.share(url: filePath)
         }
        let cancelOption = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        finishAlert.addAction(cancelOption)
        finishAlert.addAction(saveOption)
        self.present(finishAlert, animated: true, completion: nil)
    }
    
    func grayscale(image: UIImage) -> UIImage? {
        let context = CIContext(options: nil)
        if let filter = CIFilter(name: "CIPhotoEffectMono") {
            filter.setValue(CIImage(image: image), forKey: kCIInputImageKey)
            if let output = filter.outputImage {
                if let cgImage = context.createCGImage(output, from: output.extent) {
                    return UIImage(cgImage: cgImage)
                }
            }
        }
        return nil
    }
    
    
    // MARK: -

} // ViewController

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
        self.conQueue.sync {
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
    
    func grayImageManager(imageOutput: UIImage?) {
        DispatchQueue.main.async {
            self.grayView.image = imageOutput
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.cameraCapture.checkCameraConfigurationAndStartSession()
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = (info[UIImagePickerController.InfoKey.originalImage] as? UIImage) {
            photoLibraryOutput(image: image)
        }
        self.dismiss(animated: true, completion: nil)
    }
    
    func showErrorAlert(title: String, message: String) {
        if let ac = alertController {
            ac.title = title
            ac.message = message
        } else {
            alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
            let cancel = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController!.addAction(cancel)
        }
        self.present(alertController!, animated: true, completion: nil)
    }
    
    func showPhotoPicker(type: UIImagePickerController.SourceType) {
        let photoPicker = UIImagePickerController()
        photoPicker.sourceType = type
        photoPicker.allowsEditing = false
        photoPicker.delegate = self
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    func buffer(from image: UIImage) -> CVPixelBuffer? {
      let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
      var pixelBuffer : CVPixelBuffer?
      let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(image.size.width), Int(image.size.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
      guard (status == kCVReturnSuccess) else {
        return nil
      }

      CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
      let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)

      let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
      let context = CGContext(data: pixelData, width: Int(image.size.width), height: Int(image.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)

      context?.translateBy(x: 0, y: image.size.height)
      context?.scaleBy(x: 1.0, y: -1.0)

      UIGraphicsPushContext(context!)
      image.draw(in: CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height))
      UIGraphicsPopContext()
      CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))

      return pixelBuffer
    }
    
    func photoLibraryOutput(image: UIImage) {
        DispatchQueue.main.async {
            self.overlayViewFrame = self.overlayview.frame
            self.previewViewFrame = self.previewView.frame
        }
        
        //MARK: Need an UIImage to CVPixelBuffer function
        
        self.conQueue.sync {
            let (result, _) = (thisModel?.Run(pb: self.buffer(from: image)!, olv: self.overlayViewFrame!, pv: self.previewViewFrame!))!
            let userSelectedPose = Pose.VirabhadrasanaALeft // select any one pose you like
            let feedback = GiveFeedBack(user_input_result: result, user_input_pose: userSelectedPose)
            let score = feedback.getScore()
//            let comments = feedback.getComments()
            let colorBit = feedback.getColorBit()
                
            DispatchQueue.main.async {
                if result.score >= self.minScore {
                    self.pose.text = userSelectedPose.rawValue
                    self.score.text = String(score)
//                    self.comment1.text = comments[0]
                    
                    let position = self.cameraCapture.showCurrentInput()
                    
                    
                    let photoLayer: CALayer = {
                        let layer = CALayer()
                        let view = image.cgImage
                        layer.name = "photo"
                        layer.frame = self.previewViewFrame!
                        layer.contents = view
                        layer.contentsGravity = CALayerContentsGravity.resizeAspectFill
                        return layer
                    }()
                    self.previewView.layer.addSublayer(photoLayer)
                    
                    
                    self.overlayview.drawResult(result: result, bounds: self.overlayview.bounds, position: position, wrong: colorBit)
                }
                else {
                    self.overlayview.clear()
                    return
                }
            }
        }
    } //photoLibraryOutput
} //UIImagePickerControllerDelegate, UINavigationControllerDelegate

// MARK: - OpalImagePicker

extension PHAsset {
    var originalFilename: String? {
        return PHAssetResource.assetResources(for: self).first?.originalFilename
    }
}
extension ViewController: UIDocumentInteractionControllerDelegate {
    /// If presenting atop a navigation stack, provide the navigation controller in order to animate in a manner consistent with the rest of the platform
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        guard let navVC = self.navigationController else {
            return self
        }
        return navVC
    }
    func share(url: URL) {
        documentInteractionController.url = url
        documentInteractionController.uti = url.typeIdentifier ?? "public.data, public.content"
        documentInteractionController.name = url.localizedName ?? url.lastPathComponent
        documentInteractionController.presentPreview(animated: true)
    }
}
extension URL {
    var typeIdentifier: String? {
        return (try? resourceValues(forKeys: [.typeIdentifierKey]))?.typeIdentifier
    }
    var localizedName: String? {
        return (try? resourceValues(forKeys: [.localizedNameKey]))?.localizedName
    }
}
