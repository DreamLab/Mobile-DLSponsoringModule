//
//  DLAdView.m
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdView.h"
#import "DLSponsoringBannerModule.h"
#import "DLSponsoringBannerModule+Internal.h"
#import "DLSponsoringBannerAd.h"
#import "DLSponsoringBannerModuleDelegate.h"

@interface DLAdView() <DLSponsoringBannerModuleDelegate>
@property (nonatomic, weak) DLSponsoringBannerModule *sponsoringBannerModule;
@property (nonatomic, strong) DLSponsoringBannerAd *bannerAd;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign, getter=isInitialized) BOOL initialized;
@property (nonatomic, assign, getter=isVisible) BOOL visible;
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

- (void)controllerViewWillAppear {
    self.bannerAd = DLSponsoringBannerModule.sharedInstance.bannerAd;
    [DLSponsoringBannerModule.sharedInstance fetchBannerAd];
    [self reloadAd];
    self.visible = YES;
}

- (void)controllerViewDidDisappear {
    self.visible = NO;
}

- (BOOL)isAdReady {
    return self.bannerAd;
}

- (CGSize)adSize {
    return self.proportionalAdSize;
}

#pragma mark - Private Initializers

- (void)initialize
{
    if (self.isInitialized) {
        return;
    }

    self.sponsoringBannerModule = DLSponsoringBannerModule.sharedInstance;
    [self.sponsoringBannerModule addDelegate:self];

    self.imageView = [[UIImageView alloc] init];

    [self addSubview:self.imageView];

    [self setupConstraints];
    [self initializeGestureRecognizer];

    self.initialized = YES;
}

- (void)initializeGestureRecognizer
{
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)dealloc
{
    [self.sponsoringBannerModule removeDelegate:self];
}

#pragma mark - Private Methods

- (void)setupConstraints {
    self.imageView.translatesAutoresizingMaskIntoConstraints = NO;

    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0];
    topConstraint.priority = 750;

    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
    bottomConstraint.priority = 750;

    NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0];

    NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];

    self.heightConstraint = [NSLayoutConstraint constraintWithItem:self.imageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:0];

    [self addConstraints: @[topConstraint, bottomConstraint, leadingConstraint, trailingConstraint, self.heightConstraint]];
}

- (void)imageTapped:(id)sender
{
    [self.delegate adView:self didTapImageWithUrl:self.bannerAd.clickURL];
}

// This method need to be called in main queue or will crash!
- (void)displayAd:(DLSponsoringBannerAd *)bannerAd
{
    self.bannerAd = bannerAd;
    [self reloadAd];
}

- (CGSize)proportionalAdSize {
    if (!self.isAdReady || self.bannerAd.imageWidth <= 0) {
        return CGSizeZero;
    }
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    CGFloat screenWidth = screenRect.size.width;
    CGFloat height = (screenWidth / self.bannerAd.imageWidth) * self.bannerAd.imageHeight;

    return CGSizeMake(screenWidth, height);
}

- (void)reloadAd {
    if (!self.isAdReady) {
        return;
    }

    self.imageView.image = self.bannerAd.image;
    self.heightConstraint.constant = self.proportionalAdSize.height;

    [self.sponsoringBannerModule adViewDidShowSuccesfulyForBannerAd:self.bannerAd];
}

#pragma mark - DLSponsoringBannerModuleDelegate

- (void)sposoringBannerModuleReceivedAd:(DLSponsoringBannerAd *)ad
{
    if ([self.bannerAd isEqual:ad] || self.isVisible) {
        // Do nothing if ad is already displayed on screen or reload it if it has changed
        return;
    }

    self.bannerAd = ad;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayAd:self.bannerAd];
        [self.delegate adViewNeedsToBeReloaded:self withExpectedSize:self.proportionalAdSize];
    });
}

@end
