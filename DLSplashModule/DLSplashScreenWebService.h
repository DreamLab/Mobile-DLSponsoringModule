//
//  DLSplashScreenWebService.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Class to fetch data from server
 */
@interface DLSplashScreenWebService : NSObject

/**
 *  Designated initializer
 *
 *  @param appSite App Site
 *
 *  @return Instance of DLSplashScreenWebService with URL to webservice
 */
- (instancetype)initWithAppSite:(NSString *)appSite;

/**
 *  Fetch data from server
 */
- (void)fetchData;

@end
