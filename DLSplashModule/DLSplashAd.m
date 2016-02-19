//
//  DLSplashAd.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashAd.h"

NSString * const kSplashScreenPersisteStoreKey = @"com.dreamlab.splash_screen.persiste_store";

@implementation DLSplashAd

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
    NSDictionary *parsedJSON = [DLSplashAd parseJSONData:data];

    return [self initWithJSONDictionary:parsedJSON];
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:self.json[@"splash"][@"image"]];
}

- (CGFloat)imageWidth
{
    return [self.json[@"splash"][@"width"] doubleValue];
}

- (CGFloat)imageHeight
{
    return [self.json[@"splash"][@"height"] doubleValue];
}

- (NSString *)text
{
    return self.json[@"splash"][@"txt"];
}

- (NSTimeInterval)time
{
    return [self.json[@"splash"][@"time"] doubleValue];
}

- (NSURL *)auditURL
{
    return [NSURL URLWithString:self.json[@"splash"][@"audit"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.json[@"splash"][@"audit2"]];
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.json[@"splash"][@"click"]];
}

- (NSInteger)version
{
    return [self.json[@"splash"][@"ver"] intValue];
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

    if ([bodyDictionary count] <= 0) {
        return nil;
    }

    return bodyDictionary;
}

@end
