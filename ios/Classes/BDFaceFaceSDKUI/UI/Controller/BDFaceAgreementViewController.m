//
//  BDFaceAgreementViewController.m
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/3/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAgreementViewController.h"
#import "BDFaceLogoView.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BDFaceAgreementViewController ()

@end

@implementation BDFaceAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];

    // 顶部
    UILabel *titeLabel = [[UILabel alloc] init];
    titeLabel.frame = CGRectMake(0, 38, ScreenWidth, 20);
    titeLabel.text = @"人脸采集协议";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 43.3, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    UIView *lineView = [[UIView alloc] init];
    lineView.frame = CGRectMake(0, 79.7, ScreenWidth, 0.3);
    lineView.backgroundColor = [UIColor colorWithRed:216 / 255.0 green:216 / 255.0 blue:216 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:lineView];
    
    UIView *liveView = [[UIView alloc] init];
    liveView.frame = CGRectMake(0, 105, ScreenWidth-40, 400);
    
    // 间距
    int spacing = 0;
    
    for (int num = 0; num < 3; num++){
        UIImage *image = [UIImage imageNamed:@"image_agreement"];
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(20, spacing, 3, 18);
        imageView1.image = image;
        UILabel *line1 = [[UILabel alloc] init];
        line1.frame = CGRectMake(29, spacing, ScreenWidth-40, 18);
        line1.text = [self getTitle:num];
        line1.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
        line1.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
       
        UILabel *line2 = [[UILabel alloc] initWithFrame:CGRectMake(20, spacing+CGRectGetHeight(line1.frame) + 15,  (ScreenWidth-40), 0)];
        line2.numberOfLines = 0;
        line2.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
        line2.textColor = [UIColor colorWithRed:85 / 255.0 green:85 / 255.0 blue:85 / 255.0 alpha:1 / 1.0];
        line2.text = [self getMessage:num];
        line2.textAlignment = NSTextAlignmentLeft;
        CGSize size = [line2 sizeThatFits:CGSizeMake(line2.frame.size.width, MAXFLOAT)];
        line2.frame = CGRectMake(20, spacing +CGRectGetHeight(line1.frame)+ 15, (ScreenWidth-40), size.height);
        
        spacing += CGRectGetHeight(line1.frame) + 15 + CGRectGetHeight(line2.frame) + 25;
        
        [liveView addSubview:imageView1];
        [liveView addSubview:line1];
        [liveView addSubview:line2];
    }
    
    [self.view addSubview:liveView];
    
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
}

- (IBAction)backAction:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSString *)getTitle:(int)type{
    NSString* title;
    switch (type) {
        case 0:
            title = @"功能说明";
            break;
           case 1:
            title = @"授权与许可";
            break;
        case 2:
            title = @"信息安全声明";
            break;
        default:
            break;
    }
    return title;
}

- (NSString *)getMessage:(int)type{
    NSString* title;
    switch (type) {
        case 0:
            title = @"为保障用户账户的安全，提供更好的服务，在提供部分产品及服务之前,采用人脸核身验证功能对用户的身份进行认证，用于验证操作人是否为账户持有者本人，通过人脸识别结果评估是否为用户提供后续产品或服务。该功能会请求权威数据源进行身份信息确认。";
            break;
           case 1:
            title = @"如您点击“确认”或以其他方式选择接受本协议规则，则视为您在使用人脸识别服务时，同意并授权、获取、使用您在申请过程中所提供的个人信息。";
            break;
        case 2:
            title = @"承诺对您的个人信息严格保密，并基于国家监管部门认可的加密算法进行数据加密传输，数据加密存储，承诺尽到信息安全保护义务。";
            break;
        default:
            break;
    }
    return title;
}



@end
