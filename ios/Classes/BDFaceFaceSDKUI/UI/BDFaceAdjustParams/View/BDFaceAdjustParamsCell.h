//
//  BDFaceAdjustParamsCell.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceAdjustParamsItem.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^BDFaceAdjustParamsCellDidChangedValue)(BDFaceAdjustParamsItemType, float);

@interface BDFaceAdjustParamsCell : BDFaceAdjustParamsRootCell

@property(nonatomic, copy) BDFaceAdjustParamsCellDidChangedValue didFinishAdjustParams;
@property(nonatomic, assign) BOOL isSameConfig;

@end

NS_ASSUME_NONNULL_END
