//
//  DLStore.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
#import "DLSplashAd.h"

//Key to store JSON Dictionary in NSUserDefaults.
extern NSString * const kDLSplashAdJSONCacheKey;

// Key to store Ad image location in NSUserDefaults.
extern NSString * const kDLSplashAdImageLocationCacheKey;

/**
 *  Class to manage caching of Splash Ad.
 */
@interface DLStore : NSObject

/**
 *  Saves Ad image permanently to cache folder on disk.
 *
 *  @param temporaryLocation Temporary location of fetched ad image.
 *  @param splashAd          SplashAd of ad image.
 *
 *  @return Status if saving file was successful.
 */
- (BOOL)saveAdImageFromTemporaryLocation:(NSURL *)temporaryLocation ofSplashAd:(DLSplashAd *)splashAd;

/**
 *  Cache given SplashAd object to NSUserDefaults.
 *
 *  @param splashAd SplashAd to cache.
 */
- (void)cacheSplashAd:(DLSplashAd *)splashAd;

/**
 *  Cached SplashAd from NSUserDefaults.
 *
 *  @return Cached SplashAd.
 */
- (DLSplashAd *)cachedSplashAd;

/**
 *  Clears cache.
 */
- (void)clearCache;

@end
