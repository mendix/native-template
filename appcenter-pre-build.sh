#!/usr/bin/env bash

INFO_PLIST=$APPCENTER_SOURCE_DIRECTORY/ios/$APPCENTER_XCODE_SCHEME/Info.plist
if [[ -e "$INFO_PLIST" ]]; then
    echo "Updating Info.plist with code push key"
    plutil -replace "Codepush key" -string $CODE_PUSH_KEY $INFO_PLIST

    cat $INFO_PLIST
fi

CODE_PUSH_KEY_FILE=$APPCENTER_SOURCE_DIRECTORY/android/app/src/main/res/raw/code_push_key
if [[ -e "$CODE_PUSH_KEY_FILE" ]]; then
    echo "Updating Android code_push_key resource file with code push key"
    sed -i '' 's/.*/'$CODE_PUSH_KEY'/' $CODE_PUSH_KEY_FILE;

    cat $CODE_PUSH_KEY_FILE
fi