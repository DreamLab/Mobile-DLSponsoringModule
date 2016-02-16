//
//  DLSplashModuleDelegate.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 16.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;

/**
 Protocol of the DLSplashModuleDelegate.
 */
@protocol DLSplashModuleDelegate

/**
 Notifies that splash screen should be displayed. Parameter displayAd tells if ad data is ready to display.
 @param displayAd tells if ad should be displayed on splash screen.
 */
- (void)splashScreenShouldBeDisplayedWithAd:(BOOL)displayAd;

/**
 Notifies that splash screen should display ad.
 */
- (void)splashScreenShouldDisplayAd;

/**
 Notifies that splash screen should be closed - time of displaying it passed.
 */
- (void)splashScreenShouldClose;

@end