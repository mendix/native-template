//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

@interface NativeReloadHandler : RCTEventEmitter
- (void) reloadClientWithState;
- (void) reload;
@end
