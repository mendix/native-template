//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface NativeFsModule: NSObject<RCTBridgeModule>
+ (void) deleteFile:(NSString *)filePath;
+ (void) deleteDirectory:(NSString *)path;
@end
