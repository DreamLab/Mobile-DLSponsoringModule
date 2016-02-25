//
//  DLSplashScreenWebServiceTests.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 25.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import UIKit;
@import Foundation;

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DLSplashScreenWebService.h"
#import "DLSplashAd.h"
#import "DLTestingHelper.h"

#pragma mark - DLSplashScreenWebService category

@interface DLSplashScreenWebService ()
@property (nonatomic, strong) NSURL *url;
- (void)performSessionDataTaskForURL:(NSURL *)url;
@end

#pragma mark - Unit Tests

@interface DLSplashScreenWebServiceTests : XCTestCase
@property (nonatomic, strong) id session;
@property (nonatomic, strong) DLSplashScreenWebService *webService;
@end

@implementation DLSplashScreenWebServiceTests

- (void)setUp {
    [super setUp];

    self.webService = [[DLSplashScreenWebService alloc] initWithAppSite:@"appsite_example"];

    self.session = OCMClassMock([NSURLSession class]);
    OCMStub([self.session sharedSession]).andReturn(self.session);
}

- (void)tearDown {

    [super tearDown];
}

- (void)testInitWithAppSite_givenProperAppSite_instanceAndPropertyShouldNotBeNil
{
    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:@"appsite_example"];

    XCTAssertNotNil(webService, @"webservice instance should not be nil");
    XCTAssertNotNil(webService.url, @"URL property should not be nil");
}

- (void)testInitWithAppSite_givenNilAppSite_instanceShouldBeNil
{
    DLSplashScreenWebService *webService = [[DLSplashScreenWebService alloc] initWithAppSite:nil];

    XCTAssertNil(webService, @"webservice instance should be nil");
}

- (void)testFetchDataWithCompletion_methodInvocation_nsURLSessionDataTaskWithRequestShouldBeCalled
{
    [self.webService fetchDataWithCompletion:nil];

    OCMVerify([self.session dataTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]);
}

- (void)testFetchImageAtURLCompletion_methodInvocation_nsURLSessionDownloadTaskWithRequestShouldBeCalled
{
    [self.webService fetchImageAtURL:nil completion:nil];

    OCMVerify([self.session downloadTaskWithRequest:[OCMArg any] completionHandler:[OCMArg any]]);
}

- (void)testTrackForSplashAd_givenProperSplashAd_performSessionDataTaskForURLShouldBeCalled
{
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:[DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"]];

    id partialMockedWebService = OCMPartialMock(self.webService);
    OCMExpect([partialMockedWebService performSessionDataTaskForURL:splashAd.auditURL]);
    OCMExpect([partialMockedWebService performSessionDataTaskForURL:splashAd.audit2URL]);

    [partialMockedWebService trackForSplashAd:splashAd];

    OCMVerifyAll(partialMockedWebService);
}

- (void)testTrackForSplashAd_givenNilSplashAd_performSessionDataTaskForURLShouldNotBeCalled
{
    DLSplashAd *splashAd = nil;

    id partialMockedWebService = OCMPartialMock(self.webService);

    [[partialMockedWebService reject] performSessionDataTaskForURL:[OCMArg any]];

    [partialMockedWebService trackForSplashAd:splashAd];
}

@end
