//
//  UIColor+BDFaceColorUtils.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/5.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "UIColor+BDFaceColorUtils.h"

@implementation UIColor (BDFaceColorUtils)

+ (UIColor *)face_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}


@end
