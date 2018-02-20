//
//  DLSponsoringModuleStore.h
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
#import "DLSponsoringBannerAd.h"

/**
 *  Class to manage caching of Sponsoring Banner Ad.
 */
@interface DLSponsoringModuleStore : NSObject

/**
*  Initialise Store module.
*
*  @param site Site
*  @param area Area
*  @param customParams Custom params passed to SponsoringModule
*
*  @return DLSponsoringModuleStore object.
*/
- (instancetype _Nonnull)initWithSite:(NSString* _Nonnull)site
                                 area:(NSString* _Nonnull)area
                         customParams:(NSDictionary<NSString*, NSString*>* _Nullable)customParams;

/**
 *  Saves Ad image permanently to cache folder on disk.
 *
 *  @param temporaryLocation Temporary location of fetched ad image.
 *  @param bannerAd          Sponsoring Banner Ad of ad image.
 *
 *  @return Status if saving file was successful.
 */
- (BOOL)saveAdImageFromTemporaryLocation:(NSURL * _Nonnull)temporaryLocation ofBannerAd:(DLSponsoringBannerAd *_Nonnull)bannerAd;

/**
 *  Cache given Sponsoring Banner Ad object to NSUserDefaults.
 *
 *  @param bannerAd SposoringBannerAd to cache.
 */
- (void)cacheBannerAd:(DLSponsoringBannerAd * _Nonnull)bannerAd;

/**
 *  Cached Sponsoring Banner Ad from NSUserDefaults.
 *
 *  @return Cached SposoringBannerAd.
 */
- (DLSponsoringBannerAd * _Nonnull)cachedBannerAd;

/**
 *  Is data fully stored in cache?
 *
 *  @return YES when data for ad is fully cached (including image)
 */
- (BOOL)isAdFullyCached;

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
- (NSArray<NSURL *> * _Nonnull)queuedTrackingLinks;

/**
 *  Queue array of tracking links.
 *
 *  @param trackingLinks array of tracking links to queue
 */
- (void)queueTrackingLinks:(NSArray<NSURL *> * _Nonnull)trackingLinks;

/**
 *  Queue tracking link.
 *
 *  @param trackingLink Tracking link to queue.
 */
- (void)queueTrackingLink:(NSURL * _Nonnull)trackingLink;

/**
 *  Remove tracking link from queue.
 *
 *  @param trackingLink tracking link to remove from queue.
 */
- (void)removeTrackingLink:(NSURL * _Nonnull)trackingLink;

/**
 *  Remove all queue of tracking links from store.
 */
- (void)clearQueuedTrackingLinks;

@end
