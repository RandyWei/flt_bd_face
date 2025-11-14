//
//  BDFaceAdjustParamsCell.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsCell.h"
#import "BDFaceAdjustParamsItem.h"
#import "BDFaceAdjustParamsConstants.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceCalculateTool.h"

float const BDFaceAdjustParamsCellHeight = 48.0f;

static float const BDFaceAdjustParamsLeftButtonWidth = 50.0f;
static float const BDFaceAdjustParamsLeftButtonHeight = 46.0f;
static float const BDFaceAdjustParamsLeftButtonRightMargin = 10.0f;

static float const BDFaceAdjustParamsNumberLabelWidth = 60.0f;
static float const BDFaceAdjustParamsNumberLabelHeight = 46.0f;
static float const BDFaceAdjustParamsNumberLabelRightMargin = BDFaceAdjustParamsLeftButtonRightMargin;

static float const BDFaceAdjustParamsRightButtonWidth = BDFaceAdjustParamsLeftButtonWidth;
static float const BDFaceAdjustParamsRightButtonHeight = BDFaceAdjustParamsLeftButtonHeight;
static float const BDFaceAdjustParamsRightButtonRightMargin = 10.0f;

@interface BDFaceAdjustParamsCell()

@property(nonatomic, strong)UIButton *leftButton;
@property(nonatomic, strong)UIButton *rightButton;
@property(nonatomic, strong)UILabel *numberLabel;

@end

@implementation BDFaceAdjustParamsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)HeightOfFaceAdjustCell {
    return BDFaceAdjustParamsCellHeight;
}

- (void)cellFinishLoad:(NSInteger)rowsInSection {
    [super cellFinishLoad:rowsInSection];
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    self.textLabel.text = item.itemTitle;
    self.textLabel.textColor = [UIColor blackColor];
    self.backgroundColor = [UIColor whiteColor];
    
    if (!self.leftButton) {
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.leftButton];
    }
    
    if (!self.numberLabel) {
        self.numberLabel = [[UILabel alloc]init];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.numberLabel];
    }
    self.numberLabel.text = [self numberString:item.currentValue];
    [self.numberLabel layoutIfNeeded];
    if (!self.rightButton) {
        self.rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:self.rightButton];
    }
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configisChange:) name:BDFaceAdjustParamsControllerConfigDidChangeNotification object:nil];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configisChange:(NSNotification *)notification {
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
        NSDictionary *dic = notification.object;
        if ([BDFaceCalculateTool noNullDic:dic]) {
            NSNumber *number = dic[BDFaceAdjustParamsControllerConfigIsSameKey];
            self.isSameConfig = number.boolValue;
            if (number.boolValue) {
                self.textLabel.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverUnactiveTextColor];
            } else {
                self.textLabel.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverActiveTextColor];
            }
        }
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    CGFloat leftButtonOriginX = CGRectGetWidth(self.frame) - BDFaceAdjustParamsLeftButtonWidth - BDFaceAdjustParamsLeftButtonRightMargin - BDFaceAdjustParamsNumberLabelWidth - BDFaceAdjustParamsNumberLabelRightMargin - BDFaceAdjustParamsRightButtonWidth - BDFaceAdjustParamsRightButtonRightMargin;
    self.leftButton.frame = CGRectMake(leftButtonOriginX, (CGRectGetHeight(self.frame) - BDFaceAdjustParamsLeftButtonHeight) / 2.0f, BDFaceAdjustParamsLeftButtonWidth, BDFaceAdjustParamsLeftButtonHeight);
    self.numberLabel.frame = CGRectMake(CGRectGetMaxX(self.leftButton.frame) + BDFaceAdjustParamsLeftButtonRightMargin, (CGRectGetHeight(self.frame) - BDFaceAdjustParamsNumberLabelHeight) / 2.0f, BDFaceAdjustParamsNumberLabelWidth, BDFaceAdjustParamsNumberLabelHeight);
    self.rightButton.frame = CGRectMake(CGRectGetMaxX(self.numberLabel.frame) + BDFaceAdjustParamsNumberLabelRightMargin, (CGRectGetHeight(self.frame) - BDFaceAdjustParamsRightButtonHeight) / 2.0f, BDFaceAdjustParamsRightButtonWidth, BDFaceAdjustParamsRightButtonHeight);
    
    self.numberLabel.textColor = [UIColor blackColor];
    
    [self.leftButton addTarget:self action:@selector(minusNumber) forControlEvents:UIControlEventTouchUpInside];
    [self.rightButton addTarget:self action:@selector(addNumber) forControlEvents:UIControlEventTouchUpInside];
    if (self.indexPath.row == 0) {
        [self setCellsConerRadius:UIRectCornerTopLeft | UIRectCornerTopRight];
    }
    if ((self.indexPath.section == 0 && self.indexPath.row == 2)
        || (self.indexPath.section == 1 && self.indexPath.row == 6)
        || (self.indexPath.section == 2 && self.indexPath.row == 2)) {
        [self setCellsConerRadius:UIRectCornerBottomLeft | UIRectCornerBottomRight];
    }
    [self setConerRadius:BDFaceAdjustConfigTableCornerRadius borderWidth:(1.0f / UIScreen.mainScreen.scale) borderColor:nil];
    
    if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
        self.rightButton.hidden = YES;
        self.leftButton.hidden = YES;
        self.numberLabel.hidden = YES;
        self.textLabel.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverUnactiveTextColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:16.0];
    } else {
        self.rightButton.hidden = NO;
        self.leftButton.hidden = NO;
        self.numberLabel.hidden = NO;
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.font = [UIFont systemFontOfSize:16.0];
    }
    
    [self resetTitleViewColor];
    [self resetPlusAndMinusButtons];
}

