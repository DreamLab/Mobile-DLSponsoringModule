//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"

@interface DLSplashModule ()
@property (nonatomic, strong) NSMutableSet *delegates;
@end


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

- (instancetype)init
{
    self = [super init];
    if (self == nil) {
        return nil;
    }

    self.delegates = [[NSMutableSet alloc] init];

    return self;
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