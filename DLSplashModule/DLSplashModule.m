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

+ (void)initializeWithAppSite:(NSString *)appSite
{
    // Create instance of the DLSplashModule and set appSite
    DLSplashModule.sharedInstance.appSite = appSite;
    // TODO: start fetching data
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;

    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
