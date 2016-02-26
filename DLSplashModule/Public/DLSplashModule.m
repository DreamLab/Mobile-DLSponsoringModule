//
//  DLSplashModule.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashModule.h"
#import "DLSplashModule+Internal.h"
#import "DLSplashModuleDelegate.h"
#import "DLSplashScreenWebService.h"
#import "DLStore.h"

static const NSTimeInterval kMaxTimeOfWaitingForContent = 3;

@interface DLSplashModule ()
@property (nonatomic, strong) NSString *appSite;
@property (nonatomic, strong) NSString *exclusive;
@property (nonatomic, strong) NSString *slots;

@property (nonatomic, strong) NSMutableSet *delegates;
@property (nonatomic, strong) NSTimer *displayTimer;
@property (nonatomic, strong) NSTimer *waitingTimer;
@property (nonatomic, weak) DLAdView *displayedAdView;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) DLAdView *generatedAdView;

@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (instancetype)initializeWithAppSite:(NSString *)appSite
{
    return [DLSplashModule initializeWithAppSite:appSite
                                       exclusive:kSplashScreenExclusiveDefaultParameter
                                           slots:kSplashScreenSlotsDefaultParameter];
}

+ (instancetype)initializeWithAppSite:(NSString *)appSite
                            exclusive:(NSString *)exclusive
                                slots:(NSString *)slots
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    sharedInstance.appSite = appSite;
    sharedInstance.exclusive = exclusive;
    sharedInstance.slots = slots;
    [sharedInstance initializeSplashAd];

    return sharedInstance;
}

+ (instancetype)sharedInstance
{
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (!self) {
        return nil;
    }
    _delegates = [[NSMutableSet alloc] init];
    return self;
}

- (void)initializeSplashAd
{
    DLStore *store = [[DLStore alloc] init];

    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:self.appSite
                                                                                   exclusive:self.exclusive
                                                                                       slots:self.slots];

    [self fetchSplashAdWithWebService:webService store:store];
}

-(void)fetchSplashAdWithWebService:(DLSplashScreenWebService *)webService store:(DLStore *)store
{
    DLSplashAd *cachedSplashAd = [store cachedSplashAd];
    self.splashAd = cachedSplashAd.image ? cachedSplashAd : nil;
    [webService fetchDataWithCompletion:^(DLSplashAd *splashAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            if (self.splashAd) {
                [self waitingForDataFinished];
            }
            return;
        }

        // if we get empty json
        if (splashAd.empty) {
            self.splashAd = nil;
            [store clearCache];
            return;
        }

        if (splashAd.version != self.splashAd.version || !self.splashAd.image) {
            [webService fetchImageAtURL:splashAd.imageURL completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
                if (error) {
                    NSLog(@"Error occured: %@", error);
                    if (self.splashAd) {
                        [self waitingForDataFinished];
                    }
                    return;
                }
                splashAd.image = image;
                self.splashAd = splashAd;
                [store clearCache];
                [store saveAdImageFromTemporaryLocation:imageLocation ofSplashAd:splashAd];
                [store cacheSplashAd:splashAd];
                [self waitingForDataFinished];
            }];
        } else {
            splashAd.image = self.splashAd.image;
            splashAd.imageFileName = self.splashAd.imageFileName;
            self.splashAd = splashAd;
            [self waitingForDataFinished];
        }

        NSLog(@"Fetched splash ad: %@", splashAd);
    }];
}

- (DLAdView *)adView
{
    if (!_generatedAdView) {
        _generatedAdView = [[DLAdView alloc] init];
    }
    return _generatedAdView;
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

- (void)notifyDelegatesSplashScreenShouldDisplayAd
{
    for (id<DLSplashModuleDelegate> delegate in self.delegates) {
        [delegate splashScreenShouldDisplayAd];
    }
}

- (void)notifyDelegatesSplashScreenShouldBeClosed
{
    for (id<DLSplashModuleDelegate> delegate in self.delegates) {
        [delegate splashScreenShouldBeClosed];
    }
}

#pragma mark - Timers
- (void)waitingForDataStarted
{
    NSInteger waitingTime = kMaxTimeOfWaitingForContent;
    self.waitingTimer = [NSTimer scheduledTimerWithTimeInterval:waitingTime
                                                         target:self
                                                       selector:@selector(waitingForDataFinished)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)waitingForDataFinished
{
    if (self.waitingTimer) {
        [self.waitingTimer invalidate];
        self.waitingTimer = nil;
        if (self.splashAd) {
            [self notifyDelegatesSplashScreenShouldDisplayAd];
        } else {
            [self notifyDelegatesSplashScreenShouldBeClosed];
        }
    }
}

- (void)displayingTimeStarted
{
    NSInteger waitingTime = self.splashAd.time;
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:waitingTime
                                                         target:self
                                                       selector:@selector(displayingTimePassed)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)displayingTimePassed
{
    self.displayTimer = nil;
    [self notifyDelegatesSplashScreenShouldBeClosed];
}

#pragma mark - Communication with ad view

- (void)adViewDidShow:(DLAdView *)adView
{
    [self waitingForDataStarted];
}

- (void)adViewDidDisplayImage:(DLAdView *)adView
{
    [self displayingTimeStarted];
}

@end