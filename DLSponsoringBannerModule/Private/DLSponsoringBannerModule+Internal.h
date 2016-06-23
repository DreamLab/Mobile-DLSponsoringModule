//
//  DLSponsoringBannerModule+Internal.h
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 18.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBannerModuleDelegate.h"
#import "DLSponsoringBannerWebService.h"
#import "DLSponsoringModuleStore.h"

@interface DLSponsoringBannerModule (Internal)

/**
 Sponsoring Banner Ad
 */
@property (nonatomic, strong, readonly) DLSponsoringBannerAd *bannerAd;

/**
 Notifies DLSponsoringBannerModule that ad view was displayed with ad inside

 @param bannerAd DLSponsoringBannerAd that generated event.
 */
- (void)adViewDidShowSuccesfulyForBannerAd:(DLSponsoringBannerAd *)bannerAd;

/**
 Add delegate to the DLSponsoringBannerModule.

 @param delegate DLSponsoringBannerModuleDelegate implementation
 */
- (void)addDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate;

/**
 Remove delegate from the DLSponsoringBannerModule module.

 @param delegate DLSponsoringBannerModuleDelegate implementation
 */
- (void)removeDelegate:(id<DLSponsoringBannerModuleDelegate>)delegate;

/**
 Remove all delegates from the DLSponsoringBannerModule.
 */
- (void)removeAllDelegates;

/**
 *  Fetch Banner Ad data.
 */
- (void)fetchBannerAd;

@end
