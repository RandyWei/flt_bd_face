//
//  BDFaceToastView.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/7.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceToastView.h"

@implementation BDFaceToastView

+ (void)showToast:(UIView *)superview text:(NSString *)text {
    CGFloat marginTotal = 90.0f;
    CGFloat textSize = 15.0f;
    UIColor *bgColor = [UIColor blackColor];
    CGFloat alpha = 0.8f;
    NSTimeInterval delayTime = 2;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(superview.frame) - marginTotal, 0)];
    label.font = [UIFont systemFontOfSize:textSize];
    label.text = text;
    label.numberOfLines = 0;
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    [label sizeToFit];
    [label setNeedsLayout];
    CGRect labelRect = label.frame;
    labelRect.origin.x = textSize;
    labelRect.origin.y = textSize;
    label.frame = labelRect;
    CGRect bgRect = label.bounds;
    bgRect.size.width = bgRect.size.width + textSize * 2;
    bgRect.size.height = bgRect.size.height + textSize * 2;
    bgRect.origin.x = (CGRectGetWidth(superview.frame) - CGRectGetWidth(bgRect)) / 2.0f;
    bgRect.origin.y = (CGRectGetHeight(superview.frame) - CGRectGetHeight(bgRect)) / 2.0f;
    UIView *bgView = [[UIView alloc]initWithFrame:bgRect];
    
    UIView *contentBgView = [[UIView alloc] initWithFrame:bgView.bounds];
    [bgView addSubview:contentBgView];
    contentBgView.backgroundColor = bgColor;
    contentBgView.alpha = alpha;
    [bgView addSubview:label];
    bgView.layer.cornerRadius = CGRectGetHeight(bgView.frame) / 2.0f;
    bgView.clipsToBounds = YES;
    [superview addSubview:bgView];
    
    [self performSelector:@selector(removeMe:) withObject:bgView afterDelay:delayTime];
}

+ (void)removeMe:(UIView *)view {
    if (view) {
        [view removeFromSuperview];
        view = nil;
    }
}

@end
