//
//  Copyright (c) Mendix, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface OtaHelpers : NSObject
+ (NSString *)resolveAppVersion;
+ (NSString *)getOtaDir;
+ (NSString *)getOtaManifestFilepath;
+ (NSString *)resolveAbsolutePathRelativeToOtaDir:(NSString *)relativePath;
+ (NSDictionary *)readManifestAsDictionary;
+ (NSDictionary *)getNativeDependencies;
@end
