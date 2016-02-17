//
//  DLStore.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 17.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
#import "DLSplashAd.h"

extern NSString * const kDLSplashAdJSONCacheKey;
extern NSString * const kDLSplashAdImageLocationCacheKey;

@interface DLStore : NSObject

- (NSURL *)saveFilePermanently:(NSURL *)temporaryLocation withName:(NSString *)fileName;

- (void)cacheSplashAd:(DLSplashAd *)splashAd imageLocation:(NSString *)imageLocationPath;

- (DLSplashAd *)cachedSplashAd;

- (void)clearCache;

@end
