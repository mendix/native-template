//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AppMenuProtocol.h"
#import "SplashScreenPresenterProtocol.h"
#import "WarningsFilter.h"

@interface MendixApp : NSObject
@property NSURL * _Nonnull bundleUrl;
@property NSURL  * _Nonnull runtimeUrl;
@property WarningsFilter warningsFilter;
@property NSString * _Nullable identifier;
@property BOOL isDeveloperApp;
@property BOOL clearDataAtLaunch;
@property id<AppMenuProtocol> _Nullable appMenu;
@property id<SplashScreenPresenterProtocol> _Nullable splashScreenPresenter;
@property UIStoryboard * _Nullable reactLoading;
@property BOOL enableThreeFingerGestures;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter isDeveloperApp:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch splashScreenPresenter:(id<SplashScreenPresenterProtocol> _Nonnull)splashScreenPresenter;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter isDeveloperApp:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch reactLoading:(UIStoryboard * _Nonnull)reactLoading;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter isDeveloperApp:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch splashScreenPresenter:(id<SplashScreenPresenterProtocol> _Nonnull)splashScreenPresenter enableThreeFingerGestures:(BOOL)enableThreeFingerGestures ;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter isDeveloperApp:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch reactLoading:(UIStoryboard * _Nonnull)reactLoading enableThreeFingerGestures:(BOOL)enableThreeFingerGestures;

-(id _Nonnull)init:(NSString * _Nullable)identifier bundleUrl:(NSURL * _Nonnull)bundleUrl runtimeUrl:(NSURL * _Nonnull)runtimeUrl warningsFilter:(WarningsFilter)warningsFilter isDeveloperApp:(BOOL)enableGestures clearDataAtLaunch:(BOOL)clearDataAtLaunch;

@end
