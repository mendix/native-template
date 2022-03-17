//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RuntimeInfo.h"

@interface RuntimeInfoResponse : NSObject
@property (nonatomic, copy, readonly) NSString *status;
@property (nonatomic, copy, readonly) RuntimeInfo *runtimeInfo;

- (instancetype) initWithStatus:(NSString *)status runtimeInfo:(RuntimeInfo *)runtimeInfo;
@end
