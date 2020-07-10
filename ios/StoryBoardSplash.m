#import <Foundation/Foundation.h>
#import "RNSplashScreen+StoryBoardSplash.h"

static UIView *loadingView = nil;

@implementation RNSplashScreen (StoryBoardSplash)

+ (void)showStoryBoard:(NSString *)name inRootView:(UIView *)rootView {
    if (!loadingView) {
        UIStoryboard *board = [UIStoryboard storyboardWithName:name bundle:[NSBundle mainBundle]];
        UIViewController *viewController = [board instantiateInitialViewController];
        loadingView = viewController.view;
        loadingView.frame = [[UIScreen mainScreen] bounds];
    }
    [rootView addSubview:loadingView];
}

+ (void)hideStoryBoard {
  dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
      [UIView animateWithDuration:0.3
           delay:0
         options:UIViewAnimationOptionCurveEaseIn
      animations:^{
          loadingView.alpha = 0.0;
      }
      completion:^(BOOL finished){
          [loadingView removeFromSuperview];
          loadingView.alpha = 1.0;
      }];
  });
}

@end
