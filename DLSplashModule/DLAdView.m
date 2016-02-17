//
//  DLAdView.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashModule.h"
#import "DLSplashAd.h"

/// Max size of ImageView
static const NSInteger kMaxSizeOfImageView = 150;
static const NSTimeInterval kMaxTimeOfWaitingForContent = 3;

@interface DLAdView()
@property (nonatomic, weak) DLSplashModule *splashModule;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL displayed;
@property (nonatomic, strong) NSTimer *displayTimer;
@end

@implementation DLAdView

#pragma mark - Initializers

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

#pragma mark - Private Initializers

- (void)initialize
{
    self.displayed = NO;
    self.splashModule = DLSplashModule.sharedInstance;

    UIImage *image = nil;

    self.imageView = [[UIImageView alloc] initWithImage: image];
    [self addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];

    [self addConstraints: @[centerX, centerY, width, height]];

    [self initializeGestureRecognizer];
}

- (void)initializeGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
}

#pragma mark - Private Methods

- (void)imageTapped:(id)sender
{
    [self.delegate adView:self didTapImageWithUrl:self.splashAd.clickURL];
}

- (void)layoutSubviews
{
    if (!self.displayed) {
        self.displayed = YES;
        [self startWaitingForDataToDisplay];
    }
}

- (void)startWaitingForDataToDisplay
{
    NSInteger waitingTime = kMaxTimeOfWaitingForContent;
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:waitingTime
                                                         target:self
                                                       selector:@selector(waitingTimePassed)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)waitingTimePassed
{
    self.displayTimer = nil;

    // TODO: Get cached version of splashAd and display it
    self.splashAd = self.splashModule.splashAd;
    [self displayAd];
}

- (void)displayAd
{
    UIImage *image = nil; // TODO: get image from splashAd <- add image property
    [self.imageView setImage:image];

    // if image is smaller than view, then center it, otherwise aspect fit.
    if (self.splashAd.imageWidth < kMaxSizeOfImageView && self.splashAd.imageHeight < kMaxSizeOfImageView) {
        self.imageView.contentMode = UIViewContentModeCenter;
    } else {
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }

    NSInteger waitingTime = self.splashAd.time;
    self.displayTimer = [NSTimer scheduledTimerWithTimeInterval:waitingTime
                                                         target:self
                                                       selector:@selector(displayingTimePassed)
                                                       userInfo:nil
                                                        repeats:NO];
}

- (void)displayingTimePassed
{
    self.displayTimer = nil;
    // TODO: notify about displaying time passed
}

- (void)sendAuditData
{
    // [JZ] TODO: send Audit Data (separate task)
}

@end
