//
//  DLSponsorigconsentParams.m
//  DLSponsoringBannerModule
//
//  Created by Kordal Paweł on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import "DLSponsoringConsentParams.h"

@interface DLSponsoringConsentParams ()

@property (nonatomic, strong) NSString *pubConsent;
@property (nonatomic, strong) NSString *adpConsent;
@property (nonatomic, strong) NSString *euConsent;

@end

@implementation DLSponsoringConsentParams

- (instancetype _Nonnull)initWithPubConsent:(NSString*) pubConsent
                                 adpConsent:(NSString*) adpConsent
                                  euConsent:(NSString*) euConsent
{
    self = [super init];
    if (self) {
        _pubConsent = pubConsent;
        _adpConsent = adpConsent;
        _euConsent = euConsent;
    }

    return self;
}
@end
