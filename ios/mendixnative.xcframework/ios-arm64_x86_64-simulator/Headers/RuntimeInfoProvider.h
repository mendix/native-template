//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuntimeInfoResponse.h"

@interface RuntimeInfoProvider: NSObject
+ (void) getRuntimeInfo:(NSURL*) runtimeURL completionHandler:(void (^)(RuntimeInfoResponse *response))completionHandler;
@end
