extension MendixReactWindow {
  open override var canBecomeFirstResponder: Bool {
    return true
  }

  open override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
    if (motion == .motionShake && ReactNative.instance.isActive()) {
      ReactNative.instance.showAppMenu();
    }
  }
}
