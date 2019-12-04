import Foundation
import UIKit

class QRMaskView: UIView {
    override var bounds: CGRect {
        didSet {
            if let maskRect = userRect {
              self.mask(rect: maskRect)
            }
        }
    }

    private var userRect: CGRect?

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func mask(rect: CGRect) {
        userRect = rect
        let mask = CAShapeLayer()
        let path = UIBezierPath(roundedRect: userRect!, cornerRadius: 20)
        let multiplier = CGFloat(3)
        path.append(UIBezierPath(rect: CGRect(x: 0 - self.bounds.width, y: 0 - self.bounds.height, width: self.bounds.width * multiplier, height: self.bounds.height * multiplier)))
        mask.fillRule = kCAFillRuleEvenOdd
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
