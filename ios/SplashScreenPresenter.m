#import <MendixNative.h>
#import "SplashScreenPresenter.h"
#import <RNBootSplash.h>

@implementation SplashScreenPresenter

- (void) show:(UIView * _Nullable)rootView {
  if (rootView != nil) {
    [RNBootSplash initWithStoryboard:@"LaunchScreen" rootView:rootView];
  }
}

- (void) hide {
  [RNBootSplash hideWithFade:YES];
}

@end
