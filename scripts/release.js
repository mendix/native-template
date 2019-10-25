#!/usr/bin/env node
const { spawn } = require("child_process");
const { EOL } = require("os");

function getVersion() {
    const [_1, _2, version] = process.argv;
    if (version === undefined) {
        throw new Error("A valid version is required");
    }
    return version;
}

const tasks = [
    { name: "npm", args: ["version", getVersion()] },
    { name: "git", args: ["push", "--tags"] },
];

for (const task of tasks) {
    const run = spawn(task.name, task.args);
    run.stdout.on("data", logData);
    run.stderr.on("data", logData);
    run.on("error", (e) => {
        if (e.code === "ENOENT") {
            console.error(`Unable to find ${task.name} executable`);
        }
    });
    run.on("close", exitCode => {
        if (exitCode !== 0) {
            console.error(`Error during execution (exit code ${exitCode})`);
            console.error(`Command executed: ${task.name}`);
        }
    });
}

function logData(data) {
    data.toString()
        .replace(/(\r\n|\n)/gm, EOL)
        .split(EOL)
        .filter(line => line !== EOL)
        .forEach(line => console.info(line));
}
