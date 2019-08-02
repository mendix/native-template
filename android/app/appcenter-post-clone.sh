# Update node version to latest; appcenter defaults to v6
brew uninstall node@6
brew install node

# Update project's dependencies
npm i

# Untar bundle resources
if [ -f "../res.tar.gz" ]; then 
    tar xvzf ../res.tar.gz -C ./src/main/res && sudo find ./src/main/res/. -type d -exec chmod u+rwx {} \;
    exit 0;
fi
