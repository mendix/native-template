//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "WarningsFilter.h"

@interface MxConfiguration : NSObject <RCTBridgeModule>
+ (NSString *) defaultDatabaseName;
+ (NSString *) defaultFilesDirectoryName;
+ (NSURL *) runtimeUrl;
+ (NSString *) databaseName;
+ (NSString *) filesDirectoryName;
+ (NSString *) codePushKey;
+ (WarningsFilter) warningsFilter;
+ (void) setRuntimeUrl:(NSURL*)value;
+ (void) setDatabaseName:(NSString*)value;
+ (void) setFilesDirectoryName:(NSString*)value;
+ (void) setWarningsFilter:(WarningsFilter)value;
+ (void) setCodePushKey:(NSString*)value;
@end
