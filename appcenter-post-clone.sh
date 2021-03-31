#!/usr/bin/env bash
set -e

# Untar bundle resources
if [ -f "./android/res.tar.gz" ]; then 
    tar xvzf "./android/res.tar.gz" -C "./android/app/src/main/res" && sudo find "./android/app/src/main/res/." -type d -exec chmod u+rwx {} \;
fi

# # Untar bundle resources
if [ -f "./ios/Bundle/assets.tar.gz" ]; then
    mkdir "./ios/Bundle/assets"
    tar xvzf "./ios/Bundle/assets.tar.gz" -C "./ios/Bundle/assets" && sudo find "./ios/Bundle/assets/." -type d -exec chmod u+rwx {} \;
fi
