//
//  BDFaceAdjustParamsRootController.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsRootController.h"
#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceCalculateTool.h"
#import "BDFaceAdjustParamsConstants.h"
#import "UIColor+BDFaceColorUtils.h"

static float const BDFaceAdjustParamsNavigationBarHeight = 44.0f;

static float const BDFaceAdjustParamsNavigationBarTitleLabelOriginX = 80.0f;
static float const BDFaceAdjustParamsNavigationBarBackButtonWidth = 60.0f;
@interface BDFaceAdjustParamsRootController ()<UITableViewDataSource>

@property(nonatomic, strong) NSMutableArray *dataSourceArray; /**<必须是@[array, array[]的格式*/

@property(nonatomic, copy) NSString *reuseLabel;
@property(nonatomic, copy) NSString *cellClassString;
@property(nonatomic, strong) UIView *titleSeperator;

@property(nonatomic, strong) UIButton *goBackButton;

@end

@implementation BDFaceAdjustParamsRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self loadTitleView];
    CGRect tableViewRect = CGRectMake(0, CGRectGetMaxY(self.titleView.frame), [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - [BDFaceCalculateTool safeTopMargin] - BDFaceAdjustParamsNavigationBarHeight);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewRect style:[self customTableViewStyle]];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsTableBackgroundColor];
    self.tableView.backgroundColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsTableBackgroundColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.titleLabel.textColor = [UIColor blackColor];
}

- (UITableViewStyle)customTableViewStyle {
    return UITableViewStylePlain;
}

- (void)loadTitleView {
    CGFloat originY = [BDFaceCalculateTool safeTopMargin];
    if (originY == 0) {
        originY = 20.0f;
    }
    CGRect titleRect = CGRectMake(0, originY, [UIScreen mainScreen].bounds.size.width, BDFaceAdjustParamsNavigationBarHeight);
    self.titleView = [[UIView alloc] initWithFrame:titleRect];
    [self.view addSubview:self.titleView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(BDFaceAdjustParamsNavigationBarTitleLabelOriginX, 0, [UIScreen mainScreen].bounds.size.width - BDFaceAdjustParamsNavigationBarTitleLabelOriginX * 2.0, BDFaceAdjustParamsNavigationBarHeight)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:_titleLabel];
    _titleLabel.font = [UIFont boldSystemFontOfSize:BDFaceAdjustConfigControllerTitleFontSize];
    CGFloat titleSeperatorHeight = 1.0f / [UIScreen mainScreen].scale;
    self.titleSeperator = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame) - titleSeperatorHeight, [UIScreen mainScreen].bounds.size.width, titleSeperatorHeight)];
    [self.titleView addSubview:self.titleSeperator];
    self.titleSeperator.backgroundColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsSeperatorColor];
    
    self.goBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.goBackButton.frame = CGRectMake(0, 0, BDFaceAdjustParamsNavigationBarBackButtonWidth, CGRectGetHeight(self.titleView.frame));
    [self.titleView addSubview:self.goBackButton];
    [self.goBackButton addTarget:self action:@selector(goBack) forControlEvents:UIControlEventTouchUpInside];
    [self.goBackButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    [self.goBackButton setImage:[UIImage imageNamed:@"icon_titlebar_back_p"] forState:UIControlStateHighlighted];
    self.goBackButton.imageView.contentMode = UIViewContentModeCenter;
    
}

- (void)loadTableWithCellClass:(Class)cellClass
                    reuseLabel:(NSString *)reuseLabel
               dataSourceArray:(NSMutableArray *)array {
    [self.tableView registerClass:cellClass forCellReuseIdentifier:reuseLabel];
    self.reuseLabel = reuseLabel;
    self.cellClassString = NSStringFromClass(cellClass);
    self.dataSourceArray = array;
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.dataSourceArray
        || self.dataSourceArray.count == 0) {
        return 0;
    }
    if (section < self.dataSourceArray.count) {
        NSArray *array = self.dataSourceArray[section];
        if (array
            && [array isKindOfClass:[NSArray class]]) {
            return array.count;
        } else {
            return 0;
        }
    } else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsRootCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseLabel];
    if (indexPath.section < self.dataSourceArray.count) {
        NSArray *array = self.dataSourceArray[indexPath.section];
        if (indexPath.row < array.count) {
            cell.data = array[indexPath.row];
            cell.indexPath = indexPath;
            [cell cellFinishLoad:array.count];
            [self updateCellContent:cell indexPath:indexPath];
        }
    }
    return cell;
}

- (void)updateCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    // do nothing
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsRootCell *cell = [tableView dequeueReusableCellWithIdentifier:self.reuseLabel];
    return [cell.class HeightOfFaceAdjustCell];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSourceArray.count;
}

- (void)goBack {
    
}


@end
