const { promises: fs } = require("fs");
const { join } = require("path");
const rootDir = process.cwd();

const packageJsonPath = join(rootDir, "package.json");
const patchFolderPath = join(rootDir, "patches");

async function main() {
  try {
    const packageJson = await readJsonFile(packageJsonPath);
    const dependencies = packageJson.dependencies || {};

    const patchFiles = await fs.readdir(patchFolderPath);
    const patchFilesToDelete = patchFiles
      .filter((file) => file.endsWith(".patch"))
      .filter((file) => {
        const packageName = getPackageNameFromPatch(file);
        return !dependencies[packageName];
      });

    await deletePatchFiles(patchFilesToDelete);
  } catch (err) {
    console.error(`Error: ${err.message}`);
    process.exit(1);
  }
}

async function readJsonFile(filePath) {
  const data = await fs.readFile(filePath, "utf8");
  return JSON.parse(data);
}

function getPackageNameFromPatch(fileName) {
  const cleanedFile = fileName.replace(/\+\d+\.\d+\.\d+\.patch$/, "");
  const parts = cleanedFile.split("+");

  return parts.length > 1 ? `${parts[0]}/${parts[1]}` : parts[0];
}

async function deletePatchFiles(files) {
  for (const file of files) {
    const filePath = join(patchFolderPath, file);
    try {
      await fs.unlink(filePath);
      console.log(`Deleted patch file: ${file}`);
    } catch (err) {
      console.error(`Error deleting patch file ${file}: ${err.message}`);
    }
  }
}

main();
