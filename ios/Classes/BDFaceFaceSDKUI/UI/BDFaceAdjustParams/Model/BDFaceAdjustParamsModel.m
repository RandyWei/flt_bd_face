//
//  BDFaceAdjustParamsModel.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/3.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsModel.h"
#import "BDFaceAdjustParamsItem.h"

static NSString *const minLightIntensityString = @"最小光照值";
static NSString *const maxLightIntensityString = @"最大光照值";
static NSString *const ambiguityString = @"模糊度";

static NSString *const leftEyeOcclusionString = @"左眼";
static NSString *const rightEyeOcclusionString = @"右眼";
static NSString *const noseOcclusionString = @"鼻子";
static NSString *const mouthOcclusionString = @"嘴巴";
static NSString *const leftFaceOcclusionString = @"左脸颊";
static NSString *const rightFaceOcclusionString = @"右脸颊";
static NSString *const lowerJawOcclusionString = @"下巴";

static NSString *const upAndDownAngleString = @"俯仰角";
static NSString *const leftAndRightAngleString = @"左右角";
static NSString *const spinAngleString = @"旋转角";


static NSString *const BDFaceSelectTypeNormalString = @"正常";
static NSString *const BDFaceSelectTypeStrictString = @"严格";
static NSString *const BDFaceSelectTypeLooseString = @"宽松";
static NSString *const BDFaceSelectTypeCustomString = @"自定义";



@implementation BDFaceAdjustParamsModel

+ (NSMutableArray *)loadItemsArray:(BDFaceAdjustParams *)config
                      recorverText:(NSString *)text
                        selectType:(BDFaceSelectType)type {
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:[self lightArray:config]];
    [array addObject:[self occlusionArray:config]];
    [array addObject:[self positionArray:config]];
    if (type != BDFaceSelectTypeCustom) {
        [array addObject:[self recoverArray:text]];
    }
    
    return array;
}

/// 光照相关
+ (NSMutableArray *)lightArray:(BDFaceAdjustParams *)config {
    NSMutableArray *section1 = [NSMutableArray array];
    {
        /// 最小光照值
        BDFaceAdjustParamsItem *item = [[BDFaceAdjustParamsItem alloc] init];
        item.itemTitle = minLightIntensityString;
        item.minValue = 20.0f;
        item.maxValue = 60.0f;
        item.interval = 1.0f;
        item.currentValue = config.minLightIntensity;
        item.configDetailType = BDFaceAdjustParamsTypeMinLightIntensity;
        [section1 addObject:item];
    }
    {
        /// 最大光照值
        BDFaceAdjustParamsItem *item = [[BDFaceAdjustParamsItem alloc] init];
        item.itemTitle = maxLightIntensityString;
        item.minValue = 200.0f;
        item.maxValue = 240.0f;
        item.interval = 1.0f;
        item.currentValue = config.maxLightIntensity;
        item.configDetailType = BDFaceAdjustParamsTypeMaxLightIntensity;
        [section1 addObject:item];
    }
    {
        /// 模糊度
        BDFaceAdjustParamsItem *item = [[BDFaceAdjustParamsItem alloc] init];
        item.itemTitle = ambiguityString;
        item.minValue = 0.1f;
        item.maxValue = 0.9f;
        item.interval = 0.05f;
        item.currentValue = config.ambiguity;
        item.configDetailType = BDFaceAdjustParamsTypeAmbiguity;
        [section1 addObject:item];
    }
    return section1;
}

+ (NSMutableArray *)occlusionArray:(BDFaceAdjustParams *)config {
    NSMutableArray *section2 = [NSMutableArray array];
    {
        /// 左眼
        BDFaceAdjustParamsItem *item1 = [[BDFaceAdjustParamsItem alloc] init];
        item1.itemTitle = leftEyeOcclusionString;
        item1.currentValue = config.leftEyeOcclusion;
        item1.configDetailType = BDFaceAdjustParamsTypeLeftEyeOcclusion;
        [section2 addObject:item1];
    }
    
    {
        /// 右眼
        BDFaceAdjustParamsItem *item2 = [[BDFaceAdjustParamsItem alloc] init];
        item2.itemTitle = rightEyeOcclusionString;
        item2.currentValue = config.rightEyeOcclusion;
        item2.configDetailType = BDFaceAdjustParamsTypeRightEyeOcclusion;
        [section2 addObject:item2];
    }
    {
        /// 鼻子
        BDFaceAdjustParamsItem *item3 = [[BDFaceAdjustParamsItem alloc] init];
        item3.itemTitle = noseOcclusionString;
        item3.currentValue = config.noseOcclusion;
        item3.configDetailType = BDFaceAdjustParamsTypeNoseOcclusion;
        [section2 addObject:item3];
    }
    {
        /// 嘴巴
        BDFaceAdjustParamsItem *item4 = [[BDFaceAdjustParamsItem alloc] init];
        item4.itemTitle = mouthOcclusionString;
        item4.currentValue = config.mouthOcclusion;
        item4.configDetailType = BDFaceAdjustParamsTypeMouthOcclusion;
        [section2 addObject:item4];}
    {
        BDFaceAdjustParamsItem *item5 = [[BDFaceAdjustParamsItem alloc] init];
        item5.itemTitle = leftFaceOcclusionString;
        item5.currentValue = config.leftFaceOcclusion;
        item5.configDetailType = BDFaceAdjustParamsTypeLeftFaceOcclusion;
        [section2 addObject:item5];
    }
    {
        BDFaceAdjustParamsItem *item6 = [[BDFaceAdjustParamsItem alloc] init];
        item6.itemTitle = rightFaceOcclusionString;
        item6.currentValue = config.rightFaceOcclusion;
        item6.configDetailType = BDFaceAdjustParamsTypeRightFaceOcclusion;
        [section2 addObject:item6];
    }
    {
        BDFaceAdjustParamsItem *item7 = [[BDFaceAdjustParamsItem alloc] init];
        item7.itemTitle = lowerJawOcclusionString;
        item7.currentValue = config.lowerJawOcclusion;
        item7.configDetailType = BDFaceAdjustParamsTypeLowerJawOcclusion;
        [section2 addObject:item7];
    }
    /// 设置最大最小值和间隔
    for (BDFaceAdjustParamsItem *each in section2) {
        each.minValue = 0.3f;
        each.maxValue = 1.0f;
        each.interval = 0.05f;
    }
    return section2;
}


