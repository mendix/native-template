import Foundation
import MendixNative

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
}
