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
static const NSTimeInterval kMaxNumberOfFetchingImageRetries = 3;

@interface DLSplashModule ()
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *slot;

@property (nonatomic, strong) NSMutableSet *delegates;
@property (nonatomic, strong) NSTimer *displayTimer;
@property (nonatomic, strong) NSTimer *waitingTimer;
@property (nonatomic, weak) DLAdView *displayedAdView;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) DLAdView *generatedAdView;
@property (nonatomic, strong) DLSplashScreenWebService *webService;

@end

@implementation DLSplashModule

static dispatch_once_t once;
static DLSplashModule* sharedInstance;

+ (instancetype)initializeWithSite:(NSString *)site area:(NSString *)area
{
    return [DLSplashModule initializeWithSite:site
                                         area:area
                                         slot:kSplashScreenSlotDefaultParameter];
}

+ (instancetype)initializeWithSite:(NSString *)site
                              area:(NSString *)area
                              slot:(NSString *)slot
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    sharedInstance.site = site;
    sharedInstance.area = area;
    sharedInstance.slot = slot;
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

    self.webService = [[DLSplashScreenWebService alloc] initWithSite:self.site
                                                                area:self.area
                                                                slot:self.slot];

    [self fetchSplashAdWithWebService:self.webService store:store];
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
            [self waitingForDataFinished];
            return;
        }

        if (splashAd.version != self.splashAd.version || !self.splashAd.image) {
            [webService fetchImageAtURL:splashAd.imageURL numberOfRetries:kMaxNumberOfFetchingImageRetries completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
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
    [self.webService trackForSplashAd:self.splashAd];
}

@end