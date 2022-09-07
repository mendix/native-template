//
//  Copyright (c) Mendix, Inc. All rights reserved.
//
#import <Foundation/Foundation.h>

#pragma mark - Paths

extern NSString *const MANIFEST_FILE_NAME;
extern NSString *const OTA_DIR_NAME;

#pragma mark - ErrorCodes

extern NSString *const INVALID_RUNTIME_URL;
extern NSString *const INVALID_DEPLOY_CONFIG;
extern NSString *const OTA_ZIP_FILE_MISSING;
extern NSString *const OTA_UNZIP_DIR_EXISTS;
extern NSString *const OTA_DEPLOYMENT_FAILED;
extern NSString *const INVALID_DOWNLOAD_CONFIG;
extern NSString *const OTA_DOWNLOAD_FAILED;

#pragma mark - Download Config Keys

extern NSString *const DOWNLOAD_CONFIG_URL_KEY;

#pragma mark - Deploy Config Keys

extern NSString *const DEPLOY_CONFIG_OTA_PACKAGE_KEY;
extern NSString *const DEPLOY_CONFIG_EXTRACTION_DIR;
extern NSString *const DEPLOY_CONFIG_OTA_DEPLOYMENT_ID_KEY;

#pragma mark - Manifest Keys

extern NSString *const MANIFEST_OTA_DEPLOYMENT_ID_KEY;
extern NSString *const MANIFEST_RELATIVE_BUNDLE_PATH_KEY;
extern NSString *const MANIFEST_APP_VERSION_KEY;
