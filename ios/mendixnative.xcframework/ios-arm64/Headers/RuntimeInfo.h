//
//  Copyright (c) Mendix, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RuntimeInfo: NSObject
@property (nonatomic, copy, readonly) NSString *cacheburst;
@property (nonatomic, readonly) long nativeBinaryVersion;
@property (nonatomic, readonly) long packagerPort;
@property (nonatomic, copy, readonly) NSString *version;

- (instancetype) initWithVersion:(NSString *)version cacheburst:(NSString *)cacheburst nativeBinaryVersion:(long)nativeBinaryVersion packagerPort:(long)packagerPort;
@end
