import UIKit

/// UIView for rendering inference output.
public class OverlayView: UIView {

  public var dots = [CGPoint]()
  public var lines = [Line]()

    override public func draw(_ rect: CGRect) {
        for dot in dots {
            drawDot(of: dot)
        }
        for line in lines {
            drawLine(of: line)
        }
    }

    private func drawDot(of dot: CGPoint) {
        let dotRect = CGRect(
          x: dot.x - Traits.dot.radius / 2, y: dot.y - Traits.dot.radius / 2,
          width: Traits.dot.radius, height: Traits.dot.radius)
        let dotPath = UIBezierPath(ovalIn: dotRect)

        Traits.dot.color.setFill()
        dotPath.fill()
    }

    private func drawLine(of line: Line) {
        let linePath = UIBezierPath()
        linePath.move(to: CGPoint(x: line.from.x, y: line.from.y))
        linePath.addLine(to: CGPoint(x: line.to.x, y: line.to.y))
        linePath.close()

        linePath.lineWidth = Traits.line.width
        Traits.line.color.setStroke()

        linePath.stroke()
    }
    
    /*  call setNeedsDisplay() will trigger draw()
     *  user can call clear() and drawResult() directly to render the result
    */
    public func clear() {
        self.dots = []
        self.lines = []
        super.setNeedsDisplay()
    }

    public func drawResult(result: Result){
        self.dots = result.dots
        self.lines = result.lines
        super.setNeedsDisplay()
    }
}

private enum Traits {
  static let dot = (radius: CGFloat(5), color: UIColor.orange)
  static let line = (width: CGFloat(1.0), color: UIColor.orange)
}
