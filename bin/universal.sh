# To create dependency required by Demo project target 'DLSplashDemoPods' call:
# CONFIGURATION_BUILD_DIR='../Pod' bin/universal.sh
#
xcodebuild -project DLSponsoringBanerModule.xcodeproj -scheme DLSponsoringBanerModuleUniversal -configuration Release clean build CONFIGURATION_BUILD_DIR=$CONFIGURATION_BUILD_DIR
