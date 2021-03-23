const {writeFileSync} = require("fs");

module.exports = async ({ github }) => {
    const [owner, repo] = process.env.GITHUB_REPOSITORY.split("/");
    const response = await github.repos.listReleases({ owner, repo, per_page: 100 });
    const releases = response.data.map((release) => {
        return {
            id: release.id,
            tag_name: release.tag_name,
            name: release.name,
            draft: release.draft,
            prerelease: release.prerelease,
            body: release.body,
            created_at: release.created_at,
            published_at: release.published_at,
            tarball_url: release.tarball_url,
            zipball_url: release.zipball_url,
        }
    });

    writeFileSync(`${process.env.GITHUB_WORKSPACE}/${process.env.OUTPUT_PATH}`, `${JSON.stringify(releases, null, 4)}\n`)
}
