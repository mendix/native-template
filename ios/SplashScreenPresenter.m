#import "SplashScreenPresenter.h"
#import "ReactNative.h"
#import "RNSplashScreen.h"

@implementation SplashScreenPresenter

- (void) show:(UIView * _Nullable)rootView {
  if (rootView != nil) {
    [RNSplashScreen showSplash:@"LaunchScreen" inRootView:rootView];
  }
}

- (void) hide {
  [RNSplashScreen hide];
}

@end
