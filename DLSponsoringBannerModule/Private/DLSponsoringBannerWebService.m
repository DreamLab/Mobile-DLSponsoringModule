//
//  DLSponsoringBannerWebService.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;
@import AdSupport;

#import "DLSponsoringBannerWebService.h"
#import "DLSponsoringBannerAd.h"
#import "DLSponsoringModuleStore.h"

NSString * const kSponsoringBannerBaseURL = @"https://csr.onet.pl/_s/csr-006/csr.json?site=%@&area=%@&slot0=%@&ver=%@";

@interface DLSponsoringBannerWebService ()

@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) DLSponsoringModuleStore *store;

@end

@implementation DLSponsoringBannerWebService

- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                customParams:(NSDictionary<NSString*, NSString*> *)customParams
                  appVersion:(NSString *)appVersion
                        slot:(NSString *)slot
{
    self = [super init];

    if (!self || ![site length] || ![area length] || ![slot length] || ![appVersion length]) {
        return nil;
    }

    NSString *advertisingId = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;

    NSMutableString *urlString = [NSMutableString stringWithFormat:kSponsoringBannerBaseURL, site, area, slot, appVersion];

    // Add keyword cs006r in order to exclude calls from Bizon
    NSString *kwrdParam = [customParams objectForKey:@"kwrd"];
    if (kwrdParam && kwrdParam.length > 0) {
        kwrdParam = [NSString stringWithFormat:@"%@+cs006r", kwrdParam];
    } else {
        kwrdParam = @"cs006r";
    }
    NSMutableDictionary<NSString*, NSString*> *customParamsMutable = [NSMutableDictionary dictionaryWithDictionary:customParams];
    [customParamsMutable setObject:kwrdParam forKey:@"kwrd"];

    if (customParamsMutable && customParamsMutable.count > 0) {
        for (NSString* key in customParamsMutable) {
            NSString *customParam = [NSString stringWithFormat:@"&kv%@=%@", key, customParamsMutable[key]];
            [urlString appendString:customParam];
        }
    }

    if (advertisingId && ![advertisingId isEqual:@""]) {
        urlString = [NSMutableString stringWithFormat:@"%@&DI=%@", urlString, advertisingId];
    }

    _url = [NSURL URLWithString:urlString];
    _store = [[DLSponsoringModuleStore alloc] initWithSite:site area:area];
    return self;
}

- (void)fetchDataWithCompletion:(void (^)(DLSponsoringBannerAd *, NSError *))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {
                                                        if (completion) {
                                                            completion(nil, error);
                                                        }
                                                        return;
                                                    }

                                                    if (completion) {
                                                        DLSponsoringBannerAd *bannerAd = [[DLSponsoringBannerAd alloc] initWithJSONData:data];
                                                        completion(bannerAd, error);
                                                    }
    }];

    [dataTask resume];
}

- (void)fetchImageAtURL:(NSURL *)url numberOfRetries:(NSUInteger)numberOfRetries completion:(void (^)(UIImage *image, NSURL *imageLocation, NSError *error))completion
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest
                                                            completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                                if (error) {
                                                                    if (numberOfRetries > 0) {
                                                                        [self fetchImageAtURL:url numberOfRetries:numberOfRetries-1 completion:completion];
                                                                    } else {
                                                                        if (completion) {
                                                                            completion(nil, nil, error);
                                                                        }
                                                                    }
                                                                } else if (completion) {
                                                                    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:location]];
                                                                    completion(image, location, error);
                                                                }
                                              }];

    [downloadTask resume];
}

- (void)trackForBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    if (!bannerAd) {
        return;
    }

    if (bannerAd.auditURL) {
        [self.store queueTrackingLink:bannerAd.auditURL];
    }
    if (bannerAd.audit2URL) {
        [self.store queueTrackingLink:bannerAd.audit2URL];
    }
    if (bannerAd.actionCountURL) {
        [self.store queueTrackingLink:bannerAd.actionCountURL];
    }

    if ([self.store areAnyTrackingLinksQueued]) {
        for (NSURL *url in [self.store queuedTrackingLinks]) {
            // Dispatching onto background thread because method `downloadTaskWithRequest:completionHandler:` of shared NSURLSession
            // is running on main thread
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self performSessionDownloadTaskForURL:url];
            });
        }
    }
}

#pragma mark - Private methods

- (void)performSessionDownloadTaskForURL:(NSURL *)url
{
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];

    NSURLSessionDownloadTask *downloadTask = [session downloadTaskWithRequest:urlRequest
                                                            completionHandler:^(NSURL * _Nullable location, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error occurred: %@ while sending request to url: %@", error.description, url);
        } else {
            [self.store removeTrackingLink:url];
        }
    }];

    [downloadTask resume];
}

@end
