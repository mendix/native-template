extension MendixReactWindow {
  open override var canBecomeFirstResponder: Bool {
    return true
  }

  open override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
    if (motion == .motionShake) {
      ReactNative.instance.showAppMenu();
    }
  }
}
