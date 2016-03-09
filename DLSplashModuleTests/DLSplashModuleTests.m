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


@interface DLSplashModule ()

-(void)fetchSplashAdWithWebService:(DLSplashScreenWebService *)webService store:(DLStore *)store;

@end


@interface DLSplashModuleTests : XCTestCase

@property (nonatomic, strong) id store;
@property (nonatomic, strong) DLSplashScreenWebService *webService;
@property (nonatomic, strong) DLSplashModule *splashModule;
@property (nonatomic, strong) id delegate;
@end

@implementation DLSplashModuleTests

- (void)setUp {
    [super setUp];

    self.store = OCMClassMock([DLStore class]);
    self.webService =  OCMClassMock([DLSplashScreenWebService class]);
    self.splashModule = [[DLSplashModule alloc] init];
    id delegate = OCMProtocolMock(@protocol(DLSplashModuleDelegate));
    [self.splashModule addDelegate: delegate];
}

- (void)tearDown {
    [super tearDown];
    
    self.store = nil;
    self.webService = nil;
    self.splashModule = nil;
    self.delegate = nil;
}

- (void)testFetchSplashAdWithWebServiceStore_emptyCacheSuccessfulResponse_splashScreenShouldDisplayAdCalled
{
    OCMStub([self.store cachedSplashAd]).andReturn(nil);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:OCMClassMock([DLSplashAd class]), [NSNull null], nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], [NSNull null], nil])]);

    OCMExpect([self.delegate splashScreenShouldDisplayAd]);
    OCMExpect([self.store cacheSplashAd:[OCMArg any]]);

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
    OCMVerifyAllWithDelay(self.store, 4);
}

- (void)testFetchSplashAdWithWebServiceStore_nonEmptyCacheSuccessfulResponseSuccessfulImageFetching_splashScreenShouldDisplayAdCalled
{
    DLSplashAd *splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd image]).andReturn(OCMClassMock([UIImage class]));
    OCMStub([splashAd version]).andReturn(1);

    OCMStub([self.store cachedSplashAd]).andReturn(splashAd);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:OCMClassMock([DLSplashAd class]), [NSNull null], nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], [NSNull null], nil])]);

    OCMExpect([self.delegate splashScreenShouldDisplayAd]);
    OCMExpect([self.store cacheSplashAd:[OCMArg any]]);

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
    OCMVerifyAllWithDelay(self.store, 4);
}

- (void)testFetchSplashAdWithWebServiceStore_nonEmptyCacheFailedResponse_splashScreenShouldDisplayAdCalled
{
    DLSplashAd *splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd image]).andReturn(OCMClassMock([UIImage class]));
    OCMStub([splashAd version]).andReturn(1);

    OCMStub([self.store cachedSplashAd]).andReturn(splashAd);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:[NSNull null], OCMClassMock([NSError class]), nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], [NSNull null], nil])]);

    OCMExpect([self.delegate splashScreenShouldDisplayAd]);
    [[self.store reject] cacheSplashAd:[OCMArg any]];

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
}

- (void)testFetchSplashAdWithWebServiceStore_emptyCacheFailedResponse_splashScreenShouldBeClosedCalled
{
    OCMStub([self.store cachedSplashAd]).andReturn(nil);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:[NSNull null], OCMClassMock([NSError class]), nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], [NSNull null], nil])]);

    OCMExpect([self.delegate splashScreenShouldBeClosed]);
    [[self.store reject] cacheSplashAd:[OCMArg any]];

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);

}

- (void)testFetchSplashAdWithWebServiceStore_nonEmptyCacheSuccessfulResponseFailedImageFetching_splashScreenShouldDisplayAdCalled
{
    DLSplashAd *splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd image]).andReturn(OCMClassMock([UIImage class]));
    OCMStub([splashAd version]).andReturn(1);

    OCMStub([self.store cachedSplashAd]).andReturn(splashAd);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:OCMClassMock([DLSplashAd class]), [NSNull null], nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], OCMClassMock([NSError class]), nil])]);

    OCMExpect([self.delegate splashScreenShouldDisplayAd]);
    [[self.store reject] cacheSplashAd:[OCMArg any]];

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
}

- (void)testFetchSplashAdWithWebServiceStore_emptyCacheSuccessfulResponseFailedImageFetching_splashScreenShouldBeClosedCalled
{
    OCMStub([self.store cachedSplashAd]).andReturn(nil);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:OCMClassMock([DLSplashAd class]), [NSNull null], nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], OCMClassMock([NSError class]), nil])]);

    OCMExpect([self.delegate splashScreenShouldBeClosed]);
   [[self.store reject] cacheSplashAd:[OCMArg any]];

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
}

- (void)testFetchSplashAdWithWebServiceStore_nonEmptyCacheSuccessfulResponseTheSameVersion_splashScreenShouldBeDisplayCalledNotCached
{
    DLSplashAd *splashAd = OCMClassMock([DLSplashAd class]);
    OCMStub([splashAd image]).andReturn(OCMClassMock([UIImage class]));
    OCMStub([splashAd version]).andReturn(1);

    OCMStub([self.store cachedSplashAd]).andReturn(splashAd);
    OCMStub([self.webService fetchDataWithCompletion:([OCMArg invokeBlockWithArgs:splashAd, [NSNull null], nil])]);
    OCMStub([self.webService fetchImageAtURL:[OCMArg any] numberOfRetries:3 completion:([OCMArg invokeBlockWithArgs:[NSNull null], [NSNull null], [NSNull null], nil])]);

    OCMExpect([self.delegate splashScreenShouldDisplayAd]);
    [[self.store reject] cacheSplashAd:[OCMArg any]];

    [self.splashModule adViewDidShow:nil]; // this call is required to enable timer
    [self.splashModule fetchSplashAdWithWebService:self.webService store:self.store];

    OCMVerifyAllWithDelay(self.delegate, 4);
}

@end
