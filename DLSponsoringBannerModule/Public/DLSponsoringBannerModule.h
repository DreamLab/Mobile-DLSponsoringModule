//
//  DLSponsoringBannerModule.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLAdView.h"

@class DLSponsoringBannerAd;

/**
Module responsible for providing ads for sposnoring banner ad.
 */
@interface DLSponsoringBannerModule : NSObject

/**
 Returns initialized object of class DLAdView. Each time it returns the same object.
 */
- (DLAdView *)adViewForViewController:(UIViewController *)controller;

/**
 Initializes module with the site parameter. It initialize the shared instance. Should be called before first use.

 @param site    the site URL parameter
 
 @return Instance of initialized DLSponsoringBannerModule
 */
+ (instancetype)initializeWithSite:(NSString *)site;

/**
 Returns the singleton instance of the DLSponsoringBannerModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSponsoringBannerModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
