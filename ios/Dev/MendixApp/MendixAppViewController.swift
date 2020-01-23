import UIKit

class MendixAppViewController: UIViewController, ReactNativeDelegate {
  var mendixApp: MendixApp?

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let mendixApp = mendixApp else {
      fatalError("MendixApp not passed before starting the app")
    }

    ReactNative.instance().delegate = self
    ReactNative.instance().start(mendixApp)
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

  func setupMendixApp(_ mendixApp: MendixApp) {
    self.mendixApp = mendixApp
  }

  func onAppClosed() {
    self.navigationController?.popToRootViewController(animated: true)
  }
}
