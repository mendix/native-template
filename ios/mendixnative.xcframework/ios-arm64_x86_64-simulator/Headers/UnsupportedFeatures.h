//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnsupportedFeatures: NSObject
@property BOOL reloadInClient;
@property BOOL hideSplashScreenInClient;
- (id _Nonnull)init:(BOOL)reloadInClient;
- (id _Nonnull)init:(BOOL)reloadInClient hideSplashScreenInClient:(BOOL)hideSplashScreenInClient;
@end