+ (NSMutableArray *)positionArray:(BDFaceAdjustParams *)config {
    NSMutableArray *section3 = [NSMutableArray array];
    {
        // 俯仰角
        BDFaceAdjustParamsItem *item1 = [[BDFaceAdjustParamsItem alloc] init];
        item1.itemTitle = upAndDownAngleString;
        item1.currentValue = config.upAndDownAngle;
        item1.configDetailType = BDFaceAdjustParamsTypeUpAndDownAngle;
        [section3 addObject:item1];
    }
    {
        /// 左右角
        BDFaceAdjustParamsItem *item2 = [[BDFaceAdjustParamsItem alloc] init];
        item2.itemTitle = leftAndRightAngleString;
        item2.currentValue = config.leftAndRightAngle;
        item2.configDetailType = BDFaceAdjustParamsTypeLeftAndRightAngle;
        [section3 addObject:item2];
        
    }
    {
        /// 旋转角
        BDFaceAdjustParamsItem *item3 = [[BDFaceAdjustParamsItem alloc] init];
        item3.itemTitle = spinAngleString;
        item3.currentValue = config.spinAngle;
        item3.configDetailType = BDFaceAdjustParamsTypeSpinAngle;
        [section3 addObject:item3];
    }
    for (BDFaceAdjustParamsItem *each in section3) {
        each.minValue = 10.0f;
        each.maxValue = 50.0f;
        each.interval = 1.0f;
    }
    return section3;
}

+ (NSMutableArray *)recoverArray:(NSString *)text {
    NSMutableArray *section = [NSMutableArray array];
    BDFaceAdjustParamsItem *item = [[BDFaceAdjustParamsItem alloc] init];
    item.itemTitle = text;
    item.contentType = BDFaceAdjustParamsContentTypeRecoverToNormal;
    [section addObject:item];
    
    return section;
}

//+ (BDFaceAdjustParams *)getConfig:(NSArray *)array {
//    BDFaceAdjustParams *config = [BDFaceAdjustParams new];
//    for (NSArray *subArray in array) {
//        if (subArray && [subArray isKindOfClass:[NSArray class]]) {
//            for (BDFaceAdjustParamsItem *item in subArray) {
//                switch (item.configDetailType) {
//                    /// 光照
//                    case BDFaceAdjustParamsTypeMinLightIntensity:
//                    {
//                        config.minLightIntensity = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeMaxLightIntensity:
//                    {
//                        config.maxLightIntensity = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeAmbiguity:
//                    {
//                        config.ambiguity = item.currentValue;
//                    }
//                        break;
//                    /// 遮挡
//                    case BDFaceAdjustParamsTypeLeftEyeOcclusion:
//                    {
//                        config.leftEyeOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeRightEyeOcclusion:
//                    {
//                        config.rightFaceOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeNoseOcclusion:
//                    {
//                        config.noseOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeMouthOcclusion:
//                    {
//                        config.mouthOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeLeftFaceOcclusion:
//                    {
//                        config.leftFaceOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeRightFaceOcclusion:
//                    {
//                        config.rightFaceOcclusion = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeLowerJawOcclusion:
//                    {
//                        config.lowerJawOcclusion = item.currentValue;
//                    }
//                        break;
//                    /// 姿势
//                    case BDFaceAdjustParamsTypeUpAndDownAngle:
//                    {
//                        config.upAndDownAngle = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeLeftAndRightAngle:
//                    {
//                        config.leftAndRightAngle = item.currentValue;
//                    }
//                        break;
//                    case BDFaceAdjustParamsTypeSpinAngle:
//                    {
//                        config.spinAngle = item.currentValue;
//                    }
//                        break;
//                    default:
//                        break;
//                }
//            }
//        }
//    }
//    return config;
//}

+ (NSString *)getSelectTypeString:(BDFaceSelectType)type {
    NSString *value = BDFaceSelectTypeNormalString;
    switch (type) {
        case BDFaceSelectTypeStrict:
        {
            value = BDFaceSelectTypeStrictString;
        }
            break;
        case BDFaceSelectTypeLoose:
        {
            value = BDFaceSelectTypeLooseString;
        }
            break;
        case BDFaceSelectTypeCustom:
        {
            value = BDFaceSelectTypeCustomString;
        }
            break;
        default:
            break;
    }
    return value;
}

@end
