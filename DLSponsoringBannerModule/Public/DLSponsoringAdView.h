//
//  DLSponsoringAdView.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringAdViewDelegate.h"
@class DLSponsoringBannerAd;

@import UIKit;
@import Foundation;

/**
View to display the image of the ad.
 */
@interface DLSponsoringAdView : UIView

/**
 Delegate of the DLAdViewDelegate protocol.
 */
@property (nonatomic, weak) id<DLSponsoringAdViewDelegate> delegate;

/**
 *  Property defining if ad is ready to be displayed
 */
@property (nonatomic, assign, readonly, getter=isAdReady) BOOL adReady;

/**
 *  Ad size - CGSizeZero when ad is not ready to be displayed.
 */
@property (nonatomic, assign, readonly) CGSize adSize;

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
