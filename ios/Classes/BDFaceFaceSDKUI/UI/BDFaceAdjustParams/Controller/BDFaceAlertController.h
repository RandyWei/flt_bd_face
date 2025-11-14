//
//  BDFaceAlertViewController.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/7.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
@class:BDFaceAlertController
@description: 自定义AlertController，实现了右边是Bold字体的样式。
 */
@interface BDFaceAlertController : UIAlertController

- (void)changeTextToBold:(NSString *)string;
- (void)changeTextToLight:(NSArray *)array;

@end

NS_ASSUME_NONNULL_END
