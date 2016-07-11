//
//  DLSponsoringBannerModule.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLSponsoringAdView.h"

@class DLSponsoringBannerAd, DLSponsoringAdViewDelegate;

/**
 *  Main class of DLSponsoringBanner Module, once initialized, being responsible mainly for returning ad views.
 */
@interface DLSponsoringBannerModule : NSObject

/**
*  Returns initialized object of class DLSponsoringAdView to be used in given Parent View.
*
*  @param parentView:   Any object conforming to DLSponsoringAdViewDelegate protocol
*
*  @return DLSponsoringAdView view
*/
- (DLSponsoringAdView *)adViewForParentView:(id<DLSponsoringAdViewDelegate>)parentView;

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
