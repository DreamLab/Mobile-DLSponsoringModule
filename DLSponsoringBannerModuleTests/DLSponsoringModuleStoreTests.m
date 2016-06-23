//
//  DLSponsoringModuleStoreTests.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 25.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

@import Foundation;
@import UIKit;
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "DLSponsoringModuleStore.h"
#import "DLSponsoringBannerAd.h"
#import "DLTestingHelper.h"

@interface DLSponsoringModuleStore : XCTestCase

@property (nonatomic, strong) id userDefaults;
@property (nonatomic, strong) DLSponsoringModuleStore *store;

@end

@interface DLSponsoringModuleStore ()
- (UIImage *)imageAtLocation:(NSURL *)imageLocation;
- (BOOL)removeCachedImageAd;
@end


@implementation DLSponsoringModuleStore
// TODO: Rewrite tests for DLSponsoringBannerModule
//
//- (void)setUp
//{
//    [super setUp];
//
//    self.userDefaults = OCMClassMock([NSUserDefaults class]);
//    OCMStub([self.userDefaults standardUserDefaults]).andReturn(self.userDefaults);
//
//    self.store = [[DLStore alloc] init];
//}
//
//- (void)tearDown
//{
//    self.userDefaults = nil;
//    self.store = nil;
//    [super tearDown];
//}
//
//- (void)testSaveAdImageFromTemporaryLocationOfSplashAd_givenWrongTemporaryLocation_shouldReturnFalse
//{
//    id fileManager = OCMClassMock([NSFileManager class]);
//    OCMStub([fileManager defaultManager]).andReturn(fileManager);
//
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:[DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"]];
//    splashAd.imageFileName = @"fileName.png";
//
//    BOOL result = [self.store saveAdImageFromTemporaryLocation:[NSURL URLWithString:@"file://location/"] ofSplashAd:splashAd];
//    XCTAssertFalse(result, @"Result of saving image should be false");
//
//    OCMVerify([fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask]);
//    OCMVerify([fileManager moveItemAtURL:[OCMArg any] toURL:[OCMArg any] error:(NSError *__autoreleasing *)[OCMArg anyPointer]]);
//}
//
//- (void)testSaveAdImageFromTemporaryLocationOfSplashAd_givenCorrectTemporaryLocation_shouldReturnTrue
//{
//    id fileManager = OCMClassMock([NSFileManager class]);
//    OCMStub([fileManager defaultManager]).andReturn(fileManager);
//    OCMStub([fileManager moveItemAtURL:[OCMArg any] toURL:[OCMArg any] error:(NSError *__autoreleasing *)[OCMArg anyPointer]]).andReturn(YES);
//
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:[DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"]];
//    splashAd.imageFileName = @"fileName.png";
//
//    BOOL result = [self.store saveAdImageFromTemporaryLocation:[NSURL URLWithString:@"file://location/"] ofSplashAd:splashAd];
//    XCTAssertTrue(result, @"Result of saving image should be true");
//
//    OCMVerify([fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask]);
//    OCMVerify([fileManager moveItemAtURL:[OCMArg any] toURL:[OCMArg any] error:(NSError *__autoreleasing *)[OCMArg anyPointer]]);
//}
//
//- (void)testCacheSplashAd_givenNilAsSplashAd_dataIsSavedToUserDefaults
//{
//    [self.store cacheSplashAd:nil];
//    OCMVerify([self.userDefaults setObject:[OCMArg isNil] forKey:kDLSponsoringBannerAdJSONCacheKey]);
//    OCMVerify([self.userDefaults setObject:[OCMArg isNil] forKey:kDLSponsoringBannerAdImageFileNameCacheKey]);
//    OCMVerify([self.userDefaults synchronize]);
//}
//
//- (void)testCacheSplashAd_givenProperSplashAd_dataIsSavedToUserDefaults
//{
//    NSData *jsonData = [DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"];
//    DLSponsoringBannerAd *splashAd = [[DLSponsoringBannerAd alloc] initWithJSONData:jsonData];
//    [self.store cacheSplashAd:splashAd];
//
//    NSError *parsingError;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&parsingError];
//
//    XCTAssertNil(parsingError, @"Parsing error should be nil");
//
//    OCMVerify([self.userDefaults setObject:json forKey:kDLSponsoringBannerAdJSONCacheKey]);
//    OCMVerify([self.userDefaults setObject:[OCMArg any] forKey:kDLSponsoringBannerAdImageFileNameCacheKey]);
//    OCMVerify([self.userDefaults synchronize]);
//}
//
//- (void)testCachedSplashAd_methodInvoked_nsUserDefaultsShouldBeUsed
//{
//    NSData *jsonData = [DLTestingHelper dataFromJSONFileNamed:@"CorrectJsonData"];
//    NSError *parsingError;
//    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&parsingError];
//    XCTAssertNil(parsingError, @"Parsing error should be nil");
//
//    OCMStub([self.userDefaults objectForKey:kDLSponsoringBannerAdJSONCacheKey]).andReturn(json);
//    OCMStub([self.userDefaults objectForKey:kDLSponsoringBannerAdImageFileNameCacheKey]).andReturn(@"fileName");
//
//    [self.store cachedSplashAd];
//    OCMVerify([self.userDefaults objectForKey:kDLSponsoringBannerAdJSONCacheKey]);
//    OCMVerify([self.userDefaults objectForKey:kDLSponsoringBannerAdImageFileNameCacheKey]);
//}
//
//- (void)testRemoveCachedImageAd_methodIsInvoked_NSFileManagerMethodsShoudBeCalled
//{
//    OCMStub([self.userDefaults objectForKey:kDLSponsoringBannerAdImageFileNameCacheKey]).andReturn(@"fileName");
//
//    id fileManager = OCMClassMock([NSFileManager class]);
//    OCMStub([fileManager defaultManager]).andReturn(fileManager);
//
//    [self.store removeCachedImageAd];
//
//    OCMVerify([fileManager URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask]);
//    OCMVerify([fileManager removeItemAtURL:[OCMArg any] error:(NSError *__autoreleasing *)[OCMArg anyPointer]]);
//}
//
//- (void)testClearCache_methodInvoked_nsUserDefaultsShouldBeUsed
//{
//    [self.store clearCache];
//
//    OCMVerify([self.userDefaults removeObjectForKey:kDLSponsoringBannerAdJSONCacheKey]);
//    OCMVerify([self.userDefaults removeObjectForKey:kDLSponsoringBannerAdImageFileNameCacheKey]);
//    OCMVerify([self.userDefaults synchronize]);
//}
//
//- (void)testImageAtLocation_givenUrl_dataWithContentsOfUrlShouldBeCreated
//{
//    id data = OCMClassMock([NSData class]);
//    OCMStub([data dataWithContentsOfURL:[OCMArg any]]);
//
//    [self.store imageAtLocation:[NSURL URLWithString:@"file://somelocation"]];
//
//    OCMVerify([data dataWithContentsOfURL:[OCMArg isNotNil]]);
//}
//
//- (void)testImageAtLocation_givenUrl_imageWithDataShouldBeInvoked
//{
//    id image = OCMClassMock([UIImage class]);
//    OCMStub([image imageWithData:[OCMArg any]]);
//
//    [self.store imageAtLocation:[NSURL URLWithString:@"file://somelocation"]];
//
//    OCMVerify([image imageWithData:[OCMArg any]]);
//}
//
//- (void)testClearQueuedTrackingLinks_methodInvoked_nsUserDefaultsShouldBeUsed
//{
//    [self.store clearQueuedTrackingLinks];
//
//    OCMVerify([self.userDefaults removeObjectForKey:kDLSplashQueuedTrackingLinksCacheKey]);
//    OCMVerify([self.userDefaults synchronize]);
//}
//
//- (void)testRemoveTrackingLink_givenUrl_objectIsRemovedFromQueue
//{
//    id mutableArray = OCMClassMock([NSMutableArray class]);
//    OCMStub([mutableArray arrayWithArray:[OCMArg any]]).andReturn(mutableArray);
//
//    id store = OCMPartialMock(self.store);
//    [store removeTrackingLink:[NSURL URLWithString:@"https://example.com"]];
//
//    OCMVerify([store queuedTrackingLinks]);
//    OCMVerify([mutableArray removeObject:[OCMArg isNotNil]]);
//    OCMVerify([store queueTrackingLinks:[OCMArg any]]);
//}
//
//- (void)testQueueTrackingLink_givenUrl_urlShouldBeAddedToQueue
//{
//    id mutableArray = OCMClassMock([NSMutableArray class]);
//    OCMStub([mutableArray arrayWithArray:[OCMArg any]]).andReturn(mutableArray);
//
//    id store = OCMPartialMock(self.store);
//    [store queueTrackingLink:[NSURL URLWithString:@"https://example.com"]];
//
//    OCMVerify([store queuedTrackingLinks]);
//    OCMVerify([mutableArray addObject:[OCMArg isNotNil]]);
//    OCMVerify([store queueTrackingLinks:[OCMArg isNotNil]]);
//}
//
//- (void)testAreAnyTrackingLinksQueued_methodInvoked_shouldCallQueuedTrackingLinks
//{
//    id store = OCMPartialMock(self.store);
//    OCMStub([store queuedTrackingLinks]);
//
//    [store areAnyTrackingLinksQueued];
//
//    OCMVerify([store queuedTrackingLinks]);
//}

@end
