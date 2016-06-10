//
//  DLAdView.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdViewDelegate.h"
@class DLSponsoringBannerAd;

@import UIKit;
@import Foundation;

/**
View to display the image of the ad.
 */
@interface DLAdView : UIView 

/**
 Delegate of the DLAdViewDelegate protocol.
 */
@property (nonatomic, weak) id<DLAdViewDelegate> delegate;

/**
 *  Property defining if ad is ready to be displayed
 */
@property (nonatomic, assign, readonly) BOOL isAdReady;

/**
 *  Ad size - (0,0) when ad is not ready to be displayed.
 */
@property (nonatomic, assign, readonly) CGSize adSize;

/**
 *  IMPORTANT: Load banner on each viewWillAppear of view controller
 */
- (void)loadBanner;
@end
