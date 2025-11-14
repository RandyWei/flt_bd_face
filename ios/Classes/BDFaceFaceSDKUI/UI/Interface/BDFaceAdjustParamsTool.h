//
//  BDFaceAdjustParamsTool.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/8.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceAdjustParams.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceAdjustParamsTool : NSObject

/// 设置默认config
+ (void)setDefaultConfig;

/// 改变config配置
+ (void)changeConfig:(BDFaceAdjustParams *)params;

@end

NS_ASSUME_NONNULL_END
