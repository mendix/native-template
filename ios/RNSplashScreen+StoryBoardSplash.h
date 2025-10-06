#import <Foundation/Foundation.h>
#import "RNBootSplash.h"

@interface RNBootSplash (StoryBoardSplash)
+ (void)showStoryBoard:(NSString *)name inRootView:(UIView *)rootView;
+ (void)hideStoryBoard;
@end
