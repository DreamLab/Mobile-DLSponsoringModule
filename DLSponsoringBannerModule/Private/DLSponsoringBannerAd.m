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
    return [NSURL URLWithString:self.fields[@"audit"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.fields[@"audit2"]];
}

- (NSURL *)actionCountURL
{
    NSTimeInterval timeStamp = [[NSDate date] timeIntervalSince1970];
    NSString *actionCountUrlString = [NSString stringWithFormat:@"%@view?%f", self.meta[@"actioncount"], timeStamp];

    return [NSURL URLWithString:actionCountUrlString];
}

- (NSURL *)clickURL
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.meta[@"adclick"], self.fields[@"click"]];

    return [NSURL URLWithString:urlString];
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
    NSDictionary *firstElement = [((NSArray *)self.json[@"ads"]) firstObject];

    return firstElement[@"data"][@"fields"];
}

- (NSDictionary *)meta {
    NSDictionary *firstElement = [((NSArray *)self.json[@"ads"]) firstObject];

    return firstElement[@"data"][@"meta"];
}

@end
