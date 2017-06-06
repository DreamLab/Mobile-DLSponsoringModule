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

@class DLSponsoringBannerAd;

/**
 *  Main class of DLSponsoringBanner Module, once initialized, being responsible mainly for returning ad views.
 */
@interface DLSponsoringBannerModule : NSObject

/**
*  Returns initialized object of class DLSponsoringAdView to be used in given Parent View.
*  When parent view conforms to DLSponsoringAdViewDelegate it is also automatically set as DLSponsoringAdView delegate
*  By default DLSponsoringAdView has orientationChangesSupport flag set to NO
*
*  @param parentView Any object being e.g. either UIViewController of some UIView
*
*  @return DLSponsoringAdView view
*/
- (DLSponsoringAdView *)adViewForParentView:(id<UIAppearanceContainer>)parentView;

/**
 *  Returns initialized object of class DLSponsoringAdView to be used in given Parent View.
 *  When parent view conforms to DLSponsoringAdViewDelegate it is also automatically set as DLSponsoringAdView delegate
 *
 *  @param parentView Any object being e.g. either UIViewController of some UIView
 *  @param orientationChangesSupport If YES then view will be resizing itself depending on phone position
 *
 *  @return DLSponsoringAdView view
 */
- (DLSponsoringAdView *)adViewForParentView:(id<UIAppearanceContainer>)parentView
     shouldBeRespondingToOrientationChanges:(BOOL)orientationChangesSupport;

/**
 Initializes module with the site parameter. It initialize the shared instance. Should be called before first use.

 @param site    the site URL parameter
 
 @return Instance of initialized DLSponsoringBannerModule
 */
+ (instancetype)initializeWithSite:(NSString *)site appVersion:(NSString *)appVersion;

/**
 Returns the singleton instance of the DLSponsoringBannerModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSponsoringBannerModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
