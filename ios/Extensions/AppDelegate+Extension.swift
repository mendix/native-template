import Foundation
import MendixNative
import React_RCTAppDelegate
#if canImport(ReactAppDependencyProvider)
import ReactAppDependencyProvider
#endif

extension AppDelegate {
  
  func clearKeychain() {
    let KEY_HAS_RUN_BEFORE = "HAS_RUN_BEFORE"
    if UserDefaults.standard.bool(forKey: KEY_HAS_RUN_BEFORE) == false {
      UserDefaults.standard.set(true, forKey: KEY_HAS_RUN_BEFORE)
      KeychainHelper.clear()
    }
  }
  
  func setupUI() {
    UIDatePicker.appearance().preferredDatePickerStyle = .wheels
  }
  
  func showUnrecoverableDialog(title: String, message: String) {
    let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
    controller.addAction(.init(title: "Close", style: .default, handler: {_ in
      fatalError(message)
    }))
    window?.rootViewController?.present(controller, animated: true, completion: nil)
  }
  
  func setupApp(application: UIApplication, launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) {
    #if canImport(ReactAppDependencyProvider)
    let appDependencyProvider: any RCTDependencyProvider = RCTAppDependencyProvider()
    setUpProvider(dependencyProvider: appDependencyProvider)
    #else
    setUpProvider()
    #endif

    super.application(application, didFinishLaunchingWithOptions: launchOptions)
    clearKeychain()
    setupUI()
  }
}
