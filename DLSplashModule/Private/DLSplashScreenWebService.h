//
//  DLSplashScreenWebService.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSplashAd;

/**
 *  Class to fetch data from server
 */
@interface DLSplashScreenWebService : NSObject

/**
 *  Designated initializer
 *
 *  @param appSite   App Site URL parameter
 *  @param exclusive Exclusive URL parameter
 *  @param slots     Slots URL parameter
 *
 *  @return Instance of DLSplashScreenWebService with URL to webservice
 */
- (instancetype)initWithAppSite:(NSString *)appSite exclusive:(NSString *)exclusive slots:(NSString *)slots;

/**
 *  Convenience initializer
 *
 *  @param appSite App Site
 *
 *  @return Instance of DLSplashScreenWebService with URL to webservice
 */
- (instancetype)initWithAppSite:(NSString *)appSite;

/**
 *  Fetch data from server.
 *
 *  @param completion Block with DLSplashAd and NSError as result of fetching data
 */
- (void)fetchDataWithCompletion:(void(^)(DLSplashAd *splashAd, NSError *error))completion;

/**
 *  Fetch image from server.
 *
 *  @param url          URL to the image.
 *  @param completion   Completion block containing downloaded image and path to its temporary location on disk and error if occurred.
 */
- (void)fetchImageAtURL:(NSURL *)url completion:(void (^)(UIImage *image, NSURL *imageLocation, NSError *error))completion;

/**
 *  Send tracking requests.
 *
 *  @param splashAd SplashAd to track.
 */
- (void)trackForSplashAd:(DLSplashAd *)splashAd;

@end
