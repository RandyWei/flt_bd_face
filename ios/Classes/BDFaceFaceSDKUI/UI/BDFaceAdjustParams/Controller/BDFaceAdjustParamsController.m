//
//  BDFaceAdjustParamsController.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsController.h"
#import "BDFaceAdjustParamsCell.h"
#import "BDFaceAdjustParamsItem.h"
#import "BDFaceAdjustParamsModel.h"
#import "BDFaceAdjustParams.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceAdjustParamsConstants.h"
#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceAlertController.h"
#import "BDFaceAdjustParamsTool.h"

static NSString *const BDFaceAdjustParamsControllerTitle = @"%@参数配置";
static NSString *const BDFaceAdjustParamsRecoverText = @"恢复为%@参数配置";

static float const BDFaceAdjustParamsSaveButtonWidth = 80.0f;
static float const BDFaceAdjustParamsSaveButtonHeight = 40.0f;
static float const BDFaceAdjustParamsSaveButtonRightMargin = 10.0f;
static NSString *const BDFaceAdjustParamsSaveButtonText = @"保存";

static NSString *const BDFaceAdjustParamsAlertTitle = @"是否保存修改";
static NSString *const BDFaceAdjustParamsAlertContent = @"参数配置已修改，是否保存后离开";
static NSString *const BDFaceAdjustParamsAlertJustLeave = @"直接离开";
static NSString *const BDFaceAdjustParamsAlertSaveAndLeave = @"保存并离开";
static NSString *const BDFaceAdjustParamsAlertCancel = @"取消";
static NSString *const BDFaceAdjustParamsAlertSaveCustomConfig = @"保存自定义";

static NSString *const BDFaceAdjustParamsAlertRecoverToDefaultTip = @"参数配置已修改，是否恢复默认";
static NSString *const BDFaceAdjustParamsAlertRecoverToDefault = @"恢复默认";

static float const BBDFaceAjustConfigTableViewOriginY = 10.0f;
static float const BDFaceSelectConfigTableMargin = 20.0f;
static float const BDFaceSelectConfigTableViewHeight = 24.0f;
static NSString *const BDFaceAdjustParamsSection1Tip = @"数值越小越严格";
static NSString *const BDFaceAdjustParamsSection2Tip = @"姿态阀值（绝对值，单位：度）";
@interface BDFaceAdjustParamsController ()

@property(nonatomic, strong) BDFaceAdjustParams *configInital;
@property(nonatomic, strong) BDFaceAdjustParams *currentConfig;
@property(nonatomic, strong) NSMutableArray *allData;
@property(nonatomic, assign) BDFaceSelectType selectType;
@property(nonatomic, assign) BDFaceSelectType initialSelect;

@property(nonatomic, strong) UIButton *saveButton;

@property(nonatomic, copy) NSString *selectTypeString;
@property(nonatomic, copy) NSString *recoverText;

@property(nonatomic, assign) BOOL isSameConfig;

@property(nonatomic, weak) BDFaceAdjustParamsCell *recoverCell;

@end

@implementation BDFaceAdjustParamsController

- (instancetype)initWithConfig:(BDFaceAdjustParams *)config {
    self = [super init];
    if (self) {
        self.configInital = [config copy];
        self.currentConfig = [config copy];
        self.selectType = [BDFaceAdjustParamsFileManager sharedInstance].selectType;
        self.initialSelect = self.selectType;
        self.selectTypeString = [BDFaceAdjustParamsModel getSelectTypeString:self.selectType];
        self.recoverText = [NSString stringWithFormat:BDFaceAdjustParamsRecoverText, self.selectTypeString];
        self.isSameConfig = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.allData = [BDFaceAdjustParamsModel loadItemsArray:self.currentConfig recorverText:self.recoverText selectType:self.selectType];
    [self loadTableWithCellClass:[BDFaceAdjustParamsCell class] reuseLabel:NSStringFromClass([BDFaceAdjustParamsCell class]) dataSourceArray:self.allData];
    
    CGRect tableRect = self.tableView.frame;
    tableRect.origin.x = BDFaceAdjustConfigTableMargin;
    tableRect.size.width = CGRectGetWidth(self.view.frame) - BDFaceAdjustConfigTableMargin * 2.0f;
    self.tableView.frame = tableRect;
    self.tableView.showsVerticalScrollIndicator = NO;
    self.titleLabel.text = [NSString stringWithFormat:BDFaceAdjustParamsControllerTitle, self.selectTypeString];
    [self loadSaveButton];
}

- (void)loadSaveButton {
    self.saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.saveButton.frame = CGRectMake(CGRectGetWidth(self.titleView.frame) - BDFaceAdjustParamsSaveButtonRightMargin - BDFaceAdjustParamsSaveButtonWidth, (CGRectGetHeight(self.titleView.frame) - BDFaceAdjustParamsSaveButtonHeight) / 2.0f, BDFaceAdjustParamsSaveButtonWidth, BDFaceAdjustParamsSaveButtonHeight);
    [self.titleView addSubview:self.saveButton];
    [self.saveButton setTitle:BDFaceAdjustParamsSaveButtonText forState:UIControlStateNormal];
    [self updateSaveButtonTextColor];
    [self.saveButton addTarget:self action:@selector(userClickSave) forControlEvents:UIControlEventTouchUpInside];
}

/// 用户点击保存按钮
- (void)userClickSave {
    if (self.isSameConfig) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        __weak typeof(self) this = self;
        BDFaceAlertController *alert = [BDFaceAlertController alertControllerWithTitle:BDFaceAdjustParamsAlertTitle message:BDFaceAdjustParamsAlertContent preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertSaveCustomConfig style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [this saveConfig];
        }];
        [alert addAction:saveAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertCancel style:UIAlertActionStyleCancel handler:nil];
        [alert changeTextToBold:BDFaceAdjustParamsAlertSaveCustomConfig];
        [alert changeTextToLight:@[BDFaceAdjustParamsAlertCancel]];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    
}

