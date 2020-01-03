#import "AppDelegate.h"
#import "MendixNative/MendixNative.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  NSBundle *mainBundle = [NSBundle mainBundle];
  NSString *targetName = [mainBundle objectForInfoDictionaryKey:@"TargetName"] ?: @"";

  if ([targetName  isEqual: @"dev"]) {
    return YES;
  }

  NSString *url = [mainBundle objectForInfoDictionaryKey:@"Runtime url"];
  if (url == nil) {
    [NSException raise:@"RuntimeURLMissing" format:@"Missing the 'Runtime url' configuration within the Info.plist file"];
  }
  NSURL *runtimeUrl = [AppUrl forRuntime:[url stringByReplacingOccurrencesOfString:@"\\" withString:@""]];
  NSURL *bundleUrl = [ReactNative.instance getJSBundleFile];
  
  [ReactNative.instance start:[[MendixApp alloc] init:nil bundleUrl:bundleUrl runtimeUrl:runtimeUrl warningsFilter:none enableGestures:false clearDataAtLaunch:false reactLoadingStoryboard:nil]];
  
  return YES;
}

@end