- (void)resetPlusAndMinusButtons {
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    NSString *currentValue = [self numberString:item.currentValue];
    NSString *maxValue = [self numberString:item.maxValue];
    NSString *minValue = [self numberString:item.minValue];
    
    if (currentValue.floatValue == minValue.floatValue) {
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_unable"] forState:UIControlStateHighlighted];
    } else {
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_normal"] forState:UIControlStateNormal];
        [self.leftButton setImage:[UIImage imageNamed:@"left_button_highlight"] forState:UIControlStateHighlighted];
    }
    
    if (currentValue.floatValue == maxValue.floatValue) {
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_unable"] forState:UIControlStateHighlighted];
    } else {
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_normal"] forState:UIControlStateNormal];
        [self.rightButton setImage:[UIImage imageNamed:@"right_button_highlight"] forState:UIControlStateHighlighted];
    }
}

- (void)resetTitleViewColor {
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    if (item.contentType == BDFaceAdjustParamsContentTypeRecoverToNormal) {
        if (self.isSameConfig) {
            self.textLabel.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverUnactiveTextColor];
        } else {
            self.textLabel.textColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsRecoverActiveTextColor];
        }
    } else {
        self.textLabel.textColor = [UIColor blackColor];
    }
}

- (void)setCellsConerRadius:(UIRectCorner)corner{
    UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
}

- (void)minusNumber {
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    if (item.currentValue > item.minValue) {
        item.currentValue = item.currentValue - item.interval;
        self.numberLabel.text = [self numberString:item.currentValue];
        if (self.didFinishAdjustParams) {
            self.didFinishAdjustParams(item.configDetailType, item.currentValue);
        }
    }
    [self resetPlusAndMinusButtons];
}

- (NSString *)numberString:(float)number {
    NSString *str = [NSString stringWithFormat:@"%0.2f", number];
    return [NSString stringWithFormat:@"%@", @(str.floatValue)];
}

- (void)addNumber {
    BDFaceAdjustParamsItem *item = (BDFaceAdjustParamsItem *)self.data;
    if (item.currentValue < item.maxValue) {
        item.currentValue = item.currentValue + item.interval;
        self.numberLabel.text = [self numberString:item.currentValue];
        if (self.didFinishAdjustParams) {
            self.didFinishAdjustParams(item.configDetailType, item.currentValue);
        }
    }
    [self resetPlusAndMinusButtons];
}

@end
