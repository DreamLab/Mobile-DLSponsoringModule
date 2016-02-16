//
//  DLSplashModule.h
//  DLSplashModule
//
//  Created by Jacek Zapart on 12.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLSplashModule : NSObject

/**
 Initializes module with the app site parameter. It initialize the shared instance. Should be called before first use.

 @param identifier the identifier of the ad
 
 @return Instance of initialized DLSplashModule
 */
+ (instancetype)initializeWithIdentifier:(NSString *)identifier;

/**
 Returns the singleton instance of the DLSplashModule class. 
 Method initializeWithIdentifier: should be called before first use, otherwise sharedInstance will be nil.

 @return Instance of DLSplashModule or nil if not initialized
 */
+ (instancetype)sharedInstance;

@end
