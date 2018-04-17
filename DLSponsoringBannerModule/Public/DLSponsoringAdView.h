//
//  DLSponsoringAdView.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringAdViewDelegate.h"
@class DLSponsoringBannerAd;
@class DLSponsoringBannerModule;

@import UIKit;
@import Foundation;

/**
View to display the image of the ad.
 */
@interface DLSponsoringAdView : UIView

/**
 Delegate of the DLAdViewDelegate protocol.
 */
@property (nonatomic, weak, nullable) id<DLSponsoringAdViewDelegate> delegate;

/**
 *  Property defining if ad is ready to be displayed
 */
@property (nonatomic, assign, readonly, getter=isAdReady) BOOL adReady;

/**
 *  Property defining background color for ad
 */
@property (nonatomic, assign, readonly, nullable) UIColor *adBackgroundColor;

/**
 *  Ad size - CGSizeZero when ad is not ready to be displayed.
 */
@property (nonatomic, assign, readonly) CGSize adSize;

/**
 *  Flag mentioning if ad view should respond to orientation changes, changing it's size 
 */
@property (nonatomic, assign) BOOL shouldRespondToOrientationChanges;

/**
 Initializes view with module object.

 @param module          DLSponsoringBannerModule

 @return Instance of initialized DLSponsoringAdView
 */
- (instancetype _Nonnull)initWithSponsoringModule:(DLSponsoringBannerModule * _Nonnull)module;

/**
 *  IMPORTANT: Call this method each time viewWillAppear method of view controller was called 
 *  or in other case when parent view is about to be presented to user.
 */
- (void)parentViewWillAppear;

/**
 *  IMPORTANT: Call this method each time viewDidDisappear method of view controller was called
 *  or in other case when parent view is not presented to user anymore.
 */
- (void)parentViewDidDisappear;

@end
