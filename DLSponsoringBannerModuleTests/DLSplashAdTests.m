//
//  DLSponsoringBannerAdTests.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DLTestingHelper.h"
#import "DLSponsoringBannerAd.h"

@interface DLSponsoringBannerAdTests : XCTestCase

@property (nonatomic, strong) NSData *correctJSONData;
@property (nonatomic, strong) NSData *wrongJSONData;
@property (nonatomic, strong) NSData *emptyJSONData;

@end

@implementation DLSponsoringBannerAdTests
// TODO: Rewrite tests for DLSponsoringBannerModule
//- (void)setUp
//{
//    [super setUp];
//
//    self.correctJSONData = [DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"];
//    self.wrongJSONData = [DLTestingHelper dataFromJSONFileNamed:@"WrongJsonData"];
//    self.emptyJSONData = [DLTestingHelper dataFromJSONFileNamed:@"EmptyJsonData"];
//}
//
//- (void)tearDown
//{
//    self.correctJSONData = nil;
//    self.wrongJSONData = nil;
//    self.emptyJSONData = nil;
//
//    [super tearDown];
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_splashAdShouldNotBeNil
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd, @"Splash Ad should not be nil");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_imageUrlIsNotNilAndCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd.imageURL, @"SplashAd ImageURL should not be nil");
//    NSURL *testURL = [NSURL URLWithString:@"http://ocdn.eu/images/mastt/MTc7MDA_/b1f3414c51e4d27c5266ec3f490e7662.png"];
//    XCTAssertEqualObjects(splashAd.imageURL, testURL, @"SplashAd ImageURL should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_imageWidthIsCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertEqual(splashAd.imageWidth, 90, @"SplashAd imageWidth should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_imageHeightIsCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertEqual(splashAd.imageHeight, 60, @"SplashAd imageHeight should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_adTextIsNotNilAndCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd.text, @"SplashAd text should not be nil");
//    XCTAssertEqualObjects(splashAd.text, @"Partner aplikacji", @"SplashAd text should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_timeIsCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertEqual(splashAd.time, 5, @"SplashAd time should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_auditUrlIsNotNilAndCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd.auditURL, @"SplashAd auditURL should not be nil");
//    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/eclk/fa4,125202,255484/view?1455617456"];
//    XCTAssertEqualObjects(splashAd.auditURL, testURL, @"SplashAd auditURL should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_audit2UrlIsNotNilAndCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd.audit2URL, @"SplashAd audit2URL should not be nil");
//    NSURL *testURL = [NSURL URLWithString:@"http://e.clk.onet.pl/clk,5450,16749/view/"];
//    XCTAssertEqualObjects(splashAd.audit2URL, testURL, @"SplashAd audit2URL should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_clickUrlIsNotNilAndCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertNotNil(splashAd.clickURL, @"SplashAd clickURL should not be nil");
//    NSURL *testURL = [NSURL URLWithString:@"http://csr.onet.pl/adclick/CID=125202/CCID=255484/CT=str/URL=http://m.onet.pl"];
//    XCTAssertEqualObjects(splashAd.clickURL, testURL, @"SplashAd clickURL should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorrectJSONData_versionIsCorrect
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.correctJSONData];
//
//    XCTAssertEqual(splashAd.version, 1234512, @"SplashAd version should be correct");
//}
//
//- (void)testInitWithJSONData_givenCorruptedJSONData_splashAdShouldBeNil
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.wrongJSONData];
//
//    XCTAssertNil(splashAd, @"Splash Ad should be nil");
//}
//
//- (void)testInitWithJSONData_givenEmptyJSONData_splashAdEmptyPropertyIsTrue
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:self.emptyJSONData];
//
//    XCTAssertTrue(splashAd.empty, @"Splash Ad should be nil");
//}
//
//- (void)testInitWithJSONData_givenNilAsJSONData_splashAdShouldBeNil
//{
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:nil];
//
//    XCTAssertNil(splashAd, @"Splash Ad should be nil");
//}

@end
