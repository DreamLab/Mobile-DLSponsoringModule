xcodebuild clean build -project DLSplashModule.xcodeproj  \
	   -scheme "DLSplashModule" \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.2' test
