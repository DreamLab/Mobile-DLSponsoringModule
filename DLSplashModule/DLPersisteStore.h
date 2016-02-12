//
//  DLPersisteStore.h
//  DLSplashModule
//
//  Created by Konrad Kierys on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

@interface DLPersisteStore : NSObject

@property (nonatomic, strong) NSURL *imageAdURL;
@property (nonatomic, assign) CGFloat imageAdWidth;
@property (nonatomic, assign) CGFloat imageAdHeight;

@property (nonatomic, strong) NSString *adText;

@property (nonatomic, assign) NSTimeInterval time;

@property (nonatomic, strong) NSURL *auditURL;
@property (nonatomic, strong) NSURL *audit2URL;
@property (nonatomic, strong) NSURL *clickURL;

@property (nonatomic, assign) int version;


- (instancetype)initWithJSONData:(NSData *)data;

@end
