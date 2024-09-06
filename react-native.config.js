module.exports = {
    dependencies: {
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
    },
};
