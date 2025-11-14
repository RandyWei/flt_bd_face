//
//  BDFaceAdjustParamsItem.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/3.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BDFaceAdjustParamsContentType) {
    BDFaceAdjustParamsContentTypeNormal = 0, // 可以修改的值
    BDFaceAdjustParamsContentTypeRecoverToNormal = 1 // 恢复默认一栏
};

typedef NS_ENUM(NSUInteger, BDFaceAdjustParamsItemType) {
    BDFaceAdjustParamsTypeMinLightIntensity = 1, /**<最小光照值  */
    BDFaceAdjustParamsTypeMaxLightIntensity = 2,/**<最大光照值  */
    BDFaceAdjustParamsTypeAmbiguity = 3,/**<模糊度  */
    
    BDFaceAdjustParamsTypeLeftEyeOcclusion = 4,/**<左眼遮挡阈值  */
    BDFaceAdjustParamsTypeRightEyeOcclusion = 5,/**< 右眼遮挡阈值 */
    BDFaceAdjustParamsTypeNoseOcclusion = 6,/**<鼻子遮挡阈值  */
    BDFaceAdjustParamsTypeMouthOcclusion = 7,/**<嘴巴遮挡阈值  */
    BDFaceAdjustParamsTypeLeftFaceOcclusion = 8,/**<左脸遮挡阈值  */
    BDFaceAdjustParamsTypeRightFaceOcclusion = 9,/**< 右脸遮挡阈值  */
    BDFaceAdjustParamsTypeLowerJawOcclusion = 10,/**<下巴遮挡阈值  */
    
    BDFaceAdjustParamsTypeUpAndDownAngle = 11,/**< 俯仰角 */
    BDFaceAdjustParamsTypeLeftAndRightAngle = 12,/**<  左右角*/
    BDFaceAdjustParamsTypeSpinAngle = 13/**<旋转角  */
};

@interface BDFaceAdjustParamsItem : NSObject

@property(nonatomic, copy) NSString *itemTitle;
@property(nonatomic, assign) float currentValue;
@property(nonatomic, assign) float maxValue;
@property(nonatomic, assign) float minValue;
@property(nonatomic, assign) float interval;
@property(nonatomic, assign) BDFaceAdjustParamsItemType configDetailType;
@property(nonatomic, assign) BDFaceAdjustParamsContentType contentType; /**<Item内容类型，0为默认，可以调的参数，1为恢复默认*/

@end

NS_ASSUME_NONNULL_END
