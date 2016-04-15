# Splash Screen - Tutorial iOS

## Goal
Create a component that can show your ad text and partner applications which can be used in various applications.

## Installation
DLSplashScreen can be installed in two ways. Manually copying files into project or by using CocoaPods.

### Manually installation
You need to simply copy the files of DLSplashModule (libDLSplashModule.a and .h files) to you xcode project.

Next go to your project setting, select given target and then Build Phases tab. Under the "Link Binary With Libraries" section add `libDLSplashModule.a` file.

![Linking library into project](tutorial_resources/splash_screen_ios_linking_library.png)

Then in the same target settings in the "Build Settings" tab search for "Header Search Paths" and add path to the headers of DLSplashModule in your project.

![Setting header search paths](tutorial_resources/splash_screen_ios_header_search_paths.png)

### Via CocoaPods
In order to install it as a pod you need to specify the source of internal pods. Add this source to your Podfile so it will be possible to find Podfile:

```
source 'https://source-of-dlsplashmodule.pl'
```

In your Podfile add the following line:
```
pod 'DLSplashModule'
```

## Usage
### Step 1. Initialize
Add #import statement in your AppDelegate:
```
#import <DLSplashModule/DLSplashModule.h>
```

In application:didFinishLaunchingWithOptions: method of your AppDelegate add following method to initialize `DLSplashModule`:
```
[DLSplashModule initializeWithSite:<SITE_PARAMETER> area:<AREA_PARAMETER> slot:<SLOT_PARAMETER>];
```
As `<SITE_PARAMETER>` insert your Site Identifier.

As `<AREA_PARAMETER>` insert your Area Identifier.

As `<SLOT_PARAMETER>` insert your Area Identifier.

Or you can use more convenience initializer:
```
[DLSplashModule initializeWithSite:<SITE_PARAMETER> area:<AREA_PARAMETER>];
```

### Step 2. Create and set delegate
You need to create instance of `DLAdView` class. It can be done in 3 ways:
- Creating object of UIView in xib and setting its custom class do DLAdView
- Getting `DLAdView` instance via property of DLSplashModule singleton
- Creating new instance of `DLAdView` class

**PLEASE NOTE:** `DLAdView` size must be 150x150pt!

Once it's done you have to set delegate of `DLAdView` instance to be notified of various events. The best is to set the root view controller as this delegate.

```
self.adView.delegate = self;
```

And conform your view controller to `DLAdViewDelegate` protocol.

```
@interface YourViewcontroller: UIViewController<DLAdViewDelegate>
```

### Step 3. Implement delegate methods
You need to implement methods of `DLAdViewDelegate` to be notified and react on events

```
// Method is called when user taps on the DLAdView.
// You can open webview with given URL here.
(void)adView:(DLAdView *)adView didTapImageWithUrl:(NSURL *)url;
 
// Method is called when DLAdView fulfill the content of the ad.
(void)adView:(DLAdView *)adView didDisplayAdWithAssociatedText:(NSString *)associatedText;
 
// Notifies that splash screen should be closed - time of displaying it passed.
(void)splashScreenShouldBeClosed;
```

## Implementation details

The main three classes that developer is tinkering with are: `DLSplashModule`, `DLAdView` and `DLAdViewDelegate`.


`DLAdView` is a subclass of UIView to display the image of the ad. This class provides also partner string as its property so it can be used to display in UILabel by developer.


Process of downloading an ad is started when `+initializeWithSite:area:` or `+initializeWithSite:area:slot:` on `DLSplashModule` is invoked. Downloading is finished when all date is fetched or when the timeout is reached.


DLSplashModule persiste cache for banner json in NSUserDefaults and image on disk within app sandbox.


DLSplashMOdule after fetching ad json data compares it to cached json data. When ad version is different then a new ad image is being downloaded.
If the ad version is the same then the cached ad image is being used. But if the version is the same but there is no cached ad image then an ad image is being downloaded.


Developer can create class that conforms to DLAdViewDelegate and is delegate of DLAdView. DLAdView informs its delegate if user tapped on image, ad was displayed and when splash screen should be closed.

Splash module waits 3 seconds to fetch ad data and to display it.
When it fetched ad data and image withing that time then ad is displayed for the time fetched in ad data.

When timeout of fetching data is reached then the method `splashScreenShouldBeClosed` of `DLAdViewDelegate` is invoked.

Fetching ad data and image will be continued in background.

Fetching is being retried 3 times when failed.
