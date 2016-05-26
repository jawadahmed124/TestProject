//
//  MaskImage.h
//  Test
//
//  Created by Jawad Ahmad on 25/05/2016.
//  Copyright © 2016 Jawad Ahmad. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MaskImage : NSObject

+ (UIImage *)getMaskImage;
+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage;

@end
