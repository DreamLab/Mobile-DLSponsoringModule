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
NSString * const kDLSplashAdImageLocationCacheKey = @"com.dreamlab.splash_screen.image_location_cache_key";

@implementation DLStore

- (BOOL)saveAdImageFromTemporaryLocation:(NSURL *)temporaryLocation ofSplashAd:(DLSplashAd *)splashAd
{
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)splashAd.version];

    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] firstObject];
    NSURL *fileURL = [documentsURL URLByAppendingPathComponent:fileName];
    NSError *moveError;
    splashAd.imageLocationPath = [fileURL path];
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
    [userDefaults setObject:splashAd.imageLocationPath forKey:kDLSplashAdImageLocationCacheKey];
    [userDefaults synchronize];
}

- (DLSplashAd *)cachedSplashAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *json = [userDefaults objectForKey:kDLSplashAdJSONCacheKey];
    NSString *imageLocationPath = [userDefaults objectForKey:kDLSplashAdImageLocationCacheKey];

    DLSplashAd *cachedSplashAd = [[DLSplashAd alloc] initWithJSONDictionary:json];
    cachedSplashAd.image = [self imageAtLocation:[NSURL URLWithString:imageLocationPath]];
    cachedSplashAd.imageLocationPath = imageLocationPath;

    return cachedSplashAd;
}

- (void)clearCache
{
    [self removeCachedImageAd];

    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:kDLSplashAdJSONCacheKey];
    [userDefaults removeObjectForKey:kDLSplashAdImageLocationCacheKey];
    [userDefaults synchronize];
}

#pragma mark - Private methods

- (BOOL)removeCachedImageAd
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *imageLocationPath = [userDefaults objectForKey:kDLSplashAdImageLocationCacheKey];

    NSError *error = nil;
    [[NSFileManager defaultManager] removeItemAtPath:imageLocationPath error:&error];

    return error == nil;
}

- (UIImage *)imageAtLocation:(NSURL *)imageLocation
{
    return [UIImage imageWithData:[NSData dataWithContentsOfURL:imageLocation]];
}

@end
