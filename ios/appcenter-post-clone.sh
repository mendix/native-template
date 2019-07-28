# Update node version to latest; appcenter defaults to v6
brew uninstall node@6
brew install node

# Update project's dependencies
npm i && pod install --repo-update
