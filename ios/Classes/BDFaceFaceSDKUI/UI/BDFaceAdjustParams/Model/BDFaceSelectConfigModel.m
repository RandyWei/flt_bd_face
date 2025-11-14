//
//  BDFaceSelectConfigModel.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/7.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSelectConfigModel.h"
#import "BDFaceSelectItem.h"
#import "BDFaceAdjustParamsConstants.h"
#import "BDFaceAdjustParamsFileManager.h"

@implementation BDFaceSelectConfigModel

+ (NSMutableArray *)loadItems {
    NSMutableArray *array = [NSMutableArray array];
    {
        BDFaceSelectItem *itemLoose = [BDFaceSelectItem new];
        itemLoose.itemTitle = @"宽松";
        itemLoose.itemType = BDFaceSelectTypeLoose;
        itemLoose.adjustParams = [BDFaceAdjustParamsFileManager sharedInstance].looseConfig;
        [array addObject:itemLoose];
    }
    {
        BDFaceSelectItem *itemNormal = [BDFaceSelectItem new];
        itemNormal.itemTitle = @"正常";
        itemNormal.itemType = BDFaceSelectTypeNormal;
        itemNormal.adjustParams = [BDFaceAdjustParamsFileManager sharedInstance].normalConfig;
        [array addObject:itemNormal];
    }
    {
        BDFaceSelectItem *itemStrict = [BDFaceSelectItem new];
        itemStrict.itemTitle = @"严格";
        itemStrict.itemType = BDFaceSelectTypeStrict;
        itemStrict.adjustParams = [BDFaceAdjustParamsFileManager sharedInstance].strictConfig;
        [array addObject:itemStrict];
    }
    {
        BDFaceSelectItem *itemCustom = [BDFaceSelectItem new];
        itemCustom.itemTitle = @"自定义";
        itemCustom.itemType = BDFaceSelectTypeCustom;
        
        itemCustom.adjustParams = [[BDFaceAdjustParamsFileManager sharedInstance] readCustomCongfig];
        [array addObject:itemCustom];
    }
    NSMutableArray *value = [NSMutableArray array];
    [value addObject:array];
    return value;
}

@end
