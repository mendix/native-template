import UIKit
import MendixNative
import RNBootSplash

class SplashScreenPresenter: SplashScreenPresenterProtocol {
  func show(_ rootView: UIView?) {
      if let rootView {
        RNBootSplash.showStoryBoard(.launchScreen, rootView: rootView)
      }
    }

    func hide() {
      RNBootSplash.hideStoryBoard()
    }
}

extension UIStoryboard {
    static let openApp: UIStoryboard = .init(name: "OpenApp", bundle: nil)
    static let launchTutorial: UIStoryboard = .init(name: "LaunchTutorial", bundle: nil)
    static let launchScreen: UIStoryboard = .init(name: "LaunchScreen", bundle: nil)
    static let launchApp: UIStoryboard = .init(name: "LaunchApp", bundle: nil)
}


extension RNBootSplash {
  static var loadingView: UIView? = nil

  static func showStoryBoard(_ storyboard: UIStoryboard, rootView: UIView) {
    if (loadingView == nil) {
      if let viewController = storyboard.instantiateInitialViewController() {
        loadingView = viewController.view
        loadingView!.frame = UIScreen.main.bounds
      }
    }
    if let loadingView {
      rootView.addSubview(loadingView)
    }
  }

  static func hideStoryBoard() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
        loadingView?.alpha = 0.0
      }, completion: {_ in
        loadingView?.removeFromSuperview()
        loadingView?.alpha = 1.0
      })
    }
  }
}
