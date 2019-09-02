# Native Template
## 1. Introduction
Native Template is the starting point for any Mendix Native App project.
The repo is kept as close to a `react-native init` as possible. The only addition are the Mendix native libraries for Android and iOS and wiring to make everything work together nicely.

This repo is used as the baseline for [Mendix Native Builder](https://docs.mendix.com/howto/mobile/native-builder), a tool that automates the process of building your Native Apps with Mendix.

More advanced developers may want to use it as a reference or starting point on how to setup their own Mendix App or include Mendix as an extra layer in their current apps.

## 2. High level description on how to build manually
### 2.1 Install dependencies
Make sure that you have CocoaPods 1.7+ installed. Check with `pod --version` in the `ios` folder. If you have an older version update using `sudo gem install cocoapods`.

Afterwards execute the following commands:
- `npm install`
- `cd ios && pod install`

### 2.2 Build your app bundle
To bundle your Mendix project please check the documentation on how to deploy your project with [MxBuild](https://docs.mendix.com/refguide/mxbuild). Do not forget to pass the `--native-packager` flag.

When done you should have an `index.android.bundle` and an `index.ios.bundle` and your projects resources for each platform relative to the native deployement folder.

These need to be moved to their respective places.

**iOS**

- index.ios.bundle: `./ios/Bundle`
- resources: `./ios/Bundle/assets/img`

**Android**
- index.android.bundle: `./android/app/src/main/assets`
- resources: `./android/app/src/main/res/`

### 2.3 Building your apps
For iOS open the `xcworkspace` project with XCode and build as you would build any other iOS project.

For Android open the `android` folder with Android Studio and build as you would any other Android project.
