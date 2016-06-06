xcodebuild clean build -project DLSponsoringBanerModule.xcodeproj  \
	   -scheme "DLSponsoringBanerModule" \
           -sdk iphonesimulator \
           -destination 'platform=iOS Simulator,name=iPhone 6,OS=9.2' test
