//
//  DLSponsoringBannerAd.h
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreGraphics;

/**
 *  Class to parse Sposnoring Banner JSON and to expose its parameters
 */
@interface DLSponsoringBannerAd : NSObject

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
 *  URL to audit
 */
@property (nonatomic, strong, readonly) NSURL *auditURL;

/**
 *  URL to audit2
 */
@property (nonatomic, strong, readonly) NSURL *audit2URL;

/**
 *  URL to action count
 */
@property (nonatomic, strong, readonly) NSURL *actionCountURL;

/**
 *  URL to click
 */
@property (nonatomic, strong, readonly) NSURL *clickURL;

/**
 *  Version of campain
 */
@property (nonatomic, strong, readonly) NSString *version;

/**
 *  JSON of Sponsoring Banner Ad.
 */
@property (nonatomic, strong, readonly) NSDictionary *json;

/**
 *  Image file name on disk.
 */
@property (nonatomic, strong) NSString *imageFileName;

/**
 *  JSON of BannerAd is empty
 */
@property (nonatomic, readonly) BOOL empty;

/**
 *  Convenience initializer for DLSponsoringBannerAd class
 *
 *  @param data NSData object of JSON fetched from server
 *
 *  @return Instance of DLSponsoringBannerAd with parsed JSON
 */
- (instancetype)initWithJSONData:(NSData *)data;

/**
 *  Desingated initializer for DLSponsoringBannerAd class
 *
 *  @param json JSON Dictionary
 *
 *  @return Instance of DLSponsoringBannerAd with parsed JSON
 */
- (instancetype)initWithJSONDictionary:(NSDictionary *)json;

@end
