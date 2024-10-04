const { execSync } = require('child_process');
const { copyFileSync, unlinkSync } = require('fs');
const { join } = require("path");
const rootDir = process.cwd();

const patchOperations = [
    {
        dependency: "react-native-geocoder",
        patchFile: "react-native-geocoder+0.5.0.patch"
    },
    {
        dependency: "@react-native-firebase/app",
        patchFile: "@react-native-firebase+messaging+17.3.0.patch"
    }
];

function hasDependency(name) {
    try {
        require.resolve(name);
        return true;
    } catch (e) {
        return false;
    }
}

function applyPatch(patchFile) {
    const sourcePath = join(rootDir, "intermediary-patches", patchFile);
    const destPath = join(rootDir, "patches", patchFile);
    copyFileSync(sourcePath, destPath);
    console.log(`Applied patch: ${patchFile}`);
}

function removePatch(patchFile) {
    const patchFilePath = join(rootDir, "patches", patchFile);
    try {
        unlinkSync(patchFilePath);
        console.log(`Deleted patch file: ${patchFile}`);
    } catch (err) {
        if (err.code !== 'ENOENT') {
            console.error(`Error deleting patch file ${patchFile}: ${err.message}`);
        }
    }
}

patchOperations.forEach(({ dependency, patchFile }) => {
    if (hasDependency(dependency)) {
        applyPatch(patchFile);
    } else {
        removePatch(patchFile);
    }
});

execSync("npx patch-package", { cwd: rootDir, stdio: "inherit" });
