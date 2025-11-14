//
//  BDFaceAdjustParamsConstants.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 质量控制设置 页面的标题
extern NSString *const BDFaceAjustParamsPageTitle;
/// 正常参数配置 页面标题
extern NSString *const BDFaceAjustParamsNormalPageTitle;
/// 宽松参数配置 页面标题
extern NSString *const BDFaceAjustParamsLoosePageTitle;
/// 严格参数配置 页面标题
extern NSString *const BDFaceAjustParamsStrictPageTitle;

#pragma mark json keys
extern NSString *const minLightIntensityKey;// = @"minLightIntensity";  ///< 最小光照值Key
extern NSString *const maxLightIntensityKey; ///< 最大光照值Key
extern NSString *const ambiguityKey; ///< 模糊度Key

extern NSString *const leftEyeOcclusionKey; ///< 左眼遮挡阈值Key
extern NSString *const rightEyeOcclusionKey; ///< 右眼遮挡阈值Key
extern NSString *const noseOcclusionKey; ///< 鼻子遮挡阈值Key
extern NSString *const mouthOcclusionKey; ///< 嘴巴遮挡阈值Key
extern NSString *const leftFaceOcclusionKey; ///< 左脸遮挡阈值Key
extern NSString *const rightFaceOcclusionKey; ///< 右脸遮挡阈值Key
extern NSString *const lowerJawOcclusionKey; ///< 下巴遮挡阈值Key

extern NSString *const upAndDownAngleKey; ///< 俯仰角Key
extern NSString *const leftAndRightAngleKey; ///< 左右角Key
extern NSString *const spinAngleKey; ///< 旋转角Key

/// 目前用户选择的配置类型，宽松，自定义，严格，正常
typedef enum : NSUInteger {
    BDFaceSelectTypeLoose = 0,
    BDFaceSelectTypeNormal = 1,
    BDFaceSelectTypeStrict = 2,
    BDFaceSelectTypeCustom = 3
} BDFaceSelectType;

/// Cell 的位置枚举值，只有一个，非只有一个第一个，非只有一个中间的，非只有一个最后一个Cell
typedef enum : NSUInteger {
    BDFaceCellPostionTypeOnlyOneCell = 0,
    BDFaceCellPostionTypeMoreThanOneFirst = 1,
    BDFaceCellPostionTypeMoreThanOneMiddle = 2,
    BDFaceCellPostionTypeMoreThanOneLast = 3
} BDFaceCellPostionType;


extern float const BDFaceAdjustConfigTableCornerRadius;
extern float const BDFaceAdjustConfigTableMargin;

extern float const BDFaceAdjustConfigContentTitleFontSize;
extern float const BDFaceAdjustConfigControllerTitleFontSize;

extern UInt32 const BDFaceAdjustConfigTipTextColor;
extern UInt32 const BDFaceAdjustParamsSeperatorColor;
extern UInt32 const BDFaceAdjustParamsTableBackgroundColor;

///页面直接传递消息, 用户选择自定义了
extern NSString *const BDFaceAdjustParamsUserDidFinishSavedConfigNotification;

///BDFaceAdjustParamsController页面中传递消息
extern NSString *const BDFaceAdjustParamsControllerConfigDidChangeNotification; 
extern NSString *const BDFaceAdjustParamsControllerConfigIsSameKey;

extern UInt32 const BDFaceAdjustParamsRecoverActiveTextColor;
extern UInt32 const BDFaceAdjustParamsRecoverUnactiveTextColor;


/**
@class: BDFaceAdjustParamsConstants
@description 常量定义页面
 */
@interface BDFaceAdjustParamsConstants : NSObject

@end

NS_ASSUME_NONNULL_END
