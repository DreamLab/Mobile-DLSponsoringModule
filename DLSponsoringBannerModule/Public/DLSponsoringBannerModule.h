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

 @param site        Site parameter
 @param appVersion  Application version
 
 @return Instance of initialized DLSponsoringBannerModule
 */
- (instancetype)initWithSite:(NSString *)site appVersion:(NSString *)appVersion;

/**
 Initializes module with extendend .

 @param site            Site parameter
 @param site            Area parameter
 @param customParams    Custom parameters given as key-value strings, e.g. "lokalizacja": "wroclaw"
 @param appVersion      Application version

 @return Instance of initialized DLSponsoringBannerModule
 */
- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                customParams:(NSDictionary<NSString*, NSString*>*)customParams
                  appVersion:(NSString *)appVersion;

@end
