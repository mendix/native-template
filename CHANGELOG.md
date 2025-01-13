# Changelog

All notable changes to this template will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/), and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

- We have resolved an issue where remote JavaScript debugging failed in a custom-built Mendix Native Developer App, leading to crashes when enabling “Remote JS Debugging.” The problem was caused by Firebase services not being initialized properly during the build process. We have ensured that Firebase dependencies are now only included when explicitly required by the application.

# [7.0.23] - 2025-01-07

- We have updated the AppCenter's Xcode version to 15.4.

# [7.0.22] - 2025-01-03

- We have updated the implementation of the registerReceiver method to align with Android SDK 34 and above.

# [7.0.20] - 2024-12-23

- We have updated min sdk to 23 on android.

# [7.0.19] - 2024-10-01

- We have updated `react-native-permissions` to version `3.6.1`.

# [7.0.17] - 2024-09-03

- We have fixed OTA updates compatibility issues on iOS 18.

# [7.0.16] - 2024-08-29

- We've resolved a build error related to Flipper on Xcode 15.3.

# [7.0.15] - 2024-08-1

- Upgraded buildToolsVersion, compileSdkVersion, and targetSdkVersion to 34 for Android.

# [7.0.14] - 2024-06-28

- We enhanced encrypted file sync on Android.

# [7.0.13] - 2024-06-05

- We enhanced encrypted file sync on Android.

# [7.0.12] - 2024-05-27

- We've added the support of scheduling local notifications on Android 14

# [7.0.11] - 2024-05-13

- We've made the switch to Xcode 15.1 for cloud builds (Appcenter), in response to the updated minimum iOS sdk requirements.
- We have added a basic privacy manifest to iOS.

# [7.0.10] - 2024-03-15

- We updated the Android manifest file to support opening URLs with links to websites whose apps are installed on the device.

## [7.0.9] - 2023-10-13

### Fixed

- We fixed build errors caused by the recent XCode 15 update.

## [7.0.8] - 2023-09-25

### Fixed

- We have enhanced file encryption on Android.

## [7.0.7] - 2023-09-22

### Fixed

- We have updated clearKeychain method to clear only necessary data.

## [7.0.6] - 2023-09-15

- Introduced `com.google.android.gms.permission.AD_ID` permission to the Android Manifest file. This permission governs access to the advertising ID, facilitating more effective targeting and personalization within the app's advertisement services. (Note: This permission is currently disabled with the tools:node="remove" attribute.)

## [7.0.5] - 2023-08-23

### Fixed

- We upgraded android SDK version to 33

## [7.0.3] - 2023-08-08

### Fixes

- We fixed distorted splash screen issue for android

## [7.0.2] - 2023-08-01

### Fixes

- We fixed an issue with QR code scanner not working on iOS version of the custom dev app

## [6.2.25] - 2022-08-16

### Fixes

- Update ndk version to match AppCenter
- Update `react-native-permissions` library
- Removed `mendix.templateVersion` from package.json

## [6.2.24] - 2022-07-26

### Fixes

- We fixed an issue while uploading an iOS application to App Store
- We fixed crashes on Xiaomi smartphones
- We fixed an issue while building Android apps on AppCenter

## [6.2.23] - 2022-07-16

### Fixes

- We updated the minimum version of iOS to 14
- We remove QUERY_ALL_PACKAGES permission for Android apps
- We updated the version of react-native-vector-icons to 9.1.0
- We fixed an issue while building iOS apps in AppCenter

## [5.2.13] - 2022-06-15

### Fixes

- We fixed an issue with the date picker not being visible in dark mode.

## [6.2.22] - 2022-06-02

### Fixes

- We fixed an iOS build issue (#150964, #150934)

## [6.2.21] - 2022-06-01

### Fixes

- We fixed an iOS build issue for projects using Crashlytics.

## [6.2.20] - 2022-05-30

### Fixes

- We fixed an issue with logout action (Ticket #147429)

## [5.0.14] - 2022-05-17

### Fixes

- We fixed an issue with JCenter on Android and CocoaPods on iOS, which would fail to build (Ticket #148798 #148819 #148830 #148840)

## [5.1.19] - 2022-05-11

### Fixes

- We fixed an issue with JCenter on Android and CocoaPods on iOS, which would fail to build (Ticket #148798 #148819 #148830 #148840)

## [6.2.19] - 2022-05-11

### Fixes

- We fixed an issue with CocoaPods on iOS, which would fail to build

## [6.2.18] - 2022-05-11

### Fixes

- We fixed an issue with JCenter on Android, which would fail to build (Ticket #148798 #148819 #148830 #148840)

## [5.2.12] - 2022-05-11

### Fixes

- We fixed an issue with CocoaPods on iOS, which would fail to build

## [5.2.11] - 2022-05-10

### Fixes

- We fixed an issue with JCenter on Android, which would fail to build (Ticket #148798 #148819 #148830 #148840)

## [6.2.16] - 2022-03-29

### Fixes

- We fixed an issue with App Center CodePush on Android which would fail to install new OTA updates on devices. (Ticket 145335)

## [5.2.9] - 2022-03-29

### Improvements

- Native Template now supports full-screen Android video. The full-screen icon can be found at the top of the video when the show control's property is set to `true`. When the icon is pressed the video will continue working on an overlay modal. (Ticket 135581)

## [6.2.15] - 2022-03-23

### Fixes

- We fixed an issue where iOS custom developer apps incurred problems while building.

## [6.2.14] - 2022-03-17

### Fixes

- We fixed an issue where using react-native-async-storage made the iOS build fail due to duplicated symbols being generated.
- We fixed an issue where compiling an Android app for release would fail when building on a Windows machine.

## [6.2.13] - 2022-03-16 [YANKED]

### Fixes

## [6.2.12] - 2022-01-25

### Fixes

- We identified and fixed an issue that would stop the "Navigate To" action from launching Google Maps on Android OS version 11 and later.

## [5.2.8] - 2022-01-25

### Fixes

- We identified and fixed an issue that would stop the "Navigate To" action from launching Google Maps on Android OS version 11 and later.

## [6.2.11] - 2022-01-06

### Summary

- We identified and fixed a bug introduced with Native Template v6.2.9 and Mendix clients built with Mendix Studio Pro 9.8.0 or later and that support the new mobile encryption features. The iOS apps would wrongly clear the keychain values on each restart forcing users of the app to re-authenticate on each app restart.

_Rebuilding and releasing a new iOS app with this Native Template version will solve the issue._

### Fixes

- OS apps should correctly persist the user session after each restart for clients built with Mendix Studio Pro 9.8.0 or later. (Ticket 138881)
