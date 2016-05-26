//
//  MaskImage.m
//  Test
//
//  Created by Jawad Ahmad on 25/05/2016.
//  Copyright © 2016 Jawad Ahmad. All rights reserved.
//

#import "MaskImage.h"

@implementation MaskImage

+ (UIImage *)getMaskImage {
    static UIImage *maskImage;
    
    @synchronized (self) {
        if (maskImage == nil) {
            UIImage *originalMask = [UIImage imageNamed:@"image_frame_arc"];
            CGImageRef customMaskRef = [self customizeMaskImage:originalMask.CGImage];
            maskImage = [UIImage imageWithCGImage:customMaskRef];
        }
    }
    
    return maskImage;
}

+ (CGImageRef)customizeMaskImage:(CGImageRef)imgRef  {
    
    CGFloat w = CGImageGetWidth(imgRef);
    CGFloat h = CGImageGetHeight(imgRef);
    
    unsigned char *rawData = (unsigned char*) calloc(h * w * 4, sizeof(unsigned char));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    CGBitmapInfo bitMapInfo = CGImageGetBitmapInfo(imgRef);
    CGContextRef context = CGBitmapContextCreate(rawData, w, h, 8, w * 4, colorSpace, bitMapInfo);
    CGContextSetInterpolationQuality(context, kCGInterpolationLow);
    CGContextSetShouldAntialias(context, false);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), imgRef);
    
    
    int byteIndex = 0;
    
    unsigned char *newRawData = malloc(w *h * 4);
    
    float thresh = 1.0;
    
    int j = 0;
    while (j < (w * h)) {
        byteIndex = j * 4;
        
        newRawData[byteIndex] = 255.0;     // R
        newRawData[byteIndex + 1] = 255.0; // G
        newRawData[byteIndex + 2] = 255.0; // B
        newRawData[byteIndex + 3] = 1.0;   // A
        
        if (rawData[byteIndex + 3] <= thresh) {
            j++;
        }
        else {
            j = (j + (int)w) - ( j % (int)w);
        }
    }
    
    int i = (w * h) - 1;
    while (i >= 0) {
        byteIndex = i * 4;
        
        newRawData[byteIndex] = 255.0;     // R
        newRawData[byteIndex + 1] = 255.0; // G
        newRawData[byteIndex + 2] = 255.0; // B
        newRawData[byteIndex + 3] = 1.0;   // A
        
        if (rawData[byteIndex + 3] <= thresh) {
            i--;
        }
        else {
            int intW = (int)w;
            i = (i-intW) + (intW-1) - (i%intW);
        }
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithData(NULL, newRawData, (w * h * 4), NULL);
    
    CGImageRef newRef = CGImageMaskCreate(CGImageGetWidth(imgRef),
                                          CGImageGetHeight(imgRef),
                                          CGImageGetBitsPerComponent(imgRef),
                                          CGImageGetBitsPerPixel(imgRef),
                                          CGImageGetBytesPerRow(imgRef),
                                          provider, NULL, false);
    free(rawData);
    free(newRawData);
    
    return newRef;
}

+ (UIImage *)maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    CGImageRef mask = maskImage.CGImage;
    CGImageRef maskedImageRef = CGImageCreateWithMask([image CGImage], mask);
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedImageRef];
    
//    CGImageRelease(mask);
    CGImageRelease(maskedImageRef);
    
    // returns new image with mask applied
    return maskedImage;
}

@end
