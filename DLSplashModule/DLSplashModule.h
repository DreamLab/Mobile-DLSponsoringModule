//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLSplashModuleDelegate.h"
#import "DLAdView.h"

@class DLSplashAd;

/**
Module responsible for providing ads for splash screen.
 */
@interface DLSplashModule : NSObject

/**
 Splash Ad
 */
@property (nonatomic, strong, readonly) DLSplashAd *splashAd;

/**
 Initializes module with the app site parameter. It initialize the shared instance. Should be called before first use.

 @param identifier the identifier of the ad
 
 @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithIdentifier:(NSString *)identifier;

/**
 Returns the singleton instance of the DLSplashModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSplashModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

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

// TODO: maybe it should be in delegate - should
- (void)adViewDidShow:(DLAdView *)adView;
- (void)adViewDidDisplayImage:(DLAdView *)adView;


@end
