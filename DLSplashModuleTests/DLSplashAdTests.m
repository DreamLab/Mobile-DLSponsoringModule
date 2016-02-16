//
//  DLSplashAdTests.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLTestingHelper.h"
#import "DLSplashAd.h"

@interface DLSplashAdTests : XCTestCase

@property (nonatomic, strong) NSData *correctJSONData;
@property (nonatomic, strong) NSData *wrongJSONData;
@property (nonatomic, strong) NSData *emptyJSONData;

@end

@implementation DLSplashAdTests

- (void)setUp
{
    [super setUp];

    self.correctJSONData = [DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"];
    self.wrongJSONData = [DLTestingHelper dataFromJSONFileNamed:@"WrongJsonData"];
    self.emptyJSONData = [DLTestingHelper dataFromJSONFileNamed:@"EmptyJsonData"];
}

- (void)tearDown
{
    self.correctJSONData = nil;
    self.wrongJSONData = nil;
    self.emptyJSONData = nil;

    [super tearDown];
}

- (void)testCreatingSplashAd_givenCorrectJSONData_splashAdShouldNotBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd, @"Splash Ad should not be nil");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_imageUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.imageURL, @"SplashAd ImageURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://ocdn.eu/images/mastt/MTc7MDA_/b1f3414c51e4d27c5266ec3f490e7662.png"];
    XCTAssertEqualObjects(splashAd.imageURL, testURL, @"SplashAd ImageURL should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_imageWidthIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.imageWidth, 90, @"SplashAd imageWidth should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_imageHeightIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.imageHeight, 60, @"SplashAd imageHeight should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_adTextIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.text, @"SplashAd text should not be nil");
    XCTAssertEqualObjects(splashAd.text, @"Partner aplikacji", @"SplashAd text should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_timeIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.time, 5, @"SplashAd time should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_auditUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.auditURL, @"SplashAd auditURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/eclk/fa4,125202,255484/view?1455617456"];
    XCTAssertEqualObjects(splashAd.auditURL, testURL, @"SplashAd auditURL should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_audit2UrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.audit2URL, @"SplashAd audit2URL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://e.clk.onet.pl/clk,5450,16749/view/"];
    XCTAssertEqualObjects(splashAd.audit2URL, testURL, @"SplashAd audit2URL should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_clickUrlIsNotNilAndCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd.clickURL, @"SplashAd clickURL should not be nil");
    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/adclick/CID=125202/CCID=255484/CT=str/URL=http://m.onet.pl"];
    XCTAssertEqualObjects(splashAd.clickURL, testURL, @"SplashAd clickURL should be correct");
}

- (void)testCreatingSplashAd_givenCorrectJSONData_versionIsCorrect
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertEqual(splashAd.version, 1234512, @"SplashAd version should be correct");
}

- (void)testCreatingSplashAd_givenCorruptedJSONData_splashAdShouldBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.wrongJSONData];

    XCTAssertNil(splashAd, @"Splash Ad should be nil");
}

- (void)testCreatingSplashAd_givenEmptyJSONData_splashAdShouldBeNil
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.emptyJSONData];

    XCTAssertNil(splashAd, @"Splash Ad should be nil");
}

@end
