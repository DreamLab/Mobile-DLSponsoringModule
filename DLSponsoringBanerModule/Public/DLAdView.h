//
//  DLAdView.h
//  DLSponsoringBanerModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import "DLAdViewDelegate.h"

@import UIKit;
@import Foundation;

/**
View to display the image of the ad.
 */
@interface DLAdView : UIView 

/**
 Property for reading text associated with currently displayed ad.
 */
@property (nonatomic, readonly) NSString *associatedText;

/**
 Delegate of the DLAdViewDelegate protocol.
 */
@property (nonatomic, weak) id<DLAdViewDelegate> delegate;

@end
