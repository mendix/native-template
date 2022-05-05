//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppPreferences : NSObject
+ (NSString *) getAppUrl;
+ (void) setAppUrl:(NSString *)url;
+ (BOOL) devModeEnabled;
+ (void) devMode:(BOOL)enable;
+ (BOOL) remoteDebuggingEnabled;
+ (void) remoteDebugging:(BOOL)enable;
+ (void) setRemoteDebuggingPackagerPort:(NSInteger)port;
+ (int) getRemoteDebuggingPackagerPort;
+ (BOOL) isElementInspectorEnabled;
+ (void) setElementInspector:(BOOL)enable;
@end
