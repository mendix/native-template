const fs = require("fs");
const path = require("path");

// Function to read Android SDK version from build.gradle
function getAndroidSdkVersion() {
  try {
    const gradlePath = path.join(__dirname, "../../android/build.gradle");
    const gradleContent = fs.readFileSync(gradlePath, "utf8");

    // Extract all SDK versions from ext block
    const minSdkMatch = gradleContent.match(/minSdkVersion\s*=\s*(\d+)/);
    const compileSdkMatch = gradleContent.match(
      /compileSdkVersion\s*=\s*(\d+)/
    );
    const targetSdkMatch = gradleContent.match(/targetSdkVersion\s*=\s*(\d+)/);

    const versions = {
      minSdk: minSdkMatch ? minSdkMatch[1] : null,
      compileSdk: compileSdkMatch ? compileSdkMatch[1] : null,
      targetSdk: targetSdkMatch ? targetSdkMatch[1] : null,
    };

    if (minSdkMatch) console.log(`Found minSdkVersion: ${minSdkMatch[1]}`);
    if (compileSdkMatch)
      console.log(`Found compileSdkVersion: ${compileSdkMatch[1]}`);
    if (targetSdkMatch)
      console.log(`Found targetSdkVersion: ${targetSdkMatch[1]}`);

    return versions;
  } catch (error) {
    console.error("Error reading Android SDK version:", error);
    return null;
  }
}

// Function to read Gradle version from build.gradle
function getGradleVersion() {
  try {
    const gradlePath = path.join(__dirname, "../../android/build.gradle");
    const gradleContent = fs.readFileSync(gradlePath, "utf8");

    // Extract Gradle version
    const gradleMatch = gradleContent.match(
      /classpath\s+['"]com\.android\.tools\.build:gradle:([\d.]+)['"]/
    );
    if (gradleMatch) {
      console.log(`Found Gradle version: ${gradleMatch[1]}`);
      return gradleMatch[1];
    }

    console.log("Could not find Gradle version in build.gradle");
    return null;
  } catch (error) {
    console.error("Error reading Gradle version:", error);
    return null;
  }
}

// Function to read iOS minimum SDK version from Podfile
function getIosMinSdkVersion() {
  try {
    const podfilePath = path.join(__dirname, "../../ios/Podfile");
    const podfileContent = fs.readFileSync(podfilePath, "utf8");

    // Extract deployment_target value
    const deploymentTargetMatch = podfileContent.match(
      /deployment_target\s*=\s*['"]([\d.]+)['"]/
    );
    if (deploymentTargetMatch) {
      console.log(`Found iOS deployment target: ${deploymentTargetMatch[1]}`);
      return deploymentTargetMatch[1];
    }

    console.log("Could not find iOS deployment target in Podfile");
    return null;
  } catch (error) {
    console.error("Error reading iOS SDK version:", error);
    return null;
  }
}

// Function to update versions.json with new SDK versions
function updateVersionsJson() {
  try {
    // Read mendix_version.json to get the latest version
    const mendixVersionsPath = path.join(
      __dirname,
      "../../mendix_version.json"
    );
    const mendixVersionsContent = fs.readFileSync(mendixVersionsPath, "utf8");
    const mendixVersions = JSON.parse(mendixVersionsContent);

    // Get the latest version (first key in the object)
    const latestMendixVersion = Object.keys(mendixVersions)[0];
    const latestNativeTemplateVersion = mendixVersions[latestMendixVersion].min;

    // Read current native_template_versions.json
    const nativeTemplateVersionsPath = path.join(
      __dirname,
      "native_template_versions.json"
    );
    const nativeTemplateVersionsContent = fs.readFileSync(
      nativeTemplateVersionsPath,
      "utf8"
    );
    const nativeTemplateVersions = JSON.parse(nativeTemplateVersionsContent);

    // Get current SDK versions
    const androidSdk = getAndroidSdkVersion();
    const gradle = getGradleVersion();
    const iosMinSdk = getIosMinSdkVersion();

    // Check if the version already exists in native_template_versions.json
    if (!nativeTemplateVersions[latestMendixVersion]) {
      // Create new object with the latest version at the top
      const updatedVersions = {
        [latestMendixVersion]: {
          max: mendixVersions[latestMendixVersion].max,
          min: latestNativeTemplateVersion,
          androidSdk: {
            min: androidSdk?.minSdk || null,
            compile: androidSdk?.compileSdk || null,
            target: androidSdk?.targetSdk || null,
          },
          gradle: gradle,
          iosMinSdk: iosMinSdk,
        },
        ...nativeTemplateVersions,
      };

      // Write updated versions back to file
      fs.writeFileSync(
        nativeTemplateVersionsPath,
        JSON.stringify(updatedVersions, null, 4)
      );
    } else {
      console.log(
        `Version ${latestMendixVersion} already exists in native_template_versions.json`
      );
    }
  } catch (error) {
    console.error("Error updating versions:", error);
  }
}

// Export functions for use in other scripts
module.exports = {
  getAndroidSdkVersion,
  getGradleVersion,
  getIosMinSdkVersion,
  updateVersionsJson,
};
