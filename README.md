# Native Template

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![React Native](https://img.shields.io/badge/react_native-0.75.4-blue.svg)
![Node](https://img.shields.io/badge/node-v20-green.svg)

![Custom Dev App CI - Android](https://github.com/mendix/native-template/actions/workflows/android-build-custom-dev-app.yml/badge.svg?branch=master)
![Custom Dev App CI - iOS](https://github.com/mendix/native-template/actions/workflows/ios-build-custom-dev-app.yml/badge.svg?branch=master)

> **Compatible Mendix Studio Pro Versions**

![Studio Pro 10.19 and above](https://img.shields.io/badge/Studio_Pro-10.19_and_above-blue)

---

Native Template is the starting point for any Mendix Native App project.

This repo is used as the baseline for Mendix Native Mobile Builder, a GUI tool that automates the process of building your Native Apps with Mendix and is provided with Mendix Studio Pro.

Please refer to the [official how-to section](https://docs.mendix.com/howto/mobile/native-mobile) for Mendix Native Mobile.

Contact [Mendix support](https://support.mendix.com/hc/en-us) if assistance is required.

## Branching policy

### Master branch

Current master branch is the latest release, all the LTS versions live in `release/x.x.x`.

### Release branches

Official releases are done via the `release/x.x.x` branches. If you need a particular version, checkout the appropriate branch; latest should reflect the latest patch version released.

Otherwise, the GitHub releases also include a zipped version of the branch state they were created from. You can download and unzip that for further use.

To deduct which version of Native Template fits to your current Mendix Studio Pro version, please use the [mendix version json file](https://github.com/mendix/native-template/blob/master/mendix_version.json). It include a map of studio pro version ranges to Native template version ranges.

Example usage:

> **If you are using 10.18.x version of Studio Pro. Then use 11.x.x of Native Template.**

### Developer branches

Any other branches are considered developer branches.
Simply avoid using developer branches for private use. These are actively worked on branches and are definitely not available for public consumption.
