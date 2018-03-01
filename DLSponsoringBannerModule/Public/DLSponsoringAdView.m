//
//  DLSponsoringAdView.m
//  DLSponsoringBannerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLSponsoringAdView.h"
#import "DLSponsoringBannerModule.h"
#import "DLSponsoringBannerModule+Internal.h"
#import "DLSponsoringBannerAd.h"
#import "DLSponsoringBannerModuleDelegate.h"

@interface DLSponsoringAdView() <DLSponsoringBannerModuleDelegate>
@property (nonatomic, weak) DLSponsoringBannerModule *sponsoringBannerModule;
@property (nonatomic, strong) DLSponsoringBannerAd *bannerAd;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;

@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign, getter=isInitialized) BOOL initialized;
@property (nonatomic, assign, getter=isVisible) BOOL visible;
@property (nonatomic, assign) CGSize currentSize;
@end

@implementation DLSponsoringAdView

#pragma mark - Initializers

- (instancetype)initWithSponsoringModule:(DLSponsoringBannerModule *)module
{
    self = [super init];
    if (self) {
        [self initializeWithSponsoringModule: module];
    }
    
    return self;
}

- (void)parentViewWillAppear {
    self.bannerAd = self.sponsoringBannerModule.bannerAd;
    if (!self.bannerAd) {
        [self reloadAd];
    }
    [self.sponsoringBannerModule fetchBannerAd];
    [self.sponsoringBannerModule adViewDidShowSuccesfulyForBannerAd:self.bannerAd];
    self.visible = YES;
}

- (void)parentViewDidDisappear {
    self.visible = NO;
}

- (BOOL)isAdReady {
    return self.bannerAd != nil;
}

- (CGSize)adSize {
    return self.proportionalAdSize;
}

#pragma mark - Private Initializers

- (void)initializeWithSponsoringModule:(DLSponsoringBannerModule *)module
{
    if (self.isInitialized) {
        return;
    }

    _sponsoringBannerModule = module;
    [self.sponsoringBannerModule addDelegate:self];

    self.imageView = [[UIImageView alloc] init];
    self.imageView.accessibilityIdentifier = @"sponsoringBannerImageView";
    self.imageView.isAccessibilityElement = true;

    [self addSubview:self.imageView];

    [self setupConstraints];
    [self initializeGestureRecognizer];

    self.initialized = YES;
    self.bannerAd = module.bannerAd;
    self.currentSize = self.proportionalAdSize;

    [self reloadAd];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    if (!self.bannerAd.clickURL.absoluteString.length) {
        return;
    }
    [self.delegate adView:self didTapImageWithUrl:self.bannerAd.clickURL];
}

// This method need to be called in main queue or will crash!
- (void)displayAd:(DLSponsoringBannerAd *)bannerAd
{
    BOOL shouldReloadAd = ((bannerAd || self.bannerAd) && ![bannerAd isEqual:self.bannerAd]);
    self.bannerAd = bannerAd;

    if (shouldReloadAd) {
        [self reloadAd];
    }
}

- (void)orientationChanged
{
    if (CGSizeEqualToSize(self.currentSize, self.proportionalAdSize) || !self.shouldRespondToOrientationChanges) {
        return;
    }
    self.currentSize = self.proportionalAdSize;
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
    if (!self.isAdReady && !self.hidden) {
        self.imageView.image = nil;
        self.heightConstraint.constant = 0;
        self.hidden = YES;
        [self.delegate adViewNeedsToBeReloaded:self withExpectedSize:self.proportionalAdSize];
    } else if (self.isAdReady) {
        self.hidden = NO;
        self.imageView.image = self.bannerAd.image;
        self.heightConstraint.constant = self.proportionalAdSize.height;
        [self.delegate adViewNeedsToBeReloaded:self withExpectedSize:self.proportionalAdSize];
    }
}

#pragma mark - DLSponsoringBannerModuleDelegate

- (void)sposoringBannerModuleReceivedAd:(DLSponsoringBannerAd *)ad
{
    if (self.bannerAd && [self.bannerAd isEqual:ad]) {
        // Do nothing if ad is already displayed on screen or reload it if it has changed
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self displayAd:ad];
    });
}

@end
