# Native Template
## 1. Introduction
Native Template is the starting point for any Mendix Native App project. 
The repo is kept as close to a `react-native init` as possible. The only addition are the Mendix native libraries for Android and iOS and wiring to make everything work together nicely.

This repo is used as the baseline for Mendix Native Oven, a tool that automates the process of building your Native Apps with Mendix.

More advance developers may want to use it as a reference or starting point on how to setup their own Mendix App or include Mendix as an extra layer in their current apps.

## 2. High level description on how to build manually
### 2.1 Install dependencies
- `npm install`
- `cd ios && pod install`

### 2.2 Build your app bundle
To bundle your Mendix project please check the documentation to how to deploy your project with MxBuild. 

When done you should have a `index.android.bundle` and `index.ios.bundle` and your projects resources for each platform relative to the native deployement folder. 

These need to be moved in their respective places. 

**iOS**

- index.ios.bundle: `./ios/Bundle`
- resources: `./ios/img`

**Android**
- index.android.bundle: `./android/app/src/main/assets`
- resources: `./android/app/src/main/res/`

### 2.3 Building your apps
For iOS open the `xcworkspace` project with XCode and build as you would build any other iOS project.

For android open the `android` folder with Android Studio and build as you would any other Android project.

