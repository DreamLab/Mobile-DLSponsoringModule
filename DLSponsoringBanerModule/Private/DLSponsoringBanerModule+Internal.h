//
//  DLSponsoringBanerModule+Internal.h
//  DLSponsoringBanerModule
//
//  Created by Jacek Zapart on 18.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBanerModuleDelegate.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"

@interface DLSponsoringBanerModule (Internal)

/**
 Splash Ad
 */
@property (nonatomic, strong, readonly) DLSplashAd *splashAd;

/**
 Notifies DLSponsoringBanerModule that ad view was displayed

 @param adView DLAdView that generated event.
 */
- (void)adViewDidShow:(DLAdView *)adView;

/**
 Notifies DLSponsoringBanerModule that ad view displayed image

 @param adView DLAdView that generated event.
 */
- (void)adViewDidDisplayImage:(DLAdView *)adView;

/**
 Add delegate to the DLSponsoringBanerModule.

 @param delegate DLSponsoringBanerModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSponsoringBanerModuleDelegate>)delegate;

/**
 Remove delegate from the DLSplash module.

 @param delegate DLSponsoringBanerModuleDelegate implementation
 */
- (void)removeDelegate:(id<DLSponsoringBanerModuleDelegate>)delegate;

/**
 Remove all delegates from the DLSponsoringBanerModule.
 */
- (void)removeAllDelegates;

@end
