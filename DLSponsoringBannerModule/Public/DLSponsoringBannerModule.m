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
#import "DLSponsoringConsentParams.h"

static const NSTimeInterval kMaxTimeOfWaitingForContent = 3;
static const NSTimeInterval kMaxNumberOfFetchingImageRetries = 3;

@interface DLSponsoringBannerModule ()
@property (nonatomic, strong) NSString *site;
@property (nonatomic, strong) NSString *appVersion;
@property (nonatomic, strong) NSString *area;
@property (nonatomic, strong) NSString *slot;
@property (nonatomic, strong) NSDictionary<NSString*, NSString*> *customParams;

@property (nonatomic, strong) NSHashTable *delegates;
@property (nonatomic, strong) DLSponsoringBannerAd *bannerAd;
@property (nonatomic, strong) NSTimer *waitingTimer;
@property (nonatomic, strong) DLSponsoringBannerWebService *webService;
@property (nonatomic, strong) DLSponsoringModuleStore *store;
@property (nonatomic, strong) NSMapTable<NSString*, DLSponsoringAdView*> *viewsForControllers;
@property (nonatomic, strong) DLSponsoringConsentParams *consentParams;
@property (atomic, assign, getter=isDataFetchingInProgress) BOOL dataFetchingInProgress;
@end

@implementation DLSponsoringBannerModule

- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                        slot:(NSString *)slot
                customParams:(nullable NSDictionary<NSString*, NSString*>*)customParams
                  appVersion:(NSString *)appVersion
                consentParams:(DLSponsoringConsentParams * _Nonnull)consentParams
{
    self = [super init];

    if (!self) {
        return nil;
    }

    _site = site;
    _appVersion = appVersion;
    _area = area;
    _slot = slot;
    _customParams = customParams;
    _consentParams = consentParams;

    _delegates = [[NSHashTable alloc] initWithOptions:NSHashTableWeakMemory capacity:5];
    _viewsForControllers = [[NSMapTable alloc] initWithKeyOptions:NSMapTableWeakMemory valueOptions:NSMapTableWeakMemory capacity:5];

    [self initializeBannerAd];

    return self;
}

- (instancetype)initWithSite:(NSString *)site
                        area:(NSString *)area
                customParams:(nullable NSDictionary<NSString*, NSString*>*)customParams
                  appVersion:(NSString *)appVersion
                consentParams:(DLSponsoringConsentParams * _Nonnull)consentParams
{
    return [self initWithSite:site
                         area:area
                         slot:@"flat-belkagorna"
                 customParams:customParams
                   appVersion:appVersion
                 consentParams:consentParams];
}

- (instancetype)initWithSite:(NSString *)site
                  appVersion:(NSString *)appVersion
                consentParams:(DLSponsoringConsentParams * _Nonnull)consentParams;
{
    return [self initWithSite:site
                         area:@"SPONSORING"
                 customParams:nil
                   appVersion:appVersion
                 consentParams:consentParams];
}

- (void)initializeBannerAd
{
    self.webService = [[DLSponsoringBannerWebService alloc] initWithSite:self.site
                                                                    area:self.area
                                                            customParams:self.customParams
                                                              appVersion:self.appVersion
                                                                    slot:self.slot
                                                            consentParams:self.consentParams];
    self.store = [[DLSponsoringModuleStore alloc] initWithSite:self.site area:self.area customParams:self.customParams];
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
            self.bannerAd = nil;
            [self waitingForDataFinished];
            return;
        }

        DLSponsoringBannerAd *cachedBannerAd = self.store.cachedBannerAd;
        if (![bannerAd.version isEqual: cachedBannerAd.version] || !cachedBannerAd.image) {
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

- (DLSponsoringAdView *)adViewForParentView:(id<UIAppearanceContainer, DLSponsoringAdViewDelegate>)parentView
{
    return [self adViewForParentView:parentView shouldBeRespondingToOrientationChanges:NO];
}

-(DLSponsoringAdView *)adViewForParentView:(id<UIAppearanceContainer, DLSponsoringAdViewDelegate>)parentView shouldBeRespondingToOrientationChanges:(BOOL)orientationChangesSupport {

    NSString *identifier = [NSString stringWithFormat:@"%p", parentView];
    DLSponsoringAdView* adView = [self.viewsForControllers objectForKey:identifier];

    if (adView) {
        return adView;
    }

    adView = [[DLSponsoringAdView alloc] initWithSponsoringModule:self];
    [self.viewsForControllers setObject:adView forKey:identifier];

    adView.delegate = (id<DLSponsoringAdViewDelegate>)parentView;

    adView.shouldRespondToOrientationChanges = orientationChangesSupport;

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
    dispatch_async(dispatch_get_main_queue(), ^{
        NSArray *delegates = self.delegates.allObjects;
        for (id<DLSponsoringBannerModuleDelegate> delegate in delegates) {
            [delegate sposoringBannerModuleReceivedAd:self.bannerAd];
        }
    });
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
        [self notifyDelegatesBannerAdViewShouldDisplayAd];
    }
}

#pragma mark - Communication with ad view

- (void)adViewDidShowSuccesfulyForBannerAd:(DLSponsoringBannerAd *)bannerAd
{
    [self.webService trackForBannerAd:bannerAd];
    NSLog(@"Tracked displaying banner ad: %@", bannerAd);
}

@end