- (void)saveConfig {
    [BDFaceAdjustParamsFileManager sharedInstance].selectType = BDFaceSelectTypeCustom;
    [BDFaceAdjustParamsTool changeConfig:self.currentConfig];
    [[BDFaceAdjustParamsFileManager sharedInstance] saveToCustomConfigFile:self.currentConfig];
    [[NSNotificationCenter defaultCenter] postNotificationName:BDFaceAdjustParamsUserDidFinishSavedConfigNotification object:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsCell *theCell = [tableView cellForRowAtIndexPath:indexPath];
    if ([theCell isKindOfClass:[BDFaceAdjustParamsCell class]]) {
        BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)theCell.data;
        if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
            if (self.isSameConfig) {
                // do nothing
            } else {
                __weak typeof(self) this = self;
                BDFaceAlertController *alert = [BDFaceAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否%@", item.itemTitle] message:BDFaceAdjustParamsAlertRecoverToDefaultTip preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *saveAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertRecoverToDefault style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [this recoverToInital];
                }];
                [alert addAction:saveAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertCancel style:UIAlertActionStyleCancel handler:nil];
                [alert changeTextToBold:BDFaceAdjustParamsAlertRecoverToDefault];
                [alert changeTextToLight:@[BDFaceAdjustParamsAlertCancel]];
                [alert addAction:cancelAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
        }
        
    }
}

/// 恢复为默认值
- (void)recoverToInital {
    self.selectType = self.initialSelect;
    BDFaceAdjustParams *config = [[BDFaceAdjustParamsFileManager sharedInstance] configBySelection:self.selectType];
    self.configInital = [config copy];
    self.currentConfig = [config copy];
    self.isSameConfig = YES;
    [self updateSaveButtonTextColor];
    [self.allData removeAllObjects];
    NSMutableArray *array = [BDFaceAdjustParamsModel loadItemsArray:self.currentConfig recorverText:self.recoverText selectType:self.selectType];
    [self.allData addObjectsFromArray:array];
    [self.tableView reloadData];
    dispatch_after(0.5, dispatch_get_main_queue(), ^{
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    });
}

- (UITableViewStyle)customTableViewStyle {
    return UITableViewStyleGrouped;
}

