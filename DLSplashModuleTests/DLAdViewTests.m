//
//  DLAdViewTests.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 25.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashAd.h"
#import "DLSplashModule.h"
#import "DLSplashModule+Internal.h"
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
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    DLAdView *adView = [[DLAdView alloc] init];

    id splashModule = OCMClassMock([DLSplashModule class]);
    id splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd imageWidth]).andReturn(121);
    OCMStub([splashAd imageHeight]).andReturn(119);
    OCMStub([splashAd image]).andReturn(OCMClassMock([UIImage class]));
    OCMStub([splashModule sharedInstance]).andReturn(splashModule);
    OCMStub([splashModule splashAd]).andReturn(splashAd);

    [adView displayAd:splashAd withImage:OCMClassMock([UIImage class])];

    XCTAssertEqual(adView.widthConstraint.constant, 121);
    XCTAssertEqual(adView.heightConstraint.constant, 119);
}

@end
