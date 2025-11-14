//
//  BDFaceAdjustParamsFileManager.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceAdjustParamsConstants.h"
@class BDFaceAdjustParams;

NS_ASSUME_NONNULL_BEGIN

/**
@class: BDFaceAdjustParamsFileManager
@description数据管理类
 */
@interface BDFaceAdjustParamsFileManager : NSObject

@property(nonatomic, strong, readonly) BDFaceAdjustParams *normalConfig; /**<正常参数配置*/
@property(nonatomic, strong, readonly) BDFaceAdjustParams *looseConfig; /**<宽松参数配置*/
@property(nonatomic, strong, readonly) BDFaceAdjustParams *strictConfig; /**<严格参数配置*/

@property(nonatomic, strong, readonly) BDFaceAdjustParams *customConfig; /**<自定义配置*/
@property(nonatomic, assign) BDFaceSelectType selectType;

+ (instancetype)sharedInstance;

/// 读取自定义配置
- (BDFaceAdjustParams *)readCustomCongfig;

/// 储存自定义配置
- (void)saveToCustomConfigFile:(BDFaceAdjustParams *)config;

/// 读取缓存的选择
+ (BDFaceSelectType)readCacheSelect;

/// 保存用户的选择
- (void)saveUserSelection:(BDFaceSelectType)select;

/// 跟进select 选择config
- (BDFaceAdjustParams *)configBySelection:(BDFaceSelectType)type;

+ (NSString *)currentSelectionText;



@end

NS_ASSUME_NONNULL_END
