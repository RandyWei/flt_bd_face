//
//  BDFaceSelectConfigCell.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceSelectRadio.h"
#import "BDFaceSelectItem.h"
#import "BDFaceAdjustParams.h"

NS_ASSUME_NONNULL_BEGIN


typedef void(^BDFaceUserWillAdjustParams)(BDFaceSelectType);

extern float const BDFaceSelectConfigCellHeight;

@interface BDFaceSelectConfigCell : BDFaceAdjustParamsRootCell

@property(nonatomic, strong) BDFaceSelectRadio *radio;
@property(nonatomic, copy) BDFaceUserWillAdjustParams adjustConfigAction;

- (void)showSettingButton:(BOOL)show;

@end

NS_ASSUME_NONNULL_END
