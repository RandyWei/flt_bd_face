//
//  BDFaceToastAlertView.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/7.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceToastView : UIView

+ (void)showToast:(UIView *)superview text:(NSString *)text;

@end

NS_ASSUME_NONNULL_END
