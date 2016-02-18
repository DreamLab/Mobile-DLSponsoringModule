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

@interface DLSplashModule ()
@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSMutableSet *delegates;
@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (instancetype)initializeWithIdentifier:(NSString *)identifier
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

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

// TODO: probably this should be private
- (DLSplashAd *)splashAd
{
    // TODO: return DLSplashAd correctly, with the correct values, should be correlated with fetchind data
    return nil;
}

#pragma mark - Delegate
- (void)addDelegate:(id<DLSplashModuleDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<DLSplashModuleDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

- (void)removeAllDelegates
{
    [self.delegates removeAllObjects];
}

//- (void)notifyDelegates
//{
//    for (id<DLSplashModuleDelegate> delegate in self.delegates) {
//        [delegate TODO];
//    }
//}


@end