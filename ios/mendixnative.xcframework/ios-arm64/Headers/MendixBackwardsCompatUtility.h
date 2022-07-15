//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UnsupportedFeatures.h"

extern const UnsupportedFeatures *DEFAULT_UNSUPPORTED_FEATURES;

@interface MendixBackwardsCompatUtility: NSObject
+ (NSDictionary<NSString *, UnsupportedFeatures *> *) versionDictionary;
+ (UnsupportedFeatures *) unsupportedFeatures;
+ (void) update:(NSString *)forVersion;
@end
