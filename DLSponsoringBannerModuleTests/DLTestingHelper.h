//
//  DLTestingHelper.h
//  DLSponsoringBannerModule
//
//  Created by Konrad Kierys on 15.02.2016.
//  Copyright © 2016 DreamLab. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Helper for Unit Tests
 */
@interface DLTestingHelper : NSObject

/**
 *  Reads content of file in unit test bundle
 *
 *  @param fileName Name of the file
 *
 *  @return Content of the file as NSData
 */
+ (NSData *)dataFromJSONFileNamed:(NSString *)fileName;

@end
