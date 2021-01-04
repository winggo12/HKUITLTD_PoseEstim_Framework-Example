import UIKit
import AVFoundation

/// UIView for rendering inference output.
public class OverlayView: UIView {

    private var fail = [Int]()
    public var dots = [CGPoint]()
    public var lines = [Line]()
    public var shapes = [CAShapeLayer]()
    private let zeroPoint = CGPoint(x: 0, y: 0)

    override public func draw(_ rect: CGRect) {
        for dot in self.dots {
            drawDot(of: dot)
        }
        for (index,line) in self.lines.enumerated() {
            drawLine(of: line, index: index)
        }
//        drawShape()
    }

    private func drawDot(of dot: CGPoint) {
        let dotRect = CGRect(
          x: dot.x - Traits.dot.radius / 2, y: dot.y - Traits.dot.radius / 2,
          width: Traits.dot.radius, height: Traits.dot.radius)
        let dotPath = UIBezierPath(ovalIn: dotRect)

        Traits.dot.color.setFill()
        dotPath.fill()
    }

    private func drawLine(of line: Line, index: Int) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: line.from.x, y: line.from.y))
        linePath.addLine(to: CGPoint(x: line.to.x, y: line.to.y))
        linePath.close()
        
        linePath.lineWidth = Traits.line.width
        if (index < 12 && fail.count > 0) {
            if (fail[index] == 1) {
                Traits.line.color = UIColor(red: 1, green: 0, blue: 0, alpha: 0.3)
            }
            else {
                Traits.line.color = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.6)
            }
        }
        else {
            Traits.line.color = UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.6)
        }
        Traits.line.color.setStroke()

        linePath.stroke()
    }
    
    // Added in 20201106, attempt to give better posture visualization
    private func drawShape() {
        self.layer.sublayers?.forEach{if $0.isKind(of: CAShapeLayer.self) {$0.removeFromSuperlayer()}}
        for shape in self.shapes
        {
            self.layer.addSublayer(shape)
        }
    }
    
    /*  call setNeedsDisplay() will trigger draw()
     *  user can call clear() and drawResult() directly to render the result
    */
    public func clear() {
        self.dots = []
        self.lines = []
//        self.shapes = []
        super.setNeedsDisplay()
    }

    public func drawResult(result: Result, bounds: CGRect, position: AVCaptureDevice.Position, wrong: [Int]){
        
        let width = bounds.maxX
        
        var mdots: [CGPoint] = []
        var mlines: [Line] = []
        if (position == .front) {
            for dot in result.dots {
                mdots.append(CGPoint(x: width - dot.x, y: dot.y))
            }
            for line in result.lines {
                let mlineFrom = CGPoint(x: width - line.from.x, y: line.from.y)
                let mlineTo = CGPoint(x: width - line.to.x, y: line.to.y)
                mlines.append(Line(from: mlineFrom, to: mlineTo))
            }
        }   else {
            mdots = result.dots
            mlines = result.lines
        }

        self.dots = mdots
        self.lines = mlines
        self.fail = wrong
//        self.shapes = result.shapes
        super.setNeedsDisplay()
    }
}

private enum Traits {
    static let dot = (radius: CGFloat(15), color: UIColor(red: 0, green: 0.3, blue: 0.6, alpha: 0.5))
    static var line = (width: CGFloat(8), color: UIColor(red: 0, green: 0.6, blue: 0, alpha: 0.6))
}
