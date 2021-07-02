//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTEventEmitter.h>

@interface NativeReloadHandler : RCTEventEmitter<RCTBridgeModule>
- (void) reloadClientWithState;
- (void) reload;
- (void) exitApp;
@end
