//
//  BDFaceCalculateTool.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/2.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceCalculateTool : NSObject

+ (BOOL)noNullDic:(NSDictionary *)dic;

+ (CGFloat)safeTopMargin;

+ (CGFloat)safeBottomMargin;



@end

NS_ASSUME_NONNULL_END
