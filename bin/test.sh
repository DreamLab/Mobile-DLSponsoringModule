xcodebuild clean build -project DLSponsoringBannerModule.xcodeproj  \
	   -scheme "DLSponsoringBannerModule" \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.2' test
