//
//  DLSplashModuleTests.m
//  DLSplashModuleTests
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>

#import "DLSplashModule.h"
#import "DLSplashModule+Internal.h"
#import "DLStore.h"
#import "DLSplashScreenWebService.h"

@interface DLSplashModuleTests : XCTestCase

@property (nonatomic, strong) DLStore *store;
@property (nonatomic, strong) DLSplashScreenWebService *webService;

@end

@implementation DLSplashModuleTests

- (void)setUp {
    [super setUp];

    self.store = OCMClassMock([DLStore class]);
    self.webService =  OCMClassMock([DLSplashScreenWebService class]);


    }

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFetchSplashAdWith
{
    DLSplashModule *splashModule = [[DLSplashModule alloc] init];

    DLSplashAd *splashAd = OCMClassMock([DLSplashAd class]);

    OCMStub([self.store cachedSplashAd]).andReturn(nil);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:splashAd, [NSNull null], nil])]);
    // Call block with YES.
//    OCMStub([mock theMethod:([OCMArg invokeBlockWithArgs:@YES, nil])];

    [splashModule fetchSplashAdWith:self.webService store:self.store];


}

@end
