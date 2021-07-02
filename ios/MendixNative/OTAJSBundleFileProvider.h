//
//  Copyright (c) Mendix, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>
#import "JSBundleFileProviderProtocol.h"

@interface OTAJSBundleFileProvider : NSObject<JSBundleFileProviderProtocol>

+(nonnull NSString *)getManifestPath;

+(nonnull NSString *)getBaseDirectory;

+(nullable NSURL *)getBundleUrl;

@end
