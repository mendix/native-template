module.exports = {
  dependencies: {
    'react-native-vision-camera-barcode-scanner': {
      platforms: {
        // Android only: on iOS the Barcode Scanner widget uses Apple's scanner from react-native-vision-camera.
        // This also keeps Google ML Kit, which has no arm64 iOS simulator support, out of the iOS app.
        ios: null,
      },
    },
  },
};
