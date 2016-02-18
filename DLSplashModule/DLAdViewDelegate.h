//
//  DLAdViewDelegate.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;
@class DLAdView;

/**
 Protocol of the DLAdViewDelegate.
 */
@protocol DLAdViewDelegate

/**
 Method is called when user taps on the DLAdView.

 @param adView DLAdView that generated event
 @param url NSURL to be displayed in webview
 */
- (void)adView:(DLAdView *)adView didTapImageWithUrl:(NSURL *)url;

/**
 Notifies that splash screen should be closed - time of displaying it passed.
 */
- (void)splashScreenShouldClose;

@end