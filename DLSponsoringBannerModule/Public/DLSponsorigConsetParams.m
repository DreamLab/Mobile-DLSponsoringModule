//
//  DLSponsorigConsetParams.m
//  DLSponsoringBannerModule
//
//  Created by Kordal Paweł on 11.05.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import "DLSponsorigConsetParams.h"

@interface DLSponsorigConsetParams ()

@property (nonatomic, strong) NSString *pubConsent;
@property (nonatomic, strong) NSString *adpConsent;
@property (nonatomic, strong) NSString *euConsent;

@end

@implementation DLSponsorigConsetParams

- (instancetype _Nonnull)initWithPubConsent:(NSString* _Nonnull)pubConsent
                                 adpConsent:(NSString* _Nonnull)adpConsent
                                  euConsent:(NSString* _Nonnull)euConsent
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
