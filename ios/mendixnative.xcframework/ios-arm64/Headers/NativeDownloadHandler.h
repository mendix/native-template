//
//  Copyright (c) Mendix, Inc. All rights reserved.
//
#import <React/RCTBridgeModule.h>
#import <React/RCTEventEmitter.h>

@interface NativeDownloadHandler : NSObject<NSURLSessionDelegate>

@property (strong, nonnull) NSString *mimeType;
@property int connectionTimeout;
@property (copy, nonnull) void (^doneCallback)(void);
@property (copy, nonnull) void (^progressCallback)(long long, long long);
@property (copy, nonnull) void (^failCallback)(NSError *_Nullable err);
@property (strong, nonnull) NSString *downloadPath;

- (nonnull id)init:(NSDictionary * _Nullable)config doneCallback:(void (^_Nonnull)(void))doneCallback
  progressCallback:(void (^_Nullable)(long long, long long))progressCallback
      failCallback:(void (^_Nonnull)(NSError *_Nonnull err))failCallback;

- (void)download:(NSString *_Nonnull)url downloadPath:(NSString *_Nonnull)downloadPath;

@end

@interface NativeDownloadModule : RCTEventEmitter<RCTBridgeModule>

@end
