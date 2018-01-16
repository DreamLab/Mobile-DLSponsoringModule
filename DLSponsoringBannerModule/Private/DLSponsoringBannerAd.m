//
//  DLSponsoringBannerAd.m
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringBannerAd.h"

@implementation DLSponsoringBannerAd

- (instancetype)initWithJSONDictionary:(NSDictionary *)json
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _json = json;

    return (_json != nil ? self : nil);
}

- (instancetype)initWithJSONData:(NSData *)data
{
    NSDictionary *parsedJSON = [DLSponsoringBannerAd parseJSONData:data];

    return [self initWithJSONDictionary:parsedJSON];
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:self.fields[@"image"]];
}

- (CGFloat)imageWidth
{
    return [self.meta[@"width"] doubleValue];
}

- (CGFloat)imageHeight
{
    return [self.meta[@"height"] doubleValue];
}

- (NSURL *)auditURL
{
    return [NSURL URLWithString:self.fields[@"impression1"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.fields[@"impression2"]];
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.fields[@"click"]];
}

- (NSString *)version
{
    return self.fields[@"ver"];
}

- (BOOL)empty
{
    return self.meta == nil;
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

- (NSDictionary *)fields {
    return self.json[@"ads"][0][@"data"][@"fields"];
}

- (NSDictionary *)meta {
    return self.json[@"ads"][0][@"data"][@"meta"];
}

@end
