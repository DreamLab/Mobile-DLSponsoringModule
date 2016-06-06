//
//  DLTestingHelper.m
//  DLSponsoringBanerModule
//
//  Created by Konrad Kierys on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLTestingHelper.h"

@implementation DLTestingHelper

+ (NSData *)dataFromJSONFileNamed:(NSString *)fileName
{
    NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:fileName ofType:@"json"];
    return [NSData dataWithContentsOfFile:path];
}

@end
