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
    return [NSURL URLWithString:self.json[@"flat-belkagorna"][@"image"]];
}

- (CGFloat)imageWidth
{
    return [self.json[@"flat-belkagorna"][@"width"] doubleValue];
}

- (CGFloat)imageHeight
{
    return [self.json[@"flat-belkagorna"][@"height"] doubleValue];
}

- (NSURL *)auditURL
{
    return [NSURL URLWithString:self.json[@"flat-belkagorna"][@"audit"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.json[@"flat-belkagorna"][@"audit2"]];
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.json[@"flat-belkagorna"][@"click"]];
}

- (NSString *)version
{
    return self.json[@"flat-belkagorna"][@"ver"];
}

- (BOOL)empty
{
    return self.json[@"flat-belkagorna"] == nil;
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

@end
