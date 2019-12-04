import Foundation
import UIKit

class RoundedButton: UIButton {
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupLayout()
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setupLayout()
  }

  private func setupLayout() {
    layer.cornerRadius = frame.height / 2
  }
}
