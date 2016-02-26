# To create dependency required by Demo project target 'DLSplashDemoPods' call:
# CONFIGURATION_BUILD_DIR='../Pod' bin/universal.sh
#
xcodebuild -project DLSplashModule.xcodeproj -scheme DLSplashModuleUniversal -configuration Release clean build CONFIGURATION_BUILD_DIR=$CONFIGURATION_BUILD_DIR