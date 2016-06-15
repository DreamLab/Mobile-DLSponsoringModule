//
//  DLStore.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
#import "DLStore.h"

NSString * const kDLSponsoringBannerAdJSONCacheKey = @"pl.dreamlab.sponsoring_banner.json_cache_key";
NSString * const kDLSponsoringBannerAdImageFileNameCacheKey = @"pl.dreamlab.sponsoring_banner.image_filename_cache_key";
NSString * const kDLSponsoringBannerQueuedTrackingLinksCacheKey = @"pl.dreamlab.sponsoring_banner.tracking_links_cache_key";

@implementation DLStore

- (BOOL)saveAdImageFromTemporaryLocation:(NSURL *)temporaryLocation ofBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)bannerAd.version];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *fileURL = [cachesURL URLByAppendingPathComponent:fileName];
    NSError *moveError;
    bannerAd.imageFileName = fileName;
    if (![fileManager moveItemAtURL:temporaryLocation toURL:fileURL error:&moveError]) {
        NSLog(@"moveItemAtURL failed: %@", moveError);
        return NO;
    }

    return YES;
}

- (void)cacheBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:bannerAd.json forKey:kDLSponsoringBannerAdJSONCacheKey];
    [userDefaults setObject:bannerAd.imageFileName forKey:kDLSponsoringBannerAdImageFileNameCacheKey];
    [userDefaults synchronize];
}

- (DLSponsoringBannerAd *)cachedBannerAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *json = [userDefaults objectForKey:kDLSponsoringBannerAdJSONCacheKey];
    NSString *imageFileName = [userDefaults objectForKey:kDLSponsoringBannerAdImageFileNameCacheKey];

    DLSponsoringBannerAd *cachedBannerAd = [[DLSponsoringBannerAd alloc] initWithJSONDictionary:json];

    if (imageFileName) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *fileURL = [cachesURL URLByAppendingPathComponent:imageFileName];
        cachedBannerAd.imageFileName = imageFileName;
        cachedBannerAd.image = [self imageAtLocation:fileURL];
    }

    return cachedBannerAd;
}

- (BOOL)isAdFullyCached {
    return self.cachedBannerAd.image != nil;
}

- (void)clearCache
{
    [self removeCachedImageAd];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kDLSponsoringBannerAdJSONCacheKey];
    [userDefaults removeObjectForKey:kDLSponsoringBannerAdImageFileNameCacheKey];
    [userDefaults synchronize];
}

#pragma mark - Private methods

- (BOOL)removeCachedImageAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageFileName = [userDefaults objectForKey:kDLSponsoringBannerAdImageFileNameCacheKey];
    if (!imageFileName) {
        return false;
    }

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];

    NSURL *fileURL = [cachesURL URLByAppendingPathComponent:imageFileName];
    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtURL:fileURL error:&error];
    return error == nil;
}

- (UIImage *)imageAtLocation:(NSURL *)imageLocation
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageLocation]];
}

- (BOOL)areAnyTrackingLinksQueued
{
    return [[self queuedTrackingLinks] count] != 0;
}

- (NSArray<NSURL *> *)queuedTrackingLinks
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:kDLSponsoringBannerQueuedTrackingLinksCacheKey];
    NSArray<NSURL *> *queuedTrackingLinks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return queuedTrackingLinks;
}

- (void)queueTrackingLinks:(NSArray<NSURL *> *)trackingLinks
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:trackingLinks];
    [userDefaults setObject:saveData forKey:kDLSponsoringBannerQueuedTrackingLinksCacheKey];
    [userDefaults synchronize];
}

- (void)queueTrackingLink:(NSURL *)trackingLink
{
    NSMutableArray *trackingLinks = [NSMutableArray arrayWithArray:[self queuedTrackingLinks]];
    [trackingLinks addObject:trackingLink];
    [self queueTrackingLinks:trackingLinks];
}

- (void)removeTrackingLink:(NSURL *)trackingLink
{
    NSMutableArray *trackingLinks = [NSMutableArray arrayWithArray:[self queuedTrackingLinks]];
    [trackingLinks removeObject:trackingLink];
    [self queueTrackingLinks:trackingLinks];
}

- (void)clearQueuedTrackingLinks
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kDLSponsoringBannerQueuedTrackingLinksCacheKey];
    [userDefaults synchronize];
}

@end