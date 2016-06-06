//
//  DLSplashScreenWebService.m
//  DLSponsoringBanerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;
@import AdSupport;

#import "DLSplashScreenWebService.h"
#import "DLSplashAd.h"
#import "DLStore.h"

NSString * const kSplashScreenBaseURL = @"https://csr.onet.pl/_s/csr-005/%@/%@/%@/csr.json";

NSString * const kSplashScreenSlotDefaultParameter = @"slots=splash";

@interface DLSplashScreenWebService ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation DLSplashScreenWebService

- (instancetype)initWithSite:(NSString *)site area:(NSString *)area
{
    return [self initWithSite:site area:area slot:kSplashScreenSlotDefaultParameter];
}

- (instancetype)initWithSite:(NSString *)site area:(NSString *)area slot:(NSString *)slot
{
    self = [super init];

    if (!self || ![site length] || ![area length] || ![slot length]) {
        return nil;
    }

    NSString *advertisingId = [ASIdentifierManager sharedManager].advertisingIdentifier.UUIDString;

    NSString *urlString = [NSString stringWithFormat:kSplashScreenBaseURL, site, area, slot];
    if (advertisingId && ![advertisingId isEqual:@""]) {
        urlString = [NSString stringWithFormat:@"%@?DI=%@", urlString, advertisingId];
    }

    _url = [NSURL URLWithString:urlString];
    return self;
}

- (void)fetchDataWithCompletion:(void (^)(DLSplashAd *, NSError *))completion
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
                                                        DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:data];
                                                        completion(splashAd, error);
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

- (void)trackForSplashAd:(DLSplashAd *)splashAd
{
    if (!splashAd) {
        return;
    }

    DLStore *store = [[DLStore alloc] init];

    if (splashAd.auditURL) {
        [store queueTrackingLink:splashAd.auditURL];
    }
    if (splashAd.audit2URL) {
        [store queueTrackingLink:splashAd.audit2URL];
    }

    if ([store areAnyTrackingLinksQueued]) {
        for (NSURL *url in [store queuedTrackingLinks]) {
            [self performSessionDownloadTaskForURL:url];
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
            DLStore *store = [[DLStore alloc] init];
            [store removeTrackingLink:url];
        }
    }];

    [downloadTask resume];
}

@end
