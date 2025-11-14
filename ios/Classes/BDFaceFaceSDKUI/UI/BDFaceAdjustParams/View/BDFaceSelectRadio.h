//
//  BDFaceSelectRadio.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/2.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^BDFaceSelectRadioState)(NSInteger index, BOOL selected);

@interface BDFaceSelectRadio : UIButton

@property(nonatomic, copy) BDFaceSelectRadioState radioTaped;

/// 指定初始化方法
+ (instancetype)buttonWithType:(UIButtonType)buttonType selected:(BOOL)selected;

// 改变按钮状态
- (void)changeRadioState:(BOOL)state;

// 初始化按钮状态
- (void)initRadioState:(BOOL)state;

@end




NS_ASSUME_NONNULL_END
