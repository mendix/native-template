import MendixNative

extension MendixReactWindow {
  open override var canBecomeFirstResponder: Bool {
    return true
  }

  open override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
    if (motion == .motionShake && ReactAppProvider.isReactAppActive()) {
      DevHelper.showAppMenu();
    }
  }
}
