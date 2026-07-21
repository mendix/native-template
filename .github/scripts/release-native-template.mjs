import fs from "fs";
import os from "os";
import path from "path";
import { Octokit } from "@octokit/rest";
import { fileURLToPath } from "url";
import simpleGit from "simple-git";

const required = [
  "MENDIX_MOBILE_DOCS_PR_GITHUB_PAT",
  "STUDIO_PRO_MAJOR",
];

const missing = required.filter((k) => !process.env[k]);
if (missing.length) {
  console.error("Missing env vars:", missing.join(", "));
  process.exit(1);
}

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
const DOCS_CLONE_PREFIX = "mendix-docs-";

const MENDIX_MOBILE_DOCS_PR_GITHUB_PAT =
  process.env.MENDIX_MOBILE_DOCS_PR_GITHUB_PAT;

const NATIVE_TEMPLATE_VERSION = readVersionFromPackageJson();
const NATIVE_TEMPLATE_MAJOR = NATIVE_TEMPLATE_VERSION.split(".")[0];
const STUDIO_PRO_MAJOR = process.env.STUDIO_PRO_MAJOR;

const GIT_AUTHOR_NAME = "MendixMobile";
const GIT_AUTHOR_EMAIL = "moo@mendix.com";

// Docs Repo Settings
const DOCS_REPO_NAME = "docs";
const DOCS_REPO_OWNER = "MendixMobile";
const DOCS_UPSTREAM_OWNER = "mendix";
const DOCS_BRANCH_NAME = `update-native-template-release-notes-v${NATIVE_TEMPLATE_VERSION}`;

const DOCS_PARENT_DIR = `content/en/docs/releasenotes/mobile/native-template/nt-studio-pro-${STUDIO_PRO_MAJOR}-parent`;
const TARGET_FILE = `${DOCS_PARENT_DIR}/nt-${NATIVE_TEMPLATE_MAJOR}-rn.md`;

const octokit = new Octokit({ auth: MENDIX_MOBILE_DOCS_PR_GITHUB_PAT });

function extractUnreleasedChangelog() {
  const changelogPath = path.resolve(
    path.join(__dirname, "..", "..", "CHANGELOG.md"),
  );
  const changelog = fs.readFileSync(changelogPath, "utf-8");
  const unreleasedRegex =
    /^## \[Unreleased\](.*?)(?=^## \[\d+\.\d+\.\d+\][^\n]*|\Z)/ms;
  const match = changelog.match(unreleasedRegex);
  if (!match) throw new Error("No [Unreleased] section found!");
  const unreleasedContent = match[1].trim();
  if (!unreleasedContent) throw new Error("No changes under [Unreleased]!");
  return unreleasedContent;
}

function buildFrontmatter() {
  return `---\ntitle: "Native Template ${NATIVE_TEMPLATE_MAJOR}"\nurl: /releasenotes/mobile/nt-${NATIVE_TEMPLATE_MAJOR}-rn/\nweight: 1\ndescription: "Native Template ${NATIVE_TEMPLATE_MAJOR}"\n---`;
}

