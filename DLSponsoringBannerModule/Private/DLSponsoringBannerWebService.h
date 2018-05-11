//
//  DLSponsoringBannerWebService.h
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DLSponsoringBannerAd;
@class DLSponsorigConsentParams;

/**
 *  Class to fetch data from server
 */
@interface DLSponsoringBannerWebService : NSObject

/**
 *  Designated initializer.
 *
 *  @param site             Site URL parameter.
 *  @param area             Area URL parameter.
 *  @param customParams     Custom parameters for ad requests.
 *  @param appVersion       Version of application URL parameter
 *  @param slot             Slot URL parameter.
 *
 *  @return Instance of DLSponsoringBannerWebService with URL to webservice.
 */
- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                customParams:(NSDictionary<NSString*, NSString*> *)customParams
                  appVersion:(NSString *)appVersion
                        slot:(NSString *)slot
                consentParams:(DLSponsorigConsentParams *)consentParams;

/**
 *  Fetch data from server.
 *
 *  @param completion Block with DLSponsoringBannerAd and NSError as result of fetching data
 */
- (void)fetchDataWithCompletion:(void(^)(DLSponsoringBannerAd *bannerAd, NSError *error))completion;

/**
 *  Fetch image from server.
 *
 *  @param url             URL to the image.
 *  @param numberOfRetries Number of retries to fetch image.
 *  @param completion      Completion block containing downloaded image and path to its temporary location on disk and error if occurred.
 */
- (void)fetchImageAtURL:(NSURL *)url numberOfRetries:(NSUInteger)numberOfRetries completion:(void (^)(UIImage *image, NSURL *imageLocation, NSError *error))completion;

/**
 *  Send tracking requests.
 *
 *  @param bannerAd DLSponsoringBannerAd to track.
 */
- (void)trackForBannerAd:(DLSponsoringBannerAd *)bannerAd;

@end
