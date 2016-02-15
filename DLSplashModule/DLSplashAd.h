//
//  DLSplashAd.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  Class to parse Splash JSON and to expose its parameters
 */
@interface DLSplashAd : NSObject

/**
 *  URL to ad image
 */
@property (nonatomic, strong, readonly) NSURL *imageAdURL;

/**
 *  Width of ad image
 */
@property (nonatomic, assign, readonly) CGFloat imageAdWidth;

/**
 *  Height of ad image
 */
@property (nonatomic, assign, readonly) CGFloat imageAdHeight;

/**
 *  Text for corresponding ad
 */
@property (nonatomic, strong, readonly) NSString *adText;

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
@property (nonatomic, assign, readonly) int version;

/**
 *  Designated initializer for DLSplashAd class
 *
 *  @param data NSData object of JSON fetched from server
 *
 *  @return Instance of DLSplashAd with parsed JSON
 */
- (instancetype)initWithJSONData:(NSData *)data;

@end
