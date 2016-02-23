//
//  DLStore.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
#import "DLStore.h"

NSString * const kDLSplashAdJSONCacheKey = @"com.dreamlab.splash_screen.json_cache_key";
NSString * const kDLSplashAdImageFileNameCacheKey = @"com.dreamlab.splash_screen.image_filename_cache_key";

@implementation DLStore

- (BOOL)saveAdImageFromTemporaryLocation:(NSURL *)temporaryLocation ofSplashAd:(DLSplashAd *)splashAd
{
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)splashAd.version];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *fileURL = [cachesURL URLByAppendingPathComponent:fileName];
    NSError *moveError;
    splashAd.imageFileName = fileName;
    if (![fileManager moveItemAtURL:temporaryLocation toURL:fileURL error:&moveError]) {
        NSLog(@"moveItemAtURL failed: %@", moveError);
        return NO;
    }

    return YES;
}

- (void)cacheSplashAd:(DLSplashAd *)splashAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:splashAd.json forKey:kDLSplashAdJSONCacheKey];
    [userDefaults setObject:splashAd.imageFileName forKey:kDLSplashAdImageFileNameCacheKey];
    [userDefaults synchronize];
}

- (DLSplashAd *)cachedSplashAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *json = [userDefaults objectForKey:kDLSplashAdJSONCacheKey];
    NSString *imageFileName = [userDefaults objectForKey:kDLSplashAdImageFileNameCacheKey];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *cachesURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *fileURL = [cachesURL URLByAppendingPathComponent:imageFileName];

    DLSplashAd *cachedSplashAd = [[DLSplashAd alloc] initWithJSONDictionary:json];
    cachedSplashAd.image = [self imageAtLocation:fileURL];
    cachedSplashAd.imageFileName = imageFileName;

    return cachedSplashAd;
}

- (void)clearCache
{
    [self removeCachedImageAd];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kDLSplashAdJSONCacheKey];
    [userDefaults removeObjectForKey:kDLSplashAdImageFileNameCacheKey];
    [userDefaults synchronize];
}

#pragma mark - Private methods

- (BOOL)removeCachedImageAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageFileName = [userDefaults objectForKey:kDLSplashAdImageFileNameCacheKey];

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

@end
