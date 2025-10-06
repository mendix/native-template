#import <MendixNative.h>
#import "SplashScreenPresenter.h"
#import "RNBootSplash.h"
#import "StoryBoardSplash.m"

@implementation SplashScreenPresenter

- (void) show:(UIView * _Nullable)rootView {
  if (rootView != nil) {
    [RNBootSplash showStoryBoard:@"LaunchScreen" inRootView:rootView];
  }
}

- (void) hide {
  [RNBootSplash hideStoryBoard];
}

@end
