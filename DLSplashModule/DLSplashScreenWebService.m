//
//  DLSplashScreenWebService.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashScreenWebService.h"
#import "DLSplashAd.h"

// Example: https://csr.onet.pl/_s/csr-005/app_site/exclusive:app_area/slots=splash/csr.json
NSString * const kSplashScreenBaseURL = @"https://csr.onet.pl/_s/csr-005/%@/exclusive:app_area/slots=splash/csr.json";

@interface DLSplashScreenWebService ()

@property (nonatomic, strong) NSURL *url;

@end

@implementation DLSplashScreenWebService

- (instancetype)initWithAppSite:(NSString *)appSite {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _url = [NSURL URLWithString:[NSString stringWithFormat:kSplashScreenBaseURL, appSite]];

    return self;
}

- (void)fetchDataWithCompletion:(void (^)(DLSplashAd *, NSError *))completion
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {
                                                        completion(nil, error);
                                                        return;
                                                    }

                                                    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:data];
                                                    completion(splashAd, error);
    }];

    [dataTask resume];
}

@end
