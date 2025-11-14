//
//  BDFaceAdjustParamsController.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsRootController.h"
#import "BDFaceAdjustParamsConstants.h"
@class BDFaceAdjustParams;


NS_ASSUME_NONNULL_BEGIN

/**
 @class: BDFaceAdjustParamsController
 @description  调节参数页面
 */
@interface BDFaceAdjustParamsController : BDFaceAdjustParamsRootController

- (instancetype)initWithConfig:(BDFaceAdjustParams *)config;

@end

NS_ASSUME_NONNULL_END