/// 点击返回按钮
- (void)goBack {
    if (self.isSameConfig) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        __weak typeof(self) this = self;
        BDFaceAlertController *alert = [BDFaceAlertController alertControllerWithTitle:BDFaceAdjustParamsAlertTitle message:BDFaceAdjustParamsAlertContent preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *saveAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertSaveAndLeave style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [this saveConfig];
        }];
        [alert addAction:saveAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:BDFaceAdjustParamsAlertJustLeave style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [alert dismissViewControllerAnimated:NO completion:nil];
            [this.navigationController popViewControllerAnimated:YES];
        }];
        [alert changeTextToBold:BDFaceAdjustParamsAlertSaveAndLeave];
        [alert changeTextToLight:@[BDFaceAdjustParamsAlertJustLeave]];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *des = nil;
    switch (section) {
        case 0:
        {
            CGRect rect = CGRectMake(BDFaceSelectConfigTableMargin, 0, CGRectGetWidth(self.view.frame) - BDFaceSelectConfigTableMargin * 2.0f, BDFaceSelectConfigTableViewHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            
            CGRect label1Rect = view.bounds;
            label1Rect.origin.y = BBDFaceAjustConfigTableViewOriginY;
            label1Rect.size.height = BDFaceSelectConfigTableViewHeight;
            UILabel *label1 = [[UILabel alloc] initWithFrame:label1Rect];
            [view addSubview:label1];
            
            label1.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor];
            label1.text = BDFaceAdjustParamsSection1Tip;
            label1.font = [UIFont systemFontOfSize:14.0f];
            des = view;
        }
            break;
        case 1:{
            CGRect rect = CGRectMake(BDFaceSelectConfigTableMargin, 0, CGRectGetWidth(self.view.frame) - BDFaceSelectConfigTableMargin * 2.0f, BDFaceSelectConfigTableViewHeight);
            UIView *view = [[UIView alloc] initWithFrame:rect];
            
            CGRect label1Rect = view.bounds;
            label1Rect.origin.y = BBDFaceAjustConfigTableViewOriginY;
            label1Rect.size.height = BDFaceSelectConfigTableViewHeight;
            UILabel *label1 = [[UILabel alloc] initWithFrame:label1Rect];
            [view addSubview:label1];
            
            label1.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor];
            label1.text = BDFaceAdjustParamsSection2Tip;
            label1.font = [UIFont systemFontOfSize:14.0f];
            des = view;
        }
            break;;
            
        default:
            break;
    }
    return des;
}

- (void)updateCellContent:(UITableViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    BDFaceAdjustParamsCell *theCell = (BDFaceAdjustParamsCell *)cell;
    theCell.isSameConfig = self.isSameConfig;
    __weak typeof(self) this = self;
    if ([theCell isKindOfClass:[BDFaceAdjustParamsCell class]]) {
        theCell.didFinishAdjustParams = ^(BDFaceAdjustParamsItemType type, float value) {
            [this changCurrentValue:type value:value];
            [this compareValues];
        };
    }
}

- (void)updateSaveButtonTextColor {
    if (self.isSameConfig) {
        [self.saveButton setTitleColor:[UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverUnactiveTextColor] forState:UIControlStateNormal];
    } else {
        [self.saveButton setTitleColor:[UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverActiveTextColor] forState:UIControlStateNormal];
    }
}

- (void)compareValues {
    BOOL temp = self.isSameConfig;
    if (![self.currentConfig compareToParams:self.configInital]) {
        self.isSameConfig = NO;
    } else {
        self.isSameConfig = YES;
    }
    if (temp != self.isSameConfig) {
        NSDictionary *dic = @{BDFaceAdjustParamsControllerConfigIsSameKey : @(self.isSameConfig)};
        [[NSNotificationCenter defaultCenter] postNotificationName:BDFaceAdjustParamsControllerConfigDidChangeNotification object:dic];
        [self updateSaveButtonTextColor];
    }
}

- (void)changCurrentValue:(BDFaceAdjustParamsItemType)type value:(float) value {
    switch (type) {
            /// 光照
        case BDFaceAdjustParamsTypeMinLightIntensity:
        {
            self.currentConfig.minLightIntensity = value;
        }
            break;
        case BDFaceAdjustParamsTypeMaxLightIntensity:
        {
            self.currentConfig.maxLightIntensity = value;
        }
            break;
        case BDFaceAdjustParamsTypeAmbiguity:
        {
            self.currentConfig.ambiguity = value;
        }
            break;
            /// 遮挡
        case BDFaceAdjustParamsTypeLeftEyeOcclusion:
        {
            self.currentConfig.leftEyeOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeRightEyeOcclusion:
        {
            self.currentConfig.rightEyeOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeNoseOcclusion:
        {
            self.currentConfig.noseOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeMouthOcclusion:
        {
            self.currentConfig.mouthOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeLeftFaceOcclusion:
        {
            self.currentConfig.leftFaceOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeRightFaceOcclusion:
        {
            self.currentConfig.rightFaceOcclusion = value;
        }
            break;
        case BDFaceAdjustParamsTypeLowerJawOcclusion:
        {
            self.currentConfig.lowerJawOcclusion = value;
        }
            break;
            /// 姿势
        case BDFaceAdjustParamsTypeUpAndDownAngle:
        {
            self.currentConfig.upAndDownAngle = value;
        }
            break;
        case BDFaceAdjustParamsTypeLeftAndRightAngle:
        {
            self.currentConfig.leftAndRightAngle = value;
        }
            break;
        case BDFaceAdjustParamsTypeSpinAngle:
        {
            self.currentConfig.spinAngle = value;
        }
            break;
        default:
            break;
    }
}


@end
