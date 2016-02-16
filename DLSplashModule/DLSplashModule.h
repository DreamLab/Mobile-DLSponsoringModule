//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSplashModule : NSObject

/**
 Initializes module with the app site parameter. It initialize the shared instance. Should be called before first use.

 @param appSite app site parameter - identifier of the ad
 */
+ (void)initializeWithAppSite:(NSString *)appSite;

/**
 Returns the singleton instance of the DLSplashModule class. 
 Method initializeWithAppSite: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSplashModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
