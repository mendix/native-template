module.exports = {
    dependencies: {
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
