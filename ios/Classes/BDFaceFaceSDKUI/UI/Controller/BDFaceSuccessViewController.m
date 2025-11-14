//
//  BDFaceSuccessViewController.m
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/3/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceSuccessViewController.h"
#import "BDFaceLivingConfigViewController.h"
#import "BDFaceDetectionViewController.h"
#import "BDFaceLivenessViewController.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceLivingConfigModel.h"
#import "BDFaceLogoView.h"
#import "BDFaceImageShow.h"

#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BDFaceSuccessViewController ()
@end

@implementation BDFaceSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 43.3, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_close"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 成功图片显示和label
    UIImageView *successImageView = [[UIImageView alloc] init];
    successImageView.frame = CGRectMake((ScreenWidth-97.3) / 2, 156, 97.3, 97.3);
    UIImage *showImage = [[BDFaceImageShow sharedInstance] getSuccessImage];
    successImageView.image = showImage;
    successImageView.layer.masksToBounds = YES;
    successImageView.layer.cornerRadius = 50;
    successImageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.view addSubview:successImageView];
        
    UILabel *successLabel = [[UILabel alloc] init];
    successLabel.frame = CGRectMake(0, 276.3, ScreenWidth, 22);
    successLabel.text = @"人脸采集成功";
    successLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:22];
    successLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    successLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:successLabel];
    
    // 活体UI默认关闭
//    UILabel *liveScoreLabel = [[UILabel alloc] init];
//    liveScoreLabel.frame = CGRectMake(0, 300, ScreenWidth, 22);
//    NSString *liveScoreTxt = [NSString stringWithFormat:@"活体分值 %f ",[[BDFaceImageShow sharedInstance] getSilentliveScore]];
//    liveScoreLabel.text = liveScoreTxt;
//    liveScoreLabel.font = [UIFont systemFontOfSize:16];
//    liveScoreLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
//    liveScoreLabel.textAlignment = NSTextAlignmentCenter;
//    [self.view addSubview:liveScoreLabel];

    // 上下两个button
    UIButton *btnFirst = [[UIButton alloc] init];
    btnFirst.frame = CGRectMake((ScreenWidth-260) / 2, 452, 260, 52);
    [btnFirst setImage:[UIImage imageNamed:@"btn_main_normal"] forState:UIControlStateNormal];
    [btnFirst addTarget:self action:@selector(restartClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnFirst];

    UIButton *btnSecond = [[UIButton alloc] init];
    btnSecond.frame = CGRectMake((ScreenWidth-260) / 2, 516, 260, 52);
    [btnSecond setImage:[UIImage imageNamed:@"btn_less_normal"] forState:UIControlStateNormal];
    [btnSecond addTarget:self action:@selector(backToViewController:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnSecond];
    
    // 对应的label
    UILabel *labelFirst = [[UILabel alloc] init];
    labelFirst.frame = CGRectMake((ScreenWidth-72) / 2, 465+5, 72, 18);
    labelFirst.text = @"重新采集";
    labelFirst.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    labelFirst.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:labelFirst];

    UILabel *labelSecond = [[UILabel alloc] init];
    labelSecond.frame = CGRectMake((ScreenWidth-72) / 2, 529+5, 72, 18);
    labelSecond.text = @"回到首页";
    labelSecond.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    labelSecond.textColor = [UIColor colorWithRed:51 / 255.0 green:51 / 255.0 blue:51 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:labelSecond];
    
     // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];

}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[BDFaceImageShow sharedInstance] reset];
    
}

#pragma mark - Button
- (IBAction)settingAction:(UIButton *)sender{
    // TODO
    BDFaceLivingConfigViewController *lvc = [[BDFaceLivingConfigViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:lvc];
    navi.navigationBarHidden = true;
    navi.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:navi animated:YES completion:nil];
}

- (IBAction)restartClick:(UIButton *)sender{
    // TODO

    NSLog(@"点击");
    NSNumber *LiveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    if (LiveMode.boolValue) {
        UIViewController* fatherViewController = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [[IDLFaceLivenessManager sharedInstance] reset];
            BDFaceLivenessViewController *lvc = [[BDFaceLivenessViewController alloc] init];
            BDFaceLivingConfigModel *model = [BDFaceLivingConfigModel sharedInstance];
            [lvc livenesswithList:model.liveActionArray order:model.isByOrder numberOfLiveness:model.numOfLiveness];
            lvc.modalPresentationStyle = UIModalPresentationFullScreen;
            [fatherViewController presentViewController:lvc animated:YES completion:nil];
        }];

    } else {
        UIViewController *fatherViewController = self.presentingViewController;
        [self dismissViewControllerAnimated:YES completion:^{
            [[IDLFaceDetectionManager sharedInstance] reset];
            BDFaceDetectionViewController* lvc = [[BDFaceDetectionViewController alloc] init];
            lvc.modalPresentationStyle = UIModalPresentationFullScreen;
            [fatherViewController presentViewController:lvc animated:YES completion:nil];
        }];
    }
}

- (IBAction)backToViewController:(UIButton *)sender{
    // TODO
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)backAction:(UIButton *)sender{
    // TODO
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


@end
