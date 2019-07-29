# Update project's dependencies
npm i

# Untar bundle resources
tar xvzf android/res.tar.gz -C android/app/src/main/res && sudo find android/app/src/main/res/. -type d -exec chmod u+rwx {} \;