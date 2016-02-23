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
@property (nonatomic, strong) NSString *identifier;
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

+ (instancetype)initializeWithIdentifier:(NSString *)identifier
{
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    sharedInstance.identifier = identifier;
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
    DLSplashAd *cachedSplashAd = [store cachedSplashAd];
    self.splashAd = cachedSplashAd.image ? cachedSplashAd : nil;

    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:self.identifier];
    [webService fetchDataWithCompletion:^(DLSplashAd *splashAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            return;
        }

        if (splashAd.version != cachedSplashAd.version || !cachedSplashAd.image) {
            [webService fetchImageAtURL:splashAd.imageURL completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
                if (error) {
                    NSLog(@"Error occured: %@", error);
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
            splashAd.image = cachedSplashAd.image;
            splashAd.imageFileName = cachedSplashAd.imageFileName;
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

-(void)setSplashAd:(DLSplashAd *)splashAd
{
    _splashAd = splashAd;
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

#pragma mark - Auditing
- (void)sendAuditData
{
    // TODO: send Audit Data (separate task)
}

@end