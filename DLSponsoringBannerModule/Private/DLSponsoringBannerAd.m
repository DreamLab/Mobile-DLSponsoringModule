//
//  DLSponsoringBannerAd.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBannerAd.h"
#import "UIColor+Hex.h"

@interface DLSponsoringBannerAd ()

// Only tpl type:
@property (nonatomic, strong, readwrite) NSString *actionCount;

@end

@implementation DLSponsoringBannerAd

#pragma mark - instancetype

- (instancetype)initWithJSONData:(NSData *)data
{
    NSDictionary *parsedJSON = [DLSponsoringBannerAd parseJSONData:data];

    return [self initWithJSONDictionary:parsedJSON];
}

- (instancetype)initWithJSONDictionary:(NSDictionary *)json
{
    // Check which response type we have
    NSString *type = [DLSponsoringBannerAd sponsoringTypeFromJSON:json];
    if (!type) {
        return nil;
    }


    if ([type isEqualToString:@"tpl"]) {
        return [self initWithTPLJSONDictionary:json];
    }

    if ([type isEqualToString:@"std"]) {
        return [self initWithSTDJSONDictionary:json];
    }

    if ([type isEqualToString:@"empty"]) {
        return [self initWithEmptyJSONDictionary:json];
    }

    return nil;
}

- (instancetype)initWithTPLJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];
    if (!firstElement) {
        return nil;
    }

    _imageURL = [DLSponsoringBannerAd nsurlFromUnknownValue:firstElement[@"data"][@"fields"][@"image"]];
    _imageWidth = [firstElement[@"data"][@"meta"][@"width"] doubleValue];
    _imageHeight = [firstElement[@"data"][@"meta"][@"height"] doubleValue];
    _auditURL = [DLSponsoringBannerAd nsurlFromUnknownValue:firstElement[@"data"][@"fields"][@"audit"]];
    _audit2URL = [DLSponsoringBannerAd nsurlFromUnknownValue:firstElement[@"data"][@"fields"][@"audit2"]];

    NSString *clickUrlString = [NSString stringWithFormat:@"%@%@",
                                firstElement[@"data"][@"meta"][@"adclick"],
                                firstElement[@"data"][@"fields"][@"click"]];
    _clickURL = [DLSponsoringBannerAd nsurlFromUnknownValue:clickUrlString];

    _actionCount = firstElement[@"data"][@"meta"][@"actioncount"];
    _version = firstElement[@"data"][@"fields"][@"ver"];

    NSString *bgColor = firstElement[@"data"][@"fields"][@"background_color"];
    if (![bgColor isKindOfClass:[NSNull class]] && [bgColor length] > 0) {
        _backgroundColor= [UIColor colorFromHexString:bgColor];
    }

    if (_imageURL && _imageWidth && _imageHeight && _version) {
        _empty = false;
    } else {
        _empty = true;
    }

    _json = json;

    return self;
}

- (instancetype)initWithSTDJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];
    NSString *html = firstElement[@"html"];
    if (!firstElement || !html) {
        return nil;
    }

    NSData *htmlData = [html dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *htmlDictionary = [DLSponsoringBannerAd parseJSONData:htmlData];
    if (!htmlDictionary) {
        return nil;
    }

    _imageURL = [DLSponsoringBannerAd nsurlFromUnknownValue:htmlDictionary[@"image"]];
    _imageWidth = [htmlDictionary[@"width"] doubleValue];
    _imageHeight = [htmlDictionary[@"height"] doubleValue];
    _auditURL = [DLSponsoringBannerAd nsurlFromUnknownValue:htmlDictionary[@"audit"]];
    _audit2URL = [DLSponsoringBannerAd nsurlFromUnknownValue:htmlDictionary[@"audit2"]];
    _clickURL = [DLSponsoringBannerAd nsurlFromUnknownValue:htmlDictionary[@"click"]];
    _version = htmlDictionary[@"ver"];

    if (_imageURL && _imageWidth && _imageHeight && _version) {
        _empty = false;
    } else {
        _empty = true;
    }

    _json = json;

    return self;
}

- (instancetype)initWithEmptyJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self || json == nil) {
        return nil;
    }

    _empty = true;
     _json = json;

    return self;
}

#pragma mark - getters

- (NSURL *)actionCountURL
{
    if (!_actionCount) {
        return nil;
    }

    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *actionCountUrlString = [NSString stringWithFormat:@"%@view?%f", _actionCount, timeStamp];

    return [NSURL URLWithString:actionCountUrlString];
}

#pragma mark - private methods

+ (NSDictionary *)parseJSONData:(NSData *)data
{
    if (!data) {
        return nil;
    }

    NSError *parsingError = nil;
    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&parsingError];

    if (parsingError) {
        NSLog(@"Parsing error occurred: %@", parsingError.description);
        return nil;
    }

    return bodyDictionary;
}

+ (NSString *)sponsoringTypeFromJSON:(NSDictionary *)json {
    NSDictionary *firstElement = [((NSArray *)json[@"ads"]) firstObject];

    return firstElement[@"type"];
}

+ (NSURL *)nsurlFromUnknownValue:(NSObject *)value {
    NSURL *result = nil;

    if (![value isKindOfClass:[NSNull class]] && [value isKindOfClass:[NSString class]] && [((NSString *)value) length] > 0 ) {
        result = [NSURL URLWithString:(NSString *)value];
    }

    return result;
}

@end
