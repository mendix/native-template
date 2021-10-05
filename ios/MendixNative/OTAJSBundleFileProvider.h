//
//  Copyright (c) Mendix, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "JSBundleFileProviderProtocol.h"

@interface OtaJSBundleFileProvider : NSObject<JSBundleFileProviderProtocol>
+(nullable NSURL *)getBundleUrl;
@end
