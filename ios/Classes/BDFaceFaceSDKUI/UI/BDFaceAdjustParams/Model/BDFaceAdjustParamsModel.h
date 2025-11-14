//
//  BDFaceAdjustParamsModel.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/3.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceAdjustParams.h"
#import "BDFaceAdjustParamsConstants.h"

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceAdjustParamsModel : NSObject

/// 加载数据
+ (NSMutableArray *)loadItemsArray:(BDFaceAdjustParams *)config
                      recorverText:(NSString *)text
                        selectType:(BDFaceSelectType)type;

/// 根据类型，获取字符串
+ (NSString *)getSelectTypeString:(BDFaceSelectType)type;

@end

NS_ASSUME_NONNULL_END
