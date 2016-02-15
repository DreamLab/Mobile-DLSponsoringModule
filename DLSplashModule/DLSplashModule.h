//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;

@interface DLSplashModule : NSObject

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
