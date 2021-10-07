//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <React/RCTBridgeModule.h>

@interface NativeOtaModule : NSObject <RCTBridgeModule>

+ (NSString *)resolveAppVersion;
+ (NSString *)resolveAbsolutePathRelativeToOtaDir:(NSString *)relativePath;
- (void)deploy:(NSDictionary *)config
      resolver:(RCTPromiseResolveBlock)resolve
      rejecter:(RCTPromiseRejectBlock)reject;
@end
