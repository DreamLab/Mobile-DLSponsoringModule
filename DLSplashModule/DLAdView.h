//
//  DLAdView.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdViewDelegate.h"

@import UIKit;
@import Foundation;

@interface DLAdView : UIView

@property (nonatomic, weak) id<DLAdViewDelegate> delegate;

@end
