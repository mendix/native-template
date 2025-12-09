import UIKit
import MendixNative

class MendixAppViewController: UIViewController, ReactNativeDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    ReactNative.shared.delegate = self
    ReactNative.shared.start()
  }

  override var preferredStatusBarStyle: UIStatusBarStyle {
    return isAppeared ? .darkContent : .lightContent
  }
  
  private var isAppeared = false {
    didSet {
      setNeedsStatusBarAppearanceUpdate()
    }
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    isAppeared = true
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    isAppeared = false
  }

  func onAppClosed() {
    self.navigationController?.popToRootViewController(animated: true)
  }
}
