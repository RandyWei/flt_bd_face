//
//  UIColor+BDFaceColorUtils.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/5.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BDFaceColorUtils)

+ (UIColor *)face_colorWithRGBHex:(UInt32)hex;

@end

NS_ASSUME_NONNULL_END
