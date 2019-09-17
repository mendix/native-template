echo "Stripping unwanted MendixNative (i386, x86_64) archs"
LIB_PATH="./MendixNative/libMendix.a"
lipo -remove x86_64 -output $LIB_PATH $LIB_PATH
lipo -remove i386 -output $LIB_PATH $LIB_PATH
lipo -info $LIB_PATH
