//
//  DLSponsoringModuleStore.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
#import "DLSponsoringModuleStore.h"
#import <CommonCrypto/CommonDigest.h>

NSString * const kDLSponsoringBannerAdJSONCacheKey = @"pl.dreamlab.sponsoring_banner.json_cache_key";
NSString * const kDLSponsoringBannerAdImageFileNameCacheKey = @"pl.dreamlab.sponsoring_banner.image_filename_cache_key";
NSString * const kDLSponsoringBannerQueuedTrackingLinksCacheKey = @"pl.dreamlab.sponsoring_banner.tracking_links_cache_key";

@interface DLSponsoringModuleStore ()

@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *customParams;

@end

@implementation DLSponsoringModuleStore

- (instancetype)initWithSite:(NSString*)site area:(NSString*)area customParams:(nullable NSDictionary<NSString*, NSString*>*)customParams {
    self = [super init];
    if (self == nil) {
        return nil;
    }

    _site = site;
    _area = area;
    _customParams = customParams;

    return self;
}

- (BOOL)saveAdImageFromTemporaryLocation:(NSURL *)temporaryLocation ofBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    NSString *fileName = [NSString stringWithFormat:@"%@_%@_%@_%@", self.site, self.area, bannerAd.version, [self firstKeyword]];

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

    NSData *bannerData = bannerAd.json == nil ? nil : [NSKeyedArchiver archivedDataWithRootObject:bannerAd.json];

    [userDefaults setObject:bannerData forKey:self.jsonCacheKey];
    [userDefaults setObject:bannerAd.imageFileName forKey:self.fileNameCacheKey];
    [userDefaults synchronize];
}

- (DLSponsoringBannerAd *)cachedBannerAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    NSData *bannerData = (NSData *)[userDefaults objectForKey:self.jsonCacheKey];
    NSString *imageFileName = [userDefaults objectForKey:self.fileNameCacheKey];

    if (bannerData && imageFileName) {
        NSDictionary *json = nil;
        NSObject *dataObject = [NSKeyedUnarchiver unarchiveObjectWithData:bannerData];

        if (dataObject && [dataObject isKindOfClass:[NSDictionary class]]) {
            json = (NSDictionary*)dataObject;
        }

        DLSponsoringBannerAd *cachedBannerAd = [[DLSponsoringBannerAd alloc] initWithJSONDictionary:json];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
        NSURL *fileURL = [cachesURL URLByAppendingPathComponent:imageFileName];
        cachedBannerAd.imageFileName = imageFileName;
        cachedBannerAd.image = [self imageAtLocation:fileURL];

        return cachedBannerAd;
    }

    return nil;
}

- (BOOL)isAdFullyCached {
    return self.cachedBannerAd.image != nil;
}

- (void)clearCache
{
    [self removeCachedImageAd];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:self.jsonCacheKey];
    [userDefaults removeObjectForKey:self.fileNameCacheKey];
    [userDefaults synchronize];
}

#pragma mark - Private methods

- (BOOL)removeCachedImageAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageFileName = [userDefaults objectForKey:self.fileNameCacheKey];
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
    NSData *data = [userDefaults objectForKey:self.queuedTrakcingLinksCacheKey];
    NSArray<NSURL *> *queuedTrackingLinks = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return queuedTrackingLinks;
}

- (void)queueTrackingLinks:(NSArray<NSURL *> *)trackingLinks
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *saveData = [NSKeyedArchiver archivedDataWithRootObject:trackingLinks];
    [userDefaults setObject:saveData forKey:self.queuedTrakcingLinksCacheKey];
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
    [userDefaults removeObjectForKey:self.queuedTrakcingLinksCacheKey];
    [userDefaults synchronize];
}

- (NSString *)firstKeyword {
    if ([[_customParams allValues] count] == 0) {
        return @"";
    }

    NSString *values = [[_customParams allValues] componentsJoinedByString:@"_"];
    return [self md5:values];
}

- (NSString *)jsonCacheKey {
    return [NSString stringWithFormat:@"%@_%@_%@_%@", kDLSponsoringBannerAdJSONCacheKey, self.site, self.area, [self firstKeyword]];
}

- (NSString *)fileNameCacheKey {
    return [NSString stringWithFormat:@"%@_%@_%@_%@", kDLSponsoringBannerAdImageFileNameCacheKey, self.site, self.area, [self firstKeyword]];
}

- (NSString *)queuedTrakcingLinksCacheKey {
    return [NSString stringWithFormat:@"%@_%@_%@_%@", kDLSponsoringBannerQueuedTrackingLinksCacheKey, self.site, self.area, [self firstKeyword]];
}

- (NSString *)md5:(NSString *)input
{
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call

    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];

    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    [output appendFormat:@"%02x", digest[i]];

    return  output;
}

@end
