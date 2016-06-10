//
//  DLSponsoringBannerModule+Internal.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 18.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBannerModuleDelegate.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"

@interface DLSponsoringBannerModule (Internal)

/**
 Splash Ad
 */
@property (nonatomic, strong, readonly) DLSplashAd *splashAd;

/**
 Notifies DLSponsoringBannerModule that ad view was displayed

 @param adView DLAdView that generated event.
 */
- (void)adViewDidShow:(DLAdView *)adView;

/**
 Notifies DLSponsoringBannerModule that ad view displayed image

 @param adView DLAdView that generated event.
 */
- (void)adViewDidDisplayImage:(DLAdView *)adView;

/**
 Add delegate to the DLSponsoringBannerModule.

 @param delegate DLSponsoringBannerModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate;

/**
 Remove delegate from the DLSplash module.

 @param delegate DLSponsoringBannerModuleDelegate implementation
 */
- (void)removeDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate;

/**
 Remove all delegates from the DLSponsoringBannerModule.
 */
- (void)removeAllDelegates;

@end
