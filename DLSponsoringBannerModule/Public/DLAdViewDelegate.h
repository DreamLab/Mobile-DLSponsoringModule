//
//  DLAdViewDelegate.h
//  DLSponsoringBannerModule
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
 *  Method called when ad was displayed witch changed content comparing to initial one.
 *
 *  @param adView DLAdView that generated event
 *  @param size   Size of ad with which ad should be presented to user
 */
- (void)adViewNeedsToBeReloaded:(DLAdView *)adView withExpectedSize:(CGSize)size;

@end
