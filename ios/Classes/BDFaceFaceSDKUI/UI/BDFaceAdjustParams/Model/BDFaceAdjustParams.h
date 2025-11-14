//
//  BDFaceAdjustParams.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface BDFaceAdjustParams : NSObject<NSCopying>

@property(nonatomic, assign) NSInteger minLightIntensity; ///< 最小光照值
@property(nonatomic, assign) NSInteger maxLightIntensity; ///< 最大光照值
@property(nonatomic, assign) float ambiguity; ///< 模糊度

#pragma mark 遮挡阈值
@property(nonatomic, assign) float leftEyeOcclusion; ///< 左眼遮挡阈值
@property(nonatomic, assign) float rightEyeOcclusion; ///< 右眼遮挡阈值
@property(nonatomic, assign) float noseOcclusion; ///< 鼻子遮挡阈值
@property(nonatomic, assign) float mouthOcclusion; ///< 嘴巴遮挡阈值
@property(nonatomic, assign) float leftFaceOcclusion; ///< 左脸遮挡阈值
@property(nonatomic, assign) float rightFaceOcclusion; ///< 右脸遮挡阈值
@property(nonatomic, assign) float lowerJawOcclusion; ///< 下巴遮挡阈值

#pragma mark 姿态阈值
@property(nonatomic, assign) NSInteger upAndDownAngle; ///< 俯仰角
@property(nonatomic, assign) NSInteger leftAndRightAngle; ///< 左右角
@property(nonatomic, assign) NSInteger spinAngle; ///< 旋转角


/**
 *Description 初始化方法
 *@params json jsonString
 */
- (instancetype)initWithJson:(NSString *)json;

/**
 *Description 初始化方法
 *@params dic dic对象
 */
- (instancetype)initWithDic:(NSDictionary *)dic;

/**
 *Description 转为dictionary
 */
- (NSDictionary *)toDic;

/**
 *Description 对比两个参数obj是否是一个
 *@params obj 另外一个BDFaceAdjustParams
 *@return 对比另外一个obj,如果是一样的参数，返回YES，否则返回NO，如果obj为空，返回NO
 */
- (BOOL)compareToParams:(BDFaceAdjustParams *)obj;


- (NSString *)description;

@end

NS_ASSUME_NONNULL_END
