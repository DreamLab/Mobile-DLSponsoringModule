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
 Notifies that splash screen should display ad.
 */
- (void)splashScreenShouldDisplayAd;

/**
 Notifies that splash screen should be closed - time of displaying it passed.
 */
- (void)splashScreenShouldBeClosed;

@end
