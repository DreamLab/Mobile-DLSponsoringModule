//
//  DLSplashModule+Internal.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 18.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModuleDelegate.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"

@interface DLSplashModule (Internal)

/**
 Splash Ad
 */
@property (nonatomic, strong, readonly) DLSplashAd *splashAd;

/**
 Notifies DLSplashModule that ad view was displayed

 @param adView DLAdView that generated event.
 */
- (void)adViewDidShow:(DLAdView *)adView;

/**
 Notifies DLSplashModule that ad view displayed image

 @param adView DLAdView that generated event.
 */
- (void)adViewDidDisplayImage:(DLAdView *)adView;

/**
 Add delegate to the DLSplashModule.

 @param delegate DLSplashModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSplashModuleDelegate>)delegate;

/**
 Remove delegate from the DLSplash module.

 @param delegate DLSplashModuleDelegate implementation
 */
- (void)removeDelegate:(id<DLSplashModuleDelegate>)delegate;

/**
 Remove all delegates from the DLSplashModule.
 */
- (void)removeAllDelegates;

@end
