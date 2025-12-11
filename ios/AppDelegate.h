#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <UserNotifications/UNUserNotificationCenter.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate, UNUserNotificationCenterDelegate>

@property (nonatomic, strong) UIWindow *window;
@property BOOL shouldOpenInLastApp;
@property BOOL hasHandledLaunchAppWithOptions;
@end
