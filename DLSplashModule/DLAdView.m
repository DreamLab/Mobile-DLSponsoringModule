//
//  DLAdView.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashModule.h"

@interface DLAdView()
@property (nonatomic, weak) DLSplashModule* splashModule;
@end

@implementation DLAdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        // [JZ] TODO
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        // [JZ] TODO
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // [JZ] TODO
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//    self.image.size =
//}

- (void)setSize:(CGSize)size
{

}

@end
