# Update project's dependencies
npm i

# Untar bundle resources
tar xvzf ../res.tar.gz -C ./src/main/res && sudo find ./src/main/res/. -type d -exec chmod u+rwx {} \;