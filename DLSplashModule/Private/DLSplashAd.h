//
//  DLSplashAd.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

/**
 *  Class to parse Splash JSON and to expose its parameters
 */
@interface DLSplashAd : NSObject

/**
 *  URL to ad image
 */
@property (nonatomic, strong, readonly) NSURL *imageURL;

/**
 *  Width of ad image
 */
@property (nonatomic, assign, readonly) CGFloat imageWidth;

/**
 *  Height of ad image
 */
@property (nonatomic, assign, readonly) CGFloat imageHeight;

/**
 *  Ad image.
 */
@property (nonatomic, strong) UIImage *image;

/**
 *  Text for corresponding ad
 */
@property (nonatomic, strong, readonly) NSString *text;

/**
 *  Duration how long ad should be displayed
 */
@property (nonatomic, assign, readonly) NSTimeInterval time;

/**
 *  URL to audit
 */
@property (nonatomic, strong, readonly) NSURL *auditURL;

/**
 *  URL to audit2
 */
@property (nonatomic, strong, readonly) NSURL *audit2URL;

/**
 *  URL to click
 */
@property (nonatomic, strong, readonly) NSURL *clickURL;

/**
 *  Version of campain
 */
@property (nonatomic, assign, readonly) NSInteger version;

/**
 *  JSON of Splash Ad.
 */
@property (nonatomic, strong, readonly) NSDictionary *json;

/**
 *  Image file name on disk.
 */
@property (nonatomic, strong) NSString *imageFileName;

/**
 *  JSON of SplashAd is empty
 */
@property (nonatomic) BOOL empty;

/**
 *  Convenience initializer for DLSplashAd class
 *
 *  @param data NSData object of JSON fetched from server
 *
 *  @return Instance of DLSplashAd with parsed JSON
 */
- (instancetype)initWithJSONData:(NSData *)data;

/**
 *  Desingated initializer for DLSplashAd class
 *
 *  @param json JSON Dictionary
 *
 *  @return Instance of DLSplashAd with parsed JSON
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)json;

@end
