//
//  DLSponsoringBannerModuleDelegate.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 16.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;

/**
 Protocol of the DLSponsoringBannerModuleDelegate.
 */
@protocol DLSponsoringBannerModuleDelegate

/**
 Notifies that ad view should display ad.
 */
- (void)adViewShouldDisplayAd;

@end
