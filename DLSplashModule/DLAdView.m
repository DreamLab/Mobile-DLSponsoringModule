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

@interface DLAdView()
@property (nonatomic, weak) DLSplashModule *splashModule;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL displayed;
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
    [self.splashModule addDelegate:self];

    self.imageView = [[UIImageView alloc] initWithImage: nil];
    [self addSubview:self.imageView];
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];

    [self addConstraints: @[centerX, centerY, width, height]];

    [self initializeGestureRecognizer];
    [self displayAd];
}

- (void)initializeGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)dealloc
{
    [self.splashModule removeDelegate:self];
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
        [self.splashModule adViewDidShow:self];
    }
}

- (void)displayAd
{
    UIImage *image = DLSplashModule.sharedInstance.splashAd.image;
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:image];
            // if image is smaller than view, then center it, otherwise aspect fit.
            if (self.splashAd.imageWidth < kMaxSizeOfImageView && self.splashAd.imageHeight < kMaxSizeOfImageView) {
                self.imageView.contentMode = UIViewContentModeCenter;
            } else {
                self.imageView.contentMode = UIViewContentModeScaleAspectFit;
            }
            [self.splashModule adViewDidDisplayImage:self];
        });
    }
}

#pragma mark - DLSplashModuleDelegate
- (void)splashScreenShouldDisplayAd
{
    [self displayAd];
}

- (void)splashScreenShouldClose
{
    [self.delegate splashScreenShouldClose];
}

@end
