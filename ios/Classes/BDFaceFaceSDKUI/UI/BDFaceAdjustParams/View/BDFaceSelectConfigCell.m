//
//  BDFaceSelectConfigCell.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSelectConfigCell.h"
#import "BDFaceSelectItem.h"
#import "UIColor+BDFaceColorUtils.h"

float const BDFaceSelectConfigCellHeight = 48.0f;

float const BDFaceSelectRadioMarginLeft = 5.0f;
float const BDFaceSelectRadioWidth = 40;
float const BDFaceSelectRadioHeight = BDFaceSelectRadioWidth;
float const BDFaceSelectRadioMarginRight = 0.0f;

float const BDFaceSelectTipLabelWidth = 150.0f;
float const BDFaceSelectTipLabelHeight = 30.0f;

float const BDFaceSelectContentRightMargin = 10.0f;
float const BDFaceSelectSettingButtonWidth = 75.0f;
float const BDFaceSelectSettingButtonHeight = 45.0f;
float const BDFaceSelectSettingImageWidth = 28.0f;
float const BDFaceSelectSettingImageHeight = 45.0f;



static NSString *const BDFaceSelectConfigTip = @"参数配置";
static NSString *const BDFaceSelectRightArrowImage = @"right_arrow";

@interface BDFaceSelectConfigCell()

@property(nonatomic, strong) UILabel *tipLabel;
@property(nonatomic, strong) UIButton *settingButton;
@property(nonatomic, strong) UIButton *arrowButton;
@end

@implementation BDFaceSelectConfigCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)HeightOfFaceAdjustCell {
    return BDFaceSelectConfigCellHeight;
}

- (void)cellFinishLoad:(NSInteger)rowsInSection {
    [super cellFinishLoad:rowsInSection];
    BDFaceSelectItem *item = (BDFaceSelectItem *)self.data;
    if (!self.radio) {
        BDFaceSelectRadio *radio = [BDFaceSelectRadio buttonWithType:UIButtonTypeCustom selected:NO];
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:radio];
        self.radio = radio;
        __weak typeof(self) weakSelf = self;
        self.radio.radioTaped = ^(NSInteger theIndex, BOOL selected) {
            weakSelf.arrowButton.hidden = !selected;
            weakSelf.settingButton.hidden = !selected;
        };
    }
    
    if (!self.tipLabel) {
        self.tipLabel = [[UILabel alloc]init];
        self.tipLabel.textColor = [UIColor blackColor];
        [self addSubview:self.tipLabel];
        self.tipLabel.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
    }
    self.tipLabel.text = item.itemTitle;
    
    if (!self.settingButton) {
        self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.settingButton];
        [self.settingButton setTitle:BDFaceSelectConfigTip forState:UIControlStateNormal];
        self.settingButton.titleLabel.textAlignment = NSTextAlignmentRight;
        [self.settingButton setTitleColor:[UIColor face_colorWithRGBHex:BDFaceAdjustConfigTipTextColor] forState:UIControlStateNormal];
        [self.settingButton addTarget:self action:@selector(userDidChooseToAdjustParams) forControlEvents:UIControlEventTouchUpInside];
        self.settingButton.titleLabel.font = [UIFont systemFontOfSize:BDFaceAdjustConfigContentTitleFontSize];
        
    }
    
    if (!self.arrowButton) {
        self.arrowButton = [[UIButton alloc] init];
        [self addSubview:self.arrowButton];
        [self.arrowButton setImage:[UIImage imageNamed:BDFaceSelectRightArrowImage] forState:UIControlStateNormal];
        [self.arrowButton addTarget:self action:@selector(userDidChooseToAdjustParams) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.radio.frame = CGRectMake(BDFaceSelectRadioMarginLeft, (BDFaceSelectConfigCellHeight - BDFaceSelectRadioHeight) / 2.0f, BDFaceSelectRadioWidth, BDFaceSelectRadioHeight);
    self.tipLabel.frame =CGRectMake(CGRectGetMaxX(self.radio.frame) + BDFaceSelectRadioMarginRight, (BDFaceSelectConfigCellHeight - BDFaceSelectTipLabelHeight) / 2.0, BDFaceSelectTipLabelWidth, BDFaceSelectTipLabelHeight);
    CGFloat settingButtonOriginX = CGRectGetWidth(self.frame) - BDFaceSelectSettingButtonWidth - BDFaceSelectSettingImageWidth - BDFaceSelectContentRightMargin;
    self.settingButton.frame = CGRectMake(settingButtonOriginX, (BDFaceSelectConfigCellHeight - BDFaceSelectSettingButtonHeight) / 2.0f, BDFaceSelectSettingButtonWidth, BDFaceSelectSettingButtonHeight);
    self.arrowButton.frame = CGRectMake(CGRectGetMaxX(self.settingButton.frame), (BDFaceSelectConfigCellHeight - BDFaceSelectSettingImageHeight) / 2.0f, BDFaceSelectSettingImageWidth, BDFaceSelectSettingImageHeight);
    self.settingButton.titleLabel.frame = self.settingButton.bounds;
    
    [self setConerRadius:BDFaceAdjustConfigTableCornerRadius borderWidth:(1.0f / UIScreen.mainScreen.scale) borderColor:nil];
}

- (void)userDidChooseToAdjustParams {
    BDFaceSelectItem *item = (BDFaceSelectItem *)self.data;
    if (self.adjustConfigAction) {
        self.adjustConfigAction(item.itemType);
    }
}

- (void)showSettingButton:(BOOL)show {
    self.settingButton.hidden = !show;
    self.arrowButton.hidden = !show;
}

@end
