//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <React/RCTBridge.h>
#import <React/RCTBridgeDelegate.h>
#import <React/RCTReloadCommand.h>
#import "MendixApp.h"

@protocol ReactNativeDelegate;
@interface ReactNative: NSObject<RCTBridgeDelegate, RCTReloadListener> {
  RCTBridge *bridge;
  UIWindow *rootWindow;
  UIWindow *appWindow;
  MendixApp *mendixApp;
  NSURL *bundleUrl;
  NSString *codePushKey;
  NSDictionary *launchOptions;
  BOOL mendixOTAEnabled;
}

@property(nonatomic, weak) id<ReactNativeDelegate> delegate;
@property(class, nonatomic, readonly) ReactNative *instance;

+ (NSString *) warningsFilterToString:(WarningsFilter)warningsFilter;
- (void) setup:(MendixApp *)mendixApp launchOptions:(NSDictionary *)launchOptions;
- (void) setup:(MendixApp *)mendixApp launchOptions:(NSDictionary *)launchOptions mendixOTAEnabled:(BOOL)mendixOTAEnabled;
- (void) start;
- (BOOL) isActive;
- (NSURL *) getJSBundleFile;
- (BOOL) useCodePush;
- (void) showAppMenu;
- (void) showSplashScreen;
- (void) hideSplashScreen;
- (void) toggleElementInspector;
- (RCTBridge *) getBridge;
- (UIView * _Nullable) getRootView;
- (void) clearData;
- (void) clearAsyncStorage;
- (void) clearCookies;
- (void) stop;
- (void) reload;
- (BOOL) isDebuggingRemotely;
- (void) remoteDebugging:(BOOL)enable;
- (void) setRemoteDebuggingPackagerPort:(NSInteger)port;

@end

@protocol ReactNativeDelegate
- (void) onAppClosed;
@end
