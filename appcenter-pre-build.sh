#!/usr/bin/env bash
set -e

if [[ $SUPPORTS_MOBILE_TOOLKIT == True ]]; then
    echo "Configuring template with mobile toolkit"
    npm run configure
fi

INFO_PLIST=$APPCENTER_SOURCE_DIRECTORY/ios/$APPCENTER_XCODE_SCHEME/Info.plist
if [[ -e "$INFO_PLIST" && $IS_DEV_APP == False ]]; then
    echo "Stripping unwanted MendixNative (i386, x86_64) archs"
    LIB_PATH=$APPCENTER_SOURCE_DIRECTORY/ios/MendixNative/libMendix.a
    lipo -remove x86_64 -output $LIB_PATH $LIB_PATH || true
    lipo -remove i386 -output $LIB_PATH $LIB_PATH || true
    lipo -info $LIB_PATH || true

    echo "Updating Info.plist with code push key"
    plutil -replace "CodePushKey" -string $CODE_PUSH_KEY $INFO_PLIST || true

    cat $INFO_PLIST
fi

CODE_PUSH_KEY_FILE=$APPCENTER_SOURCE_DIRECTORY/android/app/src/main/res/raw/code_push_key
if [[ -e "$CODE_PUSH_KEY_FILE" && $IS_DEV_APP == False ]]; then
    echo "Updating Android code_push_key resource file with code push key"
    sed -i '' 's/.*/'$CODE_PUSH_KEY'/' $CODE_PUSH_KEY_FILE;

    cat $CODE_PUSH_KEY_FILE
fi
