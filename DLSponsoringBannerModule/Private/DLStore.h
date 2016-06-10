//
//  DLStore.h
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
#import "DLSplashAd.h"

//Key to store JSON Dictionary in NSUserDefaults.
extern NSString * const kDLSplashAdJSONCacheKey;

// Key to store Ad image file name in NSUserDefaults.
extern NSString * const kDLSplashAdImageFileNameCacheKey;

// Key to store queued tracking links in NSUserDefaults.
extern NSString * const kDLSplashQueuedTrackingLinksCacheKey;

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

/**
 *  Tells if there are any traking links queued to send.
 *
 *  @return Status if there are any queued links.
 */
- (BOOL)areAnyTrackingLinksQueued;

/**
 *  Returns array of queued tracking links.
 *
 *  @return queued tracking links.
 */
- (NSArray<NSURL *> *)queuedTrackingLinks;

/**
 *  Queue array of tracking links.
 *
 *  @param trackingLinks array of tracking links to queue
 */
- (void)queueTrackingLinks:(NSArray<NSURL *> *)trackingLinks;

/**
 *  Queue tracking link.
 *
 *  @param trackingLink Tracking link to queue.
 */
- (void)queueTrackingLink:(NSURL *)trackingLink;

/**
 *  Remove tracking link from queue.
 *
 *  @param trackingLink tracking link to remove from queue.
 */
- (void)removeTrackingLink:(NSURL *)trackingLink;

/**
 *  Remove all queue of tracking links from store.
 */
- (void)clearQueuedTrackingLinks;

@end
