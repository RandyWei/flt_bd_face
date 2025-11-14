//
//  BDFaceSelectRadio.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/2.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSelectRadio.h"

static NSMutableArray *radioGroup;
static NSString *const BDFaceSelectRadioSelectedImage = @"set_config_selected";
static NSString *const BDFaceSelectRadioUnselectedImage = @"set_config_unselected";

@interface BDFaceSelectRadio()

@property(nonatomic, assign) BOOL radioState;

@end



@implementation BDFaceSelectRadio

+ (instancetype)buttonWithType:(UIButtonType)buttonType selected:(BOOL)selected {
    BDFaceSelectRadio *button = [BDFaceSelectRadio buttonWithType:buttonType];
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        radioGroup = [NSMutableArray array];
    });
    [button initRadioState:selected];
    button.userInteractionEnabled = NO;
    [radioGroup addObject:button];
    return button;
}


/// 初始化时改变状态
- (void)initRadioState:(BOOL)state {
    self.radioState = state;
}

/// 点击的时候改变状态，只有未选择才改变
- (void)changeRadioState:(BOOL)state {
    if (self.radioState == NO
        && state == YES) {
        NSInteger index = 0;
        for (int i = 0; i < radioGroup.count; i++) {
            BDFaceSelectRadio *each = radioGroup[i];
            if (each != self) {
                // 其他按钮选择为未选择,自身为true
                each.radioState = NO;
                if (each.radioTaped) {
                    each.radioTaped(index, NO);
                }
            } else {
                // 选择了这个
                index = i;
                each.radioState = YES;
                if (each.radioTaped) {
                    each.radioTaped(index, TRUE);
                }
            }
        }
    }
}

- (void)setRadioState:(BOOL)radioState {
    _radioState = radioState;
    if (radioState) {
        [self setImage:[UIImage imageNamed:BDFaceSelectRadioSelectedImage] forState:UIControlStateNormal];
    } else {
        [self setImage:[UIImage imageNamed:BDFaceSelectRadioUnselectedImage] forState:UIControlStateNormal];
    }
}

- (void)dealloc {
    if ([radioGroup containsObject:self]) {
        [radioGroup removeObject:self];
    }
}



@end

