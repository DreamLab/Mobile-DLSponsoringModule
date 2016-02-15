//
//  DLPersisteStore.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 *  Class to parse Splash JSON and to expose its parameters.
 */
@interface DLPersisteStore : NSObject

/**
 *  URL to ad image.
 */
@property (nonatomic, strong) NSURL *imageAdURL;

/**
 *  Width of ad image.
 */
@property (nonatomic, assign) CGFloat imageAdWidth;

/**
 *  Height of ad image.
 */
@property (nonatomic, assign) CGFloat imageAdHeight;

/**
 *  Text for corresponding ad.
 */
@property (nonatomic, strong) NSString *adText;

/**
 *  Duration how long ad should be displayed.
 */
@property (nonatomic, assign) NSTimeInterval time;

/**
 *  URL to audit.
 */
@property (nonatomic, strong) NSURL *auditURL;

/**
 *  URL to audit2.
 */
@property (nonatomic, strong) NSURL *audit2URL;

/**
 *  URL to click.
 */
@property (nonatomic, strong) NSURL *clickURL;

/**
 *  Version of campain.
 */
@property (nonatomic, assign) int version;

/**
 *  Designated initializer for DLPersisteStore class.
 *
 *  @param data NSData object of JSON fetched from server.
 *
 *  @return Instance of DLPersisteStore with parsed JSON.
 */
- (instancetype)initWithJSONData:(NSData *)data;

@end
