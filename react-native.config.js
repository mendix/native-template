module.exports = {
    dependencies: {
        'react-native-firebase': {
            platforms: {
                // disable only on Android as we require some conditional setup
                android: null,
            },
        }
    },
};