// Docs
function injectUnreleasedToDoc(docPath, unreleasedContent) {
  if (!fs.existsSync(DOCS_PARENT_DIR)) {
    throw new Error(
      `Parent directory not found: ${DOCS_PARENT_DIR}\nA new Studio Pro parent folder requires manual setup in the docs repo.`,
    );
  }

  const date = new Date();
  const formattedDate = date.toLocaleDateString("en-US", {
    year: "numeric",
    month: "short",
    day: "numeric",
  });
  const releaseHeading = `## ${NATIVE_TEMPLATE_VERSION}\n\n**Release date: ${formattedDate}**`;

  if (!fs.existsSync(docPath)) {
    console.log(`${docPath} not found — creating new file for Native Template ${NATIVE_TEMPLATE_MAJOR}.`);
    return `${buildFrontmatter()}\n\n${releaseHeading}\n\n${unreleasedContent}\n`;
  }

  const doc = fs.readFileSync(docPath, "utf-8");
  const frontmatterMatch = doc.match(/^---[\s\S]*?---/);
  if (!frontmatterMatch) throw new Error("Frontmatter not found!");
  const frontmatter = frontmatterMatch[0];
  const rest = doc.slice(frontmatter.length).trimStart();

  const firstReleaseHeadingIndex = rest.search(/^##\s+\d+\.\d+\.\d+/m);
  const beforeReleases =
    firstReleaseHeadingIndex > 0
      ? `${rest.slice(0, firstReleaseHeadingIndex).trimEnd()}\n\n`
      : "";
  const releaseSections =
    firstReleaseHeadingIndex >= 0
      ? rest.slice(firstReleaseHeadingIndex).trimStart()
      : rest.trimStart();

  return `${frontmatter}\n\n${beforeReleases}${releaseHeading}\n\n${unreleasedContent}\n\n${releaseSections}`;
}

// This file exists only in the fork (MendixMobile/docs) and not in upstream (mendix/docs).
// Removing it in our branch ensures it doesn't appear in the cross-fork PR diff.
const FORK_SYNC_FILE = ".github/workflows/sync.yml";

async function cloneDocsRepo() {
  const git = simpleGit();
  const docsCloneDir = fs.mkdtempSync(
    path.join(os.tmpdir(), DOCS_CLONE_PREFIX),
  );

  await git.clone(
    `https://x-access-token:${MENDIX_MOBILE_DOCS_PR_GITHUB_PAT}@github.com/${DOCS_REPO_OWNER}/${DOCS_REPO_NAME}.git`,
    docsCloneDir,
    ["--depth", "1"],
  );

  process.chdir(docsCloneDir);

  await git.addConfig("user.name", GIT_AUTHOR_NAME, false, "global");
  await git.addConfig("user.email", GIT_AUTHOR_EMAIL, false, "global");
}

async function checkoutLocalBranch(git) {
  await git.checkoutLocalBranch(DOCS_BRANCH_NAME);
}

async function updateDocsNTReleaseNotes(unreleasedContent) {
  const newDocContent = injectUnreleasedToDoc(TARGET_FILE, unreleasedContent);
  fs.writeFileSync(TARGET_FILE, newDocContent, "utf-8");
}

async function createPRUpdateDocsNTReleaseNotes(git) {
  // Remove the fork's sync.yml so it doesn't appear in the cross-fork PR diff.
  if (fs.existsSync(FORK_SYNC_FILE)) {
    await git.rm(FORK_SYNC_FILE);
  }
  await git.add(TARGET_FILE);
  await git.commit(
    `docs: update mobile release notes for v${NATIVE_TEMPLATE_VERSION}`,
  );
  await git.push("origin", DOCS_BRANCH_NAME, ["--force"]);

  const prBody = `
Automated sync of the latest release notes for v${NATIVE_TEMPLATE_VERSION} from [native-template](https://github.com/mendix/native-template).

---

**Note:**  
This pull request was automatically generated by an automation process managed by the Mobile team.
**Please do not take any action on this pull request unless it has been reviewed and approved by a member of the Mobile team.**
`;

  await octokit.pulls.create({
    owner: DOCS_UPSTREAM_OWNER,
    repo: DOCS_REPO_NAME,
    title: `Update mobile app release notes for v${NATIVE_TEMPLATE_VERSION}`,
    head: `${DOCS_REPO_OWNER}:${DOCS_BRANCH_NAME}`,
    base: "development",
    body: prBody,
    draft: true,
  });
}

// Update NT Release Notes in Docs repo
async function updateNTReleaseNotes(unreleasedContent) {
  try {
    await cloneDocsRepo();
    const git = simpleGit();
    await checkoutLocalBranch(git);
    updateDocsNTReleaseNotes(unreleasedContent);
    await createPRUpdateDocsNTReleaseNotes(git);
  } catch (err) {
    console.error("❌ Updating NT Release Notes failed:", err);
    process.exit(1);
  }
}

function readVersionFromPackageJson() {
  const packageJsonPath = path.resolve(
    path.join(__dirname, "..", "..", "package.json"),
  );
  const packageJson = JSON.parse(fs.readFileSync(packageJsonPath, "utf-8"));
  return packageJson.version;
}

(async () => {
  const unreleasedContent = extractUnreleasedChangelog();

  await updateNTReleaseNotes(unreleasedContent);
})();
