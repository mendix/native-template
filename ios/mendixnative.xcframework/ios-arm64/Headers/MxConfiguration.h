//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "WarningsFilter.h"

@interface MxConfiguration : NSObject <RCTBridgeModule>
+ (NSURL *) runtimeUrl;
+ (NSString *) appName;
+ (BOOL) isDeveloperApp;
+ (NSString *) databaseName;
+ (NSString *) filesDirectoryName;
+ (NSString *) codePushKey;
+ (WarningsFilter) warningsFilter;
+ (void) setRuntimeUrl:(NSURL*)value;
+ (void) setAppName:(NSString*)value;
+ (void) setDatabaseName:(NSString*)value;
+ (void) setFilesDirectoryName:(NSString*)value;
+ (void) setWarningsFilter:(WarningsFilter)value;
+ (void) setCodePushKey:(NSString*)value;
+ (void) setIsDeveloperApp:(BOOL)value;
@end
