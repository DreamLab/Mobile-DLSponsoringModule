//
//  DLSponsoringBanerModule.h
//  DLSponsoringBanerModule
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
@interface DLSponsoringBanerModule : NSObject

/**
 Returns initialized object of class DLAdView. Each time it returns the same object.
 */
@property (nonatomic, readonly) DLAdView *adView;

/**
 Initializes module with the site parameter. It initialize the shared instance. Should be called before first use.

 @param site    the site URL parameter
 @param area    the area URL parameter
 
 @return Instance of initialized DLSponsoringBanerModule
 */
+ (instancetype)initializeWithSite:(NSString *)site area:(NSString *)area;

/**
 *   Initializes module with the site, area and slots parameter. It initialize the shared instance. Should be called before first use.
 *
 *  @param site     the site URL parameter
 *  @param area     the area URL parameter
 *  @param slot     the slot URL parameter
 *
 *  @return Instance of initialized DLSponsoringBanerModule
 */
+ (instancetype)initializeWithSite:(NSString *)site area:(NSString *)area slot:(NSString *)slot;

/**
 Returns the singleton instance of the DLSponsoringBanerModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSponsoringBanerModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
