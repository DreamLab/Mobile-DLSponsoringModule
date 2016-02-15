//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"

@implementation DLSplashModule

+ (instancetype)sharedInstance
{
    static dispatch_once_t once;
    static id sharedInstance;

    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    
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