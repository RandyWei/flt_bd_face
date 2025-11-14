//
//  BDFaceAdjustParamsRootCell.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsRootCell.h"
#import "BDFaceAdjustParamsConstants.h"
#import "UIColor+BDFaceColorUtils.h"


@interface BDFaceAdjustParamsRootCell()

@property(nonatomic, strong) UIView *seperator;

@property(nonatomic, assign) BDFaceCellPostionType postionType; // 在section里只有一个cell

@property(nonatomic, strong) CAShapeLayer *maskLayer;
@property(nonatomic, strong) CALayer *borderLayer;
@property(nonatomic, strong) CALayer *layerForHiding;

@end

@implementation BDFaceAdjustParamsRootCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)cellFinishLoad:(NSInteger)rowsInSection {
    // do nothing
    if (!self.seperator) {
        self.seperator = [[UIView alloc] init];
        [self.contentView addSubview:self.seperator];
        self.seperator.backgroundColor = [self.class seperatorColor];
    }
    if (rowsInSection == 1) {
        self.postionType = BDFaceCellPostionTypeOnlyOneCell;
    } else if (self.indexPath.row == 0 && rowsInSection > 1) {
        self.postionType = BDFaceCellPostionTypeMoreThanOneFirst;
    } else if (self.indexPath.row == (rowsInSection - 1) && rowsInSection > 1){
        self.postionType = BDFaceCellPostionTypeMoreThanOneLast;
    } else {
        self.postionType = BDFaceCellPostionTypeMoreThanOneMiddle;
    }
}

+ (UIColor *)seperatorColor {
    return [UIColor clearColor];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.seperator.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 1.0f / UIScreen.mainScreen.scale, CGRectGetWidth(self.frame), 1.0f / UIScreen.mainScreen.scale);
}

+ (CGFloat)HeightOfFaceAdjustCell {
    return 10.0;
}

- (void)setConerRadius:(float)cornerRadius
           borderWidth:(CGFloat)borderWidth
           borderColor:(nullable CGColorRef)borderColor {
    self.layer.mask = nil;
    [self.maskLayer removeFromSuperlayer];
    self.maskLayer = nil;
    [self.borderLayer removeFromSuperlayer];
    self.borderLayer = nil;
    [self.layerForHiding removeFromSuperlayer];
    self.layerForHiding = nil;
    
    if (!borderColor) {
        borderColor = [UIColor face_colorWithRGBHex:BDFaceAdjustParamsSeperatorColor].CGColor;
    }
    
    BOOL hideBorder = NO;
    UIRectCorner corner;
    switch (self.postionType) {
        case BDFaceCellPostionTypeOnlyOneCell:
        {
            corner = UIRectCornerAllCorners;
            hideBorder = NO;
        }
            break;
        case BDFaceCellPostionTypeMoreThanOneMiddle:
        {
            corner = UIRectCornerAllCorners;
            cornerRadius = 0;
            hideBorder = YES;
        }
            break;
        case BDFaceCellPostionTypeMoreThanOneFirst:
        {
            corner = UIRectCornerTopLeft | UIRectCornerTopRight;
            hideBorder = NO;
        }
            break;
        case BDFaceCellPostionTypeMoreThanOneLast:
        {
            corner = UIRectCornerBottomLeft | UIRectCornerBottomRight;
            hideBorder = YES;
        }
            break;
            
        default:
            break;
    }
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corner cornerRadii:CGSizeMake(cornerRadius, cornerRadius)];
    CAShapeLayer * layer = [[CAShapeLayer alloc]init];
    layer.frame = self.bounds;
    layer.path = path.CGPath;
    self.layer.mask = layer;
    self.maskLayer = layer;
    
    float borderWith = borderWidth;
    CAShapeLayer *borderShape = [CAShapeLayer layer];
    borderShape.frame = self.bounds;
    borderShape.path = path.CGPath;
    borderShape.strokeColor = borderColor;
    borderShape.fillColor = nil;
    borderShape.lineWidth = borderWith;
    [self.layer addSublayer:borderShape];
    self.borderLayer = borderShape;
    
    if (hideBorder) {
        float hiddenBorderWidth = borderWidth;
        CALayer *hiddenBorder = [CALayer layer];
        hiddenBorder.frame = CGRectMake(hiddenBorderWidth, 0, CGRectGetWidth(self.bounds) - hiddenBorderWidth * 2 , hiddenBorderWidth);
        hiddenBorder.backgroundColor = self.backgroundColor.CGColor;
        [borderShape addSublayer:hiddenBorder];
        self.layerForHiding = hiddenBorder;
    }
}

@end
