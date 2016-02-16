//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"

@interface DLSplashModule()
@property (nonatomic, strong) NSString *appSite;
@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (void)initializeWithAppSite:(NSString *)appSite
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    // Create instance of the DLSplashModule and set appSite
    sharedInstance.appSite = appSite;
    // TODO: start fetching data
}

+ (instancetype)sharedInstance
{
    return sharedInstance;
}

@end
