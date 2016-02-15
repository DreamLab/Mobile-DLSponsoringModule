//
//  DLSplashScreenWebService.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashScreenWebService.h"
#import "DLPersisteStore.h"

// Example: http://csr.onet.pl/_s/csr-005/app_site/exclusive:app_area/slots=splash/csr.json
NSString * const kSplashScreenBaseURL = @"http://csr.onet.pl/_s/csr-005/%@/exclusive:app_area/slots=%@/csr.json";

@interface DLSplashScreenWebService ()

@property (nonatomic, strong) NSURLSession *session;

@property (nonatomic, strong) NSURL *url;

@end

@implementation DLSplashScreenWebService

- (instancetype)initWithAppSite:(id)appSite andSlots:(id)slots {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _url = [NSURL URLWithString:[NSString stringWithFormat:kSplashScreenBaseURL, appSite, slots]];

    return self;
}

- (void)fetchData
{
    NSURLSession *session = [NSURLSession sharedSession];

    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:self.url];

    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                                                    if (error) {
                                                        NSLog(@"Error occured: %@", error.description);
                                                        return;
                                                    }

                                                    DLPersisteStore *store = [[DLPersisteStore alloc] initWithJSONData:data];

    }];

    [dataTask resume];
}

@end
