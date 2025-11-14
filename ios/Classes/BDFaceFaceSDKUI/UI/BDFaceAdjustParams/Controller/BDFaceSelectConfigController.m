//
//  BDFaceSelectConfigController.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSelectConfigController.h"
#import "BDFaceSelectItem.h"
#import "BDFaceSelectConfigCell.h"
#import "BDFaceSelectRadio.h"
#import "BDFaceSelectItem.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceAdjustParamsConstants.h"
#import "BDFaceAdjustParamsController.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceSelectConfigModel.h"
#import "BDFaceAdjustParamsTool.h"

static NSString *const BDFaceSelectConfigControllerTitle = @"质量控制设置";
static float const BDFaceSelectConfigTableViewHeight = 24.0f;

static NSString *const BDFaceSelectConfigControllerTip1 = @"实名认证场景推荐使用[严格] 或 [正常]模式";
static NSString *const BDFaceSelectConfigControllerTip2 = @"人脸对比场景推荐使用[正常] 或 [宽松]模式";

@interface BDFaceSelectConfigController ()

@property(nonatomic, strong) NSMutableArray *allData;

@end

@implementation BDFaceSelectConfigController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allData = [BDFaceSelectConfigModel loadItems];
    [self loadTableWithCellClass:[BDFaceSelectConfigCell class] reuseLabel:NSStringFromClass([BDFaceSelectConfigCell class]) dataSourceArray:self.allData];
    
    CGRect tableRect = self.tableView.frame;
    tableRect.origin.x = BDFaceAdjustConfigTableMargin;
    tableRect.size.width = CGRectGetWidth(self.view.frame) - BDFaceAdjustConfigTableMargin * 2.0f;
    self.tableView.frame = tableRect;
    
    self.titleLabel.text = BDFaceSelectConfigControllerTitle;
}

- (void)viewWillAppear:(BOOL)animated {
    [self.tableView reloadData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    CGRect rect = CGRectMake(0, 0, CGRectGetWidth(self.view.frame) - BDFaceAdjustConfigTableMargin * 2.0f, BDFaceSelectConfigTableViewHeight * 3);
    UIView *view = [[UIView alloc] initWithFrame:rect];
    
    CGRect label1Rect = rect;
    label1Rect.origin.y = BDFaceSelectConfigTableViewHeight;
    label1Rect.size.height = BDFaceSelectConfigTableViewHeight;
    UILabel *label1 = [[UILabel alloc] initWithFrame:label1Rect];
    [view addSubview:label1];
    
    CGRect label2Rect = label1Rect;
    label2Rect.origin.y = CGRectGetMaxY(label1Rect);
    UILabel *label2 = [[UILabel alloc] initWithFrame:label2Rect];
    [view addSubview:label2];
    
    label1.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor];
    label2.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor];
    label1.text = BDFaceSelectConfigControllerTip1;
    label2.text = BDFaceSelectConfigControllerTip2;
    label1.font = [UIFont systemFontOfSize:14.0f];
    label2.font = [UIFont systemFontOfSize:14.0f];
    
    return view;
}

- (UITableViewStyle)customTableViewStyle {
    return UITableViewStyleGrouped;
}

- (void)updateCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    BDFaceSelectConfigCell *theCell;
    if ([cell isKindOfClass:[BDFaceSelectConfigCell class]]) {
        theCell = (BDFaceSelectConfigCell *)cell;
        if (indexPath.section == 0){
            if (indexPath.row == [BDFaceAdjustParamsFileManager sharedInstance].selectType) {
                [theCell.radio initRadioState:YES];
                [theCell showSettingButton:YES];
            } else {
                [theCell.radio initRadioState:NO];
                [theCell showSettingButton:NO];
            }
        }
    }
    __weak typeof(self) this = self;
    if (theCell) {
        theCell.adjustConfigAction = ^(BDFaceSelectType type) {
            BDFaceAdjustParamsController *adjustController = [[BDFaceAdjustParamsController alloc] initWithConfig:[[BDFaceAdjustParamsFileManager sharedInstance] configBySelection:type]];
            [this.navigationController pushViewController:adjustController animated:YES];
        };
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([cell isKindOfClass:[BDFaceSelectConfigCell class]]) {
        BDFaceSelectConfigCell *theCell = (BDFaceSelectConfigCell *)cell;
        [theCell.radio changeRadioState:YES];
        BDFaceSelectType typeChoosed = (BDFaceSelectType)indexPath.row;
        [BDFaceAdjustParamsFileManager sharedInstance].selectType = typeChoosed;
        BDFaceAdjustParams *params = [[BDFaceAdjustParamsFileManager sharedInstance] configBySelection:typeChoosed];
        [BDFaceAdjustParamsTool changeConfig:params];
    }
}

- (void)goBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
