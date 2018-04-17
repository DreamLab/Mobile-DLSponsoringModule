//
//  UIColor+Hex.m
//  DLSponsoringBannerModule
//
//  Created by Szeremeta Adam on 27.02.2018.
//  Copyright © 2018 DreamLab. All rights reserved.
//

#import "UIColor+Hex.h"

@implementation UIColor (Hex)

// Assumes input like "#00FF00" (#RRGGBB)
+ (UIColor *)colorFromHexString:(NSString *)hexString {
    if ([hexString isKindOfClass:[NSNull class]] || [hexString length] == 0) {
        return nil;
    }

    // Declare an unsigned int rgbValue, scan the hexString, convert it to an int, create the RGB colors values, and return a UIColor
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];

    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
