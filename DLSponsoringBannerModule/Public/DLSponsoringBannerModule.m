//
//  DLSponsoringBannerModule.m
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBannerModule.h"
#import "DLSponsoringBannerModule+Internal.h"
#import "DLSponsoringBannerModuleDelegate.h"
#import "DLSponsoringBannerWebService.h"
#import "DLSponsoringModuleStore.h"

static const NSTimeInterval kMaxTimeOfWaitingForContent = 3;
static const NSTimeInterval kMaxNumberOfFetchingImageRetries = 3;

@interface DLSponsoringBannerModule ()
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *slot;
@property (nonatomic, strong) NSMutableSet *delegates;
@property (nonatomic, strong) DLSponsoringBannerAd *bannerAd;
@property (nonatomic, strong) NSTimer *waitingTimer;
@property (nonatomic, strong) DLSponsoringBannerWebService *webService;
@property (nonatomic, strong) DLSponsoringModuleStore *store;
@property (nonatomic, strong) NSMapTable<NSString*, DLSponsoringAdView*> *viewsForControllers;
@property (atomic, assign, getter=isDataFetchingInProgress) BOOL dataFetchingInProgress;
@end

@implementation DLSponsoringBannerModule

static dispatch_once_t once;
static DLSponsoringBannerModule* sharedInstance;

+ (instancetype)initializeWithSite:(NSString *)site
{
    if (DLSponsoringBannerModule.sharedInstance != nil) {
        NSLog(@"DLSponsoringBannerModule was already initialized");
        return nil;
    }

    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });

    sharedInstance.site = site;
    sharedInstance.area = @"exclusive:sponsoring";
    sharedInstance.slot = @"flat-belkagorna";
    [sharedInstance initializeBannerAd];

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
    _viewsForControllers = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:5];
    return self;
}

- (void)initializeBannerAd
{
    self.webService = [[DLSponsoringBannerWebService alloc] initWithSite:self.site
                                                                area:self.area
                                                                slot:self.slot];
    self.store = [[DLSponsoringModuleStore alloc] init];

    if (self.store.isAdFullyCached) {
        self.bannerAd = self.store.cachedBannerAd;
    }

    [self fetchBannerAd];
}

- (void)fetchBannerAd
{
    if (self.isDataFetchingInProgress) {
        return;
    }

    self.dataFetchingInProgress = YES;
    [self waitingForDataStarted];

    [self.webService fetchDataWithCompletion:^(DLSponsoringBannerAd *bannerAd, NSError *error) {
        if (error) {
            NSLog(@"Error occured: %@", error);
            if (self.store.isAdFullyCached) {
                self.bannerAd = self.store.cachedBannerAd;
                [self waitingForDataFinished];
            }
            return;
        }

        // if we get empty json
        if (bannerAd.empty) {
            [self.store clearCache];
            [self waitingForDataFinished];
            return;
        }

        DLSponsoringBannerAd *cachedBannerAd = self.store.cachedBannerAd;
        if (![bannerAd.version isEqualToString: cachedBannerAd.version] || !cachedBannerAd.image) {
            [self.webService fetchImageAtURL:bannerAd.imageURL numberOfRetries:kMaxNumberOfFetchingImageRetries completion:^(UIImage *image, NSURL *imageLocation, NSError *error) {
                if (error) {
                    NSLog(@"Error occured: %@", error);
                    if (self.store.isAdFullyCached) {
                        self.bannerAd = self.store.cachedBannerAd;
                        [self waitingForDataFinished];
                    }
                    return;
                }
                bannerAd.image = image;
                self.bannerAd = bannerAd;
                [self.store clearCache];
                [self.store saveAdImageFromTemporaryLocation:imageLocation ofBannerAd:bannerAd];
                [self.store cacheBannerAd:bannerAd];
                [self waitingForDataFinished];
            }];
            return;
        }

        if (!self.bannerAd) {
            self.bannerAd = cachedBannerAd;
        }

        [self waitingForDataFinished];

        NSLog(@"Fetched banner ad: %@", bannerAd);
    }];
}

- (DLSponsoringAdView *)adViewForParentView:(id<DLSponsoringAdViewDelegate>)parentView
{
    DLSponsoringAdView *adView = [self.viewsForControllers objectForKey:parentView];
    if (adView) {
        return adView;
    }

    adView = [[DLSponsoringAdView alloc] init];
    [self.viewsForControllers setObject:adView forKey:parentView];
    adView.delegate = parentView;
    
    return adView;
}

#pragma mark - Delegate
- (void)addDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate
{
    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate
{
    [self.delegates removeObject:delegate];
}

- (void)removeAllDelegates
{
    [self.delegates removeAllObjects];
}

- (void)notifyDelegatesBannerAdViewShouldDisplayAd
{
    for (id<DLSponsoringBannerModuleDelegate> delegate in self.delegates) {
        [delegate sposoringBannerModuleReceivedAd:self.bannerAd];
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

- (void)waitingForDataFinished {

    self.dataFetchingInProgress = NO;
    if (self.waitingTimer) {
        [self.waitingTimer invalidate];
        self.waitingTimer = nil;
        if (self.bannerAd) {
            [self notifyDelegatesBannerAdViewShouldDisplayAd];
        }
    }
}

#pragma mark - Communication with ad view

- (void)adViewDidShowSuccesfulyForBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    [self.webService trackForBannerAd:bannerAd];
    NSLog(@"Tracked displaying banner ad: %@", bannerAd);
}

@end
