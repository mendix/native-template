#import <Foundation/Foundation.h>
#import "RNSplashScreen.h"
 
@interface RNSplashScreen (StoryBoardSplash)
+ (void)showStoryBoard:(NSString *)name inRootView:(UIView *)rootView;
+ (void)hideStoryBoard;
@end
