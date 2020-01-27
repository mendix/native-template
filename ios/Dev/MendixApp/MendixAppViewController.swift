import UIKit

class MendixAppViewController: UIViewController, ReactNativeDelegate {
  override func viewDidLoad() {
    super.viewDidLoad()

    ReactNative.instance.delegate = self
    ReactNative.instance.start()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    if #available(iOS 13.0, *) {
      UIApplication.shared.statusBarStyle = .darkContent
    } else {
      UIApplication.shared.statusBarStyle = .default
    }
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    UIApplication.shared.statusBarStyle = .lightContent
  }

  func onAppClosed() {
    self.navigationController?.popToRootViewController(animated: true)
  }
}
