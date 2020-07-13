
import UIKit
import AVFoundation

 /// The camera frame is displayed on this view.
public class PreviewView: UIView {
  public var previewLayer: AVCaptureVideoPreviewLayer {
    guard let layer = layer as? AVCaptureVideoPreviewLayer else {
      fatalError("Layer expected is of type VideoPreviewLayer")
    }
    return layer
  }

  public var session: AVCaptureSession? {
    get {
      return previewLayer.session
    }
    set {
      previewLayer.session = newValue
    }
  }

    override public class var layerClass: AnyClass {
    return AVCaptureVideoPreviewLayer.self
  }
}
