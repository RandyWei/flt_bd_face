//
//  BDFaceAdjustParamsRootCell.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceAdjustParamsRootCell : UITableViewCell

@property(nonatomic, strong) NSObject *data;
@property(nonatomic, copy) NSIndexPath *indexPath;


// 设置cell 视图，这里data已不为空，可以使用,必须重写
- (void)cellFinishLoad:(NSInteger)rowsInSection;

+ (CGFloat)HeightOfFaceAdjustCell;

// 分割线颜色
+ (UIColor *)seperatorColor;

/// layoutsubview 方法中才能使用
- (void)setConerRadius:(float)cornerRadius
           borderWidth:(CGFloat)borderWidth
           borderColor:(nullable CGColorRef)borderColor;


@end

NS_ASSUME_NONNULL_END
