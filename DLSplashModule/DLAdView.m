//
//  DLAdView.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashModule.h"

/// Max size of ImageView
static NSInteger kMaxSizeOfImageView = 150;

@interface DLAdView()
@property (nonatomic, weak) DLSplashModule* splashModule;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic) BOOL isDisplayed;
@property (nonatomic, strong) NSTimer* displayTimer;
@end

@implementation DLAdView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.isDisplayed = false;

    UIImage *image = self.splashModule.image;
    CGSize imageSize = self.splashModule.imageSize;

    self.imageView = [[UIImageView alloc] initWithImage: image];

    // if image is smaller than view, then center it, otherwise aspect fit.
    if (imageSize.width < kMaxSizeOfImageView && imageSize.height < kMaxSizeOfImageView) {
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    [self addSubview:self.imageView];

    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];

    [self addConstraints: @[centerX, centerY, width, height]];
}

- (void)layoutSubviews
{
    if (!self.isDisplayed) {
        self.isDisplayed = true;
        [self startWaitingForDataToDisplay];
    }
}

- (void)startWaitingForDataToDisplay
{
    // [JZ] TODO: get time from DLSplashModule/DLSplashAd
    NSInteger displayTime = 3;

    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:displayTime
                                                         target:self
                                                       selector:@selector(displayTimePassed)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)displayTimePassed
{
    if (self.displayTimer) {
        // TODO: notify app that can hide splash
    }
}

- (void)sendAuditData
{
    // [JZ] TODO: send Audit Data (separate task)
}

@end
