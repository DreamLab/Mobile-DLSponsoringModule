//
//  DLSplashScreenWebService.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSplashScreenWebService : NSObject

@property (nonatomic, strong, readonly) NSURL *url;

// @"http://csr.onet.pl/_s/csr-005/app_site/exclusive:app_area/slots=splash/csr.json"
- (instancetype)initWithAppSite:(NSString *)appSite andSlots:(NSString *)slots;

- (void)fetchData;

@end
