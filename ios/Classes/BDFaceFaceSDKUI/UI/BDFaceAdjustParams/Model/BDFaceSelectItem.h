//
//  BDFaceSelectItem.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/2.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BDFaceAdjustParams.h"
#import "BDFaceAdjustParamsConstants.h"

NS_ASSUME_NONNULL_BEGIN


@interface BDFaceSelectItem : NSObject

@property(nonatomic, copy) NSString *itemTitle;
@property(nonatomic, assign) BDFaceSelectType itemType;
@property(nonatomic, strong) BDFaceAdjustParams *adjustParams;

@end

NS_ASSUME_NONNULL_END
