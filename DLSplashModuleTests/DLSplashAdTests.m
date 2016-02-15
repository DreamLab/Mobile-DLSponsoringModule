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

- (void)setUp {
    [super setUp];

    self.correctJSONData = [DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"];
    self.wrongJSONData = [DLTestingHelper dataFromJSONFileNamed:@"WrongJsonData"];
    self.emptyJSONData = [DLTestingHelper dataFromJSONFileNamed:@"EmptyJsonData"];
}

- (void)tearDown {
    self.correctJSONData = nil;
    self.wrongJSONData = nil;
    self.emptyJSONData = nil;

    [super tearDown];
}

- (void)testCreatingSplashAd_givenCorrectJSONData_splashAdShouldNotBeNil {
    DLSplashAd *splashAd = [[DLSplashAd alloc] initWithJSONData:self.correctJSONData];

    XCTAssertNotNil(splashAd, @"Splash Ad should not be nil");
}

@end
