//
//  DLAdView.m
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSplashModule.h"
#import "DLSplashModule+Internal.h"
#import "DLSplashAd.h"
#import "DLSplashModuleDelegate.h"

/// Max size of ImageView
static const NSInteger kMaxSizeOfImageView = 150;

@interface DLAdView() <DLSplashModuleDelegate>
@property (nonatomic, weak) DLSplashModule *splashModule;
@property (nonatomic, strong) DLSplashAd *splashAd;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) BOOL displayed;

@property (nonatomic, strong) NSLayoutConstraint *widthConstraint;
@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;
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

- (NSString *)associatedText
{
    return self.splashAd.text;
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

    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    self.widthConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];
    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:kMaxSizeOfImageView];

    [self addConstraints: @[centerXConstraint, topConstraint, self.widthConstraint, self.heightConstraint]];

    [self initializeGestureRecognizer];
}

- (void)initializeGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    self.imageView.userInteractionEnabled = YES;
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
    self.splashAd = DLSplashModule.sharedInstance.splashAd;
    UIImage *image = self.splashAd.image;
    if (image) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self displayAd:self.splashAd withImage:image];
        });
    }
}

// This method neet to be called in main queue or will crash!s
- (void)displayAd:(DLSplashAd *)splashAd withImage:(UIImage *)image
{
    [self.imageView setImage:image];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    self.widthConstraint.constant = splashAd.imageWidth;
    self.heightConstraint.constant = splashAd.imageHeight;
    [self.delegate adView:self didDisplayAdWithAssociatedText:self.associatedText];
    [self.splashModule adViewDidDisplayImage:self];
}

#pragma mark - DLSplashModuleDelegate
- (void)splashScreenShouldDisplayAd
{
    [self displayAd];
}

- (void)splashScreenShouldBeClosed
{
    [self.delegate splashScreenShouldBeClosed];
}

@end
