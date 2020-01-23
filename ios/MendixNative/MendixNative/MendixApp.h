#import <Foundation/Foundation.h>
//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import "UIKIt/UIKIt.h"
#import "WarningsFilter.h"
#import "AppMenuProtocol.h"

@interface MendixApp : NSObject
@property NSURL * _Nonnull bundleUrl;
@property NSURL  * _Nonnull runtimeUrl;
@property WarningsFilter warningsFilter;
@property NSString * _Nullable identifier;
@property BOOL enableGestures;
@property BOOL clearDataAtLaunch;
@property id<AppMenuProtocol> _Nullable appMenu;
@property UIStoryboard * _Nullable reactLoadingStoryboard;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter enableGestures:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch reactLoadingStoryboard:(UIStoryboard * _Nullable)reactLoadingStoryboard;
@end
