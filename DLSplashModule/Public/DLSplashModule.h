//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLAdView.h"

@class DLSplashAd;

/**
Module responsible for providing ads for splash screen.
 */
@interface DLSplashModule : NSObject

/**
 Returns initialized object of class DLAdView. Each time it returns the same object.
 */
@property (nonatomic, readonly) DLAdView *adView;

/**
 Initializes module with the app site parameter. It initialize the shared instance. Should be called before first use.

 @param appSite the appSite URL parameter
 
 @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithAppSite:(NSString *)appSite;

/**
 *   Initializes module with the app site, exclusive and slots parameter. It initialize the shared instance. Should be called before first use.
 *
 *  @param appSite   the appSite URL parameter
 *  @param exclusive the exclusive URL parameter
 *  @param slots     the slots URL parameter
 *
 *  @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithAppSite:(NSString *)appSite exclusive:(NSString *)exclusive slots:(NSString *)slots;

/**
 Returns the singleton instance of the DLSplashModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSplashModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
