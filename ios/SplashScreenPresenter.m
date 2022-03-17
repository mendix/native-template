#import <MendixNative/ReactNative.h>
#import "SplashScreenPresenter.h"
#import "RNSplashScreen.h"
#import "StoryBoardSplash.m"

@implementation SplashScreenPresenter

- (void) show:(UIView * _Nullable)rootView {
  if (rootView != nil) {
    [RNSplashScreen showStoryBoard:@"LaunchScreen" inRootView:rootView];
  }
}

- (void) hide {
  [RNSplashScreen hideStoryBoard];
}

@end
