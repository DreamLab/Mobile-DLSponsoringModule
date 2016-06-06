//
//  DLAdViewTests.m
//  DLSponsoringBanerModule
//
//  Created by Jacek Zapart on 25.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashAd.h"
#import "DLSponsoringBanerModule.h"
#import "DLSponsoringBanerModule+Internal.h"
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

@interface DLAdView ()
- (void)displayAd:(DLSplashAd *)splashAd withImage:(UIImage *)image;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;

@end

@interface DLAdViewTests : XCTestCase

@end

@implementation DLAdViewTests

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testDisplayAd_validSplashAd_imageSizeProperlySet {
    DLAdView *adView = [[DLAdView alloc] init];

    id splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd imageWidth]).andReturn(121);
    OCMStub([splashAd imageHeight]).andReturn(119);

    [adView displayAd:splashAd withImage:OCMClassMock([UIImage class])];

    XCTAssertEqual(adView.widthConstraint.constant, 121);
    XCTAssertEqual(adView.heightConstraint.constant, 119);
}

@end
