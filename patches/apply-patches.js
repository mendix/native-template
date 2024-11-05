const { execSync } = require('child_process');
const { copyFileSync } = require('fs');
const { join } = require("path");
const rootDir = process.cwd();

// We check if geocoder lib is added via widget/js action and then apply patch if necessary
if (hasDependency("react-native-geocoder")){
    copyFileSync(join(rootDir, "intermediary-patches/react-native-geocoder+0.5.0.patch"), join(rootDir, "patches/react-native-geocoder+0.5.0.patch"))
}
// We execute patch-package normally after copy or not the patch(es)
execSync("npx patch-package", {cwd: rootDir, stdio: "inherit"});

function hasDependency(name) {
    try {
        require.resolve(name);
        return true;
    } catch (e) {
        return false;
    }
}
