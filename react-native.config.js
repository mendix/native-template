module.exports = {
    dependencies: {
        'react-native-firebase': {
            platforms: {
                // disable only on ios as we handle linking
                ios: null,
            },
        },
        'react-native-code-push': {
            platforms: {
                // disable only on Android as we require some conditional setup
                android: null,
                // would be linked only when the capability is enabled
                ios: null,
            },
        },
        'react-native-splash-screen': {
            platforms: {
                android: null,
                ios: null,
            },
        },
        'react-native-video': {
            platforms: {
              android: {
                sourceDir: '../node_modules/react-native-video/android-exoplayer',
              },
            },
        },
    },
};
