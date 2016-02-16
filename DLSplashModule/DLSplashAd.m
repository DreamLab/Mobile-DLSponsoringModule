//
//  DLSplashAd.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSplashAd.h"

NSString * const kSplashScreenPersisteStoreKey = @"com.dreamlab.splash_screen.persiste_store";

@interface DLSplashAd ()

@property (nonatomic, strong) NSDictionary *json;

@end

@implementation DLSplashAd

- (instancetype)initWithJSONData:(NSData *)data
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _json = [DLSplashAd parseJSONData:data];

    return (_json != nil) ? self : nil;
}

- (NSURL *)imageURL
{
    return [NSURL URLWithString:self.json[@"image"]];
}

- (CGFloat)imageWidth
{
    return [self.json[@"width"] doubleValue];
}

- (CGFloat)imageHeight
{
    return [self.json[@"height"] doubleValue];
}

- (NSString *)text
{
    return self.json[@"txt"];
}

- (NSTimeInterval)time
{
    return [self.json[@"time"] doubleValue];
}

- (NSURL *)auditURL
{
    return [NSURL URLWithString:self.json[@"audit"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.json[@"audit2"]];
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.json[@"click"]];
}

- (NSInteger)version
{
    return [self.json[@"ver"] intValue];
}

#pragma mark - private methods

+ (NSDictionary *)parseJSONData:(NSData *)data
{
    NSError *parsingError = nil;

    NSDictionary *bodyDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&parsingError];

    if (parsingError) {
        NSLog(@"Parsing error occurred: %@", parsingError.description);
        return nil;
    }

    if ([bodyDictionary count] <=  0) {
        return nil;
    }

    return bodyDictionary[@"splash"];
}

@end
