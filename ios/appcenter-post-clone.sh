# Update node version to latest; appcenter defaults to v6
brew uninstall node@6
brew install node

# Update project's dependencies
npm i && pod install --repo-update

# Untar bundle resources
if [ -f "./Bundle/assets.tar.gz" ]; then
    tar xvzf ./Bundle/assets.tar.gz -C ./Bundle && sudo find ./Bundle/. -type d -exec chmod u+rwx {} \;
    exit 0;
fi
