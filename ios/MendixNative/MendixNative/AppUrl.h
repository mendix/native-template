//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AppUrl: NSObject
+ (int) defaultRemoteDebuggingPackagerPort;

+ (NSURL *) forBundle:(NSString *)url port:(int)port isDebuggingRemotely:(BOOL)isDebuggingRemotely isDevModeEnabled:(BOOL)isDevModeEnabled;
+ (NSURL *) forRuntime:(NSString *)url;
+ (NSURL *) forValidation:(NSString*)url;
+ (BOOL) isValid:(NSString*)url;
@end
