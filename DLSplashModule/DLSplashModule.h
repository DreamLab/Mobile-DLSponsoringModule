//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import "DLSplashModuleDelegate.h"

/**
Module responsible for providing ads for splash screen.
 */
@interface DLSplashModule : NSObject

/**
 Returns the singleton instance of the DLSplashModule class.

 @return Instance of DLSplashModule
 */
+ (instancetype)sharedInstance;

/**
 Add delegate to the DLSplashModule.

 @param delegate DLSplashModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSplashModuleDelegate>)delegate;

/**
 Remove delegate from the DLSplash module.

 @param delegate DLSplashModuleDelegate implementation
 */
- (void)removeDelegate:(id<DLSplashModuleDelegate>)delegate;

/**
 Remove all delegates from the DLSplashModule.
 */
- (void)removeAllDelegates;

/**
 Size of the ad image

 @return Size of the currenty fetched ad image
 */
- (CGSize)imageSize;

/**
 Image of the ad

 @return Ad image
 */
- (UIImage *)image;

@end
