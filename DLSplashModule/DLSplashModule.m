//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"

@interface DLSplashModule()
@property (nonatomic, strong) NSString *identifier;
@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (instancetype)initializeWithidentifier:(NSString *)identifier
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    // Create instance of the DLSplashModule and set identifier
    sharedInstance.identifier = identifier;
    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:identifier];
    [webService fetchDataWithCompletion:^(DLSplashAd *splashAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            return;
        }

        DLStore *store = [[DLStore alloc] init];
        DLSplashAd *cachedSplashAd = [store cachedSplashAd];

        if (splashAd.version != cachedSplashAd.version || !cachedSplashAd.image) {
            [webService fetchImageAtURL:splashAd.imageURL completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
                splashAd.image = image;
                [store saveAdImageFromTemporaryLocation:imageLocation ofSplashAd:splashAd];
                [store cacheSplashAd:splashAd];
            }];
        } else {
            splashAd.image = cachedSplashAd.image;
            splashAd.imageLocationPath = cachedSplashAd.imageLocationPath;
        }

        NSLog(@"Fetched splash ad: %@", splashAd);
    }];

    return sharedInstance;
}

+ (instancetype)sharedInstance
{
    return sharedInstance;
}

- (CGSize)imageSize
{
    // [JZ] TODO: set values received in json
    return CGSizeMake(150, 150);
}

- (UIImage *)image
{
    // [JZ] TODO: return fetched image
    return nil;
}

@end