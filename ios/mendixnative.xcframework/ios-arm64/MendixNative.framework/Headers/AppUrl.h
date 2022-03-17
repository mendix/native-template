//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUrl: NSObject
+ (int) defaultPackagerPort;

+ (NSURL *) forBundle:(NSString *)url port:(int)port isDebuggingRemotely:(BOOL)isDebuggingRemotely isDevModeEnabled:(BOOL)isDevModeEnabled;
+ (NSURL *) forRuntime:(NSString *)url;
+ (NSURL *) forValidation:(NSString*)url;
+ (NSURL *) forRuntimeInfo:(NSString*)url;
+ (NSURL *) forPackagerStatus:(NSString*)url port:(int)port;
+ (BOOL) isValid:(NSString*)url;
@end
