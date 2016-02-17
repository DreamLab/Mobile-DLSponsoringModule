//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"
#import "DLSplashScreenWebService.h"

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
    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:@"app_site"];
    [webService fetchDataWithCompletion:^(DLSplashAd *splashAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            return;
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