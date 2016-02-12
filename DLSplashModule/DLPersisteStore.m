//
//  DLPersisteStore.m
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLPersisteStore.h"

NSString * const kSplashScreenPersisteStoreKey = @"com.dreamlab.splash_screen.persiste_store";

@interface DLPersisteStore ()

@property (nonatomic, strong) NSDictionary *jsonDictionary;

@end

@implementation DLPersisteStore

- (instancetype)initWithJSONData:(NSData *)data
{
    self = [super init];
    if (!self) {
        return nil;
    }

    _jsonDictionary = [self parseJSONData:data];

    return self;
}

- (NSDictionary *)parseJSONData:(NSData *)data
{
    NSError *parsingError = nil;

    NSDictionary *jsonDictionary = [NSJSONSerialization JSONObjectWithData:data
                                                                   options:kNilOptions
                                                                     error:&parsingError];

    if (parsingError) {
        NSLog(@"Parsing error occured: %@", parsingError.description);
        return nil;
    }

    NSLog(@"Json parsed: %@", jsonDictionary[@"splash"]);
    return jsonDictionary[@"splash"];
}

- (NSURL *)imageAdURL
{
    return [NSURL URLWithString:self.jsonDictionary[@"image"]];
}

- (CGFloat)imageAdWidth
{
    return (CGFloat)[(NSNumber *)self.jsonDictionary[@"width"] doubleValue];
}

- (CGFloat)imageAdHeight
{
    return (CGFloat)[(NSNumber *)self.jsonDictionary[@"height"] doubleValue];
}

- (NSString *)adText
{
    return (NSString *)self.jsonDictionary[@"txt"];
}

- (NSTimeInterval)time
{
    return [(NSNumber *)self.jsonDictionary[@"time"] doubleValue];
}

- (NSURL *)auditURL
{
    return [NSURL URLWithString:self.jsonDictionary[@"audit"]];
}

- (NSURL *)audit2URL
{
    return [NSURL URLWithString:self.jsonDictionary[@"audit2"]];
}

- (NSURL *)clickURL
{
    return [NSURL URLWithString:self.jsonDictionary[@"click"]];
}

- (int)version
{
    return [(NSNumber *)self.jsonDictionary[@"ver"] intValue];
}

@end
