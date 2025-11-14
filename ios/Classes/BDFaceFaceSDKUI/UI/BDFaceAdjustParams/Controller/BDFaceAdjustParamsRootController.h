//
//  BDFaceAdjustParamsRootController.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
@class: BDFaceAdjustParamsRootController
@description  UITableViewDelegate协议方法需要子类实现，dataSource不需要子类实现
 */
@interface BDFaceAdjustParamsRootController : UIViewController <UITableViewDelegate>

@property(nonatomic, strong, readonly) UILabel *titleLabel;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *titleView;

#pragma mark 需要在子类ViewDidLoad里调用该方法
- (void)loadTableWithCellClass:(Class)cellClass
                    reuseLabel:(NSString *)reuseLabel
               dataSourceArray:(NSMutableArray *)array;

// controller 设置cell内容，第一次加载完成
- (void)updateCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath;

/// 定义表格样式，默认plain,子类可以覆盖
- (UITableViewStyle)customTableViewStyle;

/// 返回操作，子类需要覆盖
- (void)goBack;

@end

NS_ASSUME_NONNULL_END
