//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import "WarningsFilter.h"

@interface MxConfiguration : NSObject <RCTBridgeModule>
+ (NSString *) defaultDatabaseName;
+ (NSString *) defaultFilesDirectoryName;
+ (NSURL *) runtimeUrl;
+ (NSString *) databaseName;
+ (NSString *) filesDirectoryName;
+ (WarningsFilter) warningsFilter;
+ (void) setRuntimeUrl:(NSURL*)value;
+ (void) setDatabaseName:(NSString*)value;
+ (void) setFilesDirectoryName:(NSString*)value;
+ (void) setWarningsFilter:(WarningsFilter)value;
+ (void) setRemoteDebuggingPackagerPort:(int)port;
@end
