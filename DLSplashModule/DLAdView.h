//
//  DLAdView.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

/**
 Protocol of the DLAdViewDelegate.
 */
@protocol DLAdViewDelegate

/**
 Method is called when user taps on the DLAdView

 @param url NSURL to be displayed in webview.
 */
- (void)adViewDidTapImageWithUrl:(NSURL *)url;

@end

@interface DLAdView : UIView

@property (nonatomic, weak) id<DLAdViewDelegate> delegate;

@end
