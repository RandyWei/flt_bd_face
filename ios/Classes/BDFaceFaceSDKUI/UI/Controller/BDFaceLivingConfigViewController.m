//
//  LivingConfigViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceLivingConfigViewController.h"
#import "BDFaceLivingConfigModel.h"
#import "IDLFaceSDK/IDLFaceSDK.h"
#import "BDFaceLogoView.h"
#import "BDFaceSelectConfigController.h"
#import "UIColor+BDFaceColorUtils.h"
#import "BDFaceToastView.h"
#import "BDFaceAdjustParamsFileManager.h"

#define SoundSwitch @"SoundMode"
#define LiveDetect @"LiveMode"
#define ByOrder @"ByOrder"
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

@interface BDFaceLivingConfigViewController ()
@property (strong, nonatomic) UISwitch *voiceSwitch;
@property (strong, nonatomic) UIImageView *warningView;
@property (strong, nonatomic) UILabel *waringLabel;
@property (strong, nonatomic) UIView *liveView;
@property (assign, nonatomic) NSInteger totalSelected;
@property (assign, nonatomic) NSInteger currentSelectedCount;
@property (strong, nonatomic) UILabel *stateLabel;
@end

@implementation BDFaceLivingConfigViewController{
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.totalSelected = 6;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithRed:249 / 255.0 green:249 / 255.0 blue:249 / 255.0 alpha:1 / 1.0];

    // 顶部
    UILabel *titeLabel = [[UILabel alloc] init];
    titeLabel.frame = CGRectMake(0, 46-5, ScreenWidth, 20);
    titeLabel.text = @"设置";
    titeLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:20];
    titeLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    titeLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:titeLabel];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 50-5, 20, 20);
    [backButton setImage:[UIImage imageNamed:@"icon_titlebar_back"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 提示
    UILabel *noticeLabel = [[UILabel alloc] init];
    noticeLabel.frame = CGRectMake(20, 100-15, 302.7, 14);
    noticeLabel.text = @"提示: 正式使用时，开发者可将前端设置功能隐藏";
    noticeLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    [noticeLabel setTextAlignment:NSTextAlignmentCenter];
    noticeLabel.textColor = [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:noticeLabel];
    
    UIImage *backSelectImage = [UIImage imageNamed:@"icon_live_list"];
    
    // 语音播报部分
    {
        UIImageView *imageView1 = [[UIImageView alloc] init];
        imageView1.frame = CGRectMake(20, 129-15, ScreenWidth-40, 48);
        imageView1.image = backSelectImage;
        [self.view addSubview:imageView1];
        UILabel *voiceLabel = [[UILabel alloc] init];
        voiceLabel.frame = CGRectMake(35, 144-15, 72, 18);
        voiceLabel.text = @"语音播报";
        voiceLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        voiceLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        
        // 音量开启/关闭的switch button
        self.voiceSwitch = [[UISwitch alloc] init];
        // UISwitch 系统默认大小，fram 不起作用
        self.voiceSwitch.frame = CGRectMake(ScreenWidth-38-48, 136.7-15, 38, 23);
        [self.voiceSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        NSNumber *soundeMode = [[NSUserDefaults standardUserDefaults] objectForKey:SoundSwitch];
        self.voiceSwitch.on = soundeMode.boolValue;
        [self.view addSubview:voiceLabel];
        [self.view addSubview:self.voiceSwitch];
        [self changeSwitchColor:self.voiceSwitch];
    }
    
    // 质量控制部分
    {
        UIButton *qualityButton = [[UIButton alloc] init];
        qualityButton.frame = CGRectMake(20, 197-15, ScreenWidth-40, 48);
        [qualityButton setBackgroundImage:backSelectImage forState:UIControlStateNormal];
        [qualityButton setBackgroundImage:backSelectImage forState:UIControlStateHighlighted];
        [self.view addSubview:qualityButton];
        [qualityButton addTarget:self action:@selector(toSettingPage) forControlEvents:UIControlEventTouchUpInside];
        UILabel *qualityLabel = [[UILabel alloc] init];
        qualityLabel.frame = CGRectMake(35, 212-15, 72, 18);
        qualityLabel.text = @"质量控制";
        qualityLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
        qualityLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
        [self.view addSubview:qualityLabel];
        UIImageView *rightArrow = [[UIImageView alloc] init];
        // UISwitch 系统默认大小，fram 不起作用
        rightArrow.frame = CGRectMake(ScreenWidth-60, 206-15, 30, 30);
        rightArrow.image = [UIImage imageNamed:@"right_arrow"];
        [rightArrow setContentMode:UIViewContentModeCenter];
        [self.view addSubview:rightArrow];
        
        CGRect stateLabelRect = rightArrow.frame;
        CGFloat stateLabelWidth = 60.0f;
        stateLabelRect.origin.x = CGRectGetMinX(rightArrow.frame) - stateLabelWidth;
        stateLabelRect.size.width = stateLabelWidth;
        UILabel *stateLabel = [[UILabel alloc] initWithFrame:stateLabelRect];
        [self.view addSubview:stateLabel];
        stateLabel.textAlignment = NSTextAlignmentRight;
        stateLabel.textColor =  [UIColor colorWithRed:153 / 255.0 green:153 / 255.0 blue:153 / 255.0 alpha:1 / 1.0];
        self.stateLabel = stateLabel;
        
    }
    // 活体检测部分，switch和label
    UIImageView *imageView2 = [[UIImageView alloc] init];
    imageView2.frame = CGRectMake(20, 265-15, ScreenWidth-40, 48);
    imageView2.image = backSelectImage;
    [self.view addSubview:imageView2];
    UILabel *liveLabel = [[UILabel alloc] init];
    liveLabel.frame = CGRectMake(35, 280-15, 72, 18);
    liveLabel.text = @"活体检测";
    liveLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
    liveLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    [self.view addSubview:liveLabel];
    UISwitch *liveSwitch = [[UISwitch alloc] init];
    liveSwitch.frame = CGRectMake(ScreenWidth-38-48, 272.7-15, 38, 23);
    [liveSwitch addTarget:self action:@selector(isRunLiveDetect:) forControlEvents:UIControlEventValueChanged];
    NSNumber *liveMode = [[NSUserDefaults standardUserDefaults] objectForKey:LiveDetect];
    liveSwitch.on = liveMode.boolValue;
    [self.view addSubview:liveSwitch];
    [self changeSwitchColor:liveSwitch];
    
    self.liveView = [[UIView alloc] init];
    self.liveView.frame = CGRectMake(0, 313-15, ScreenWidth-40, 400);
    
    // 循环创建控件，相应的为动作选择，根据tag来确定点击的是哪个控件
    for (int i = 0; i < 7; i++){
        int y = i * 48;
        UIImageView *strName = [[UIImageView alloc] init];
        strName.frame = CGRectMake(20, y, ScreenWidth-40, 48);
        strName.image = backSelectImage;
        [self.liveView addSubview:strName];
        if (i == 0) {
            // 是否按顺序的switch和label
            UILabel *byOrderLabel = [[UILabel alloc] init];
            byOrderLabel.frame = CGRectMake(35, 15.3, 144, 18);
            byOrderLabel.text = @"活体动作顺序随机";
            byOrderLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:18];
            byOrderLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
            [self.liveView addSubview:byOrderLabel];
            UISwitch *orderSwitch = [[UISwitch alloc] init];
            orderSwitch.frame = CGRectMake(ScreenWidth-38-48, 8, 38, 23);
            [orderSwitch addTarget:self action:@selector(isByOrderAction:) forControlEvents:UIControlEventValueChanged];
            NSNumber *orderMode = [[NSUserDefaults standardUserDefaults] objectForKey:ByOrder];
            orderSwitch.on = !orderMode.boolValue;
            [self.liveView addSubview:orderSwitch];
            [self changeSwitchColor:orderSwitch];
        } else {
            UIButton *buttonView = [[UIButton alloc] init];
            buttonView.frame = CGRectMake(35, y + 14.8, 20, 20);
            buttonView.tag = i;
            [buttonView addTarget:self action:@selector(buttonTagClick:) forControlEvents:UIControlEventTouchUpInside];
            
            // 判断数组中是否有上次选择结果，如果有，继续选择
            if([BDFaceLivingConfigModel.sharedInstance.liveActionArray containsObject:@(i-1)]){
                buttonView.selected = YES;
                [buttonView setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
            } else {
                buttonView.selected = NO;
                [buttonView setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
            }
            [self.liveView  addSubview:buttonView];
            
            // 相应的label
            UILabel *actionLabel = [[UILabel alloc] init];
            actionLabel.frame = CGRectMake(65, y + 14.8, 192, 16);
            actionLabel.text = [self getLiveName:i];
            actionLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
            actionLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
            [self.liveView  addSubview:actionLabel];
        }
    }
    
    [self.view addSubview:self.liveView ];
    
    // 不正常操作问题，相应的view
    self.warningView = [[UIImageView alloc] init];
    self.warningView.frame = CGRectMake((ScreenWidth-208) / 2, 298, 208, 44);
    self.warningView.image = [UIImage imageNamed:@"icon_notice"];
    
    self.waringLabel = [[UILabel alloc] init];
    self.waringLabel.frame = CGRectMake((ScreenWidth-168) / 2, 310, 168, 14);
    self.waringLabel.text = @"至少需要选择一项活体动作";
    self.waringLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:14];
    self.waringLabel.textColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    
    if (liveMode.boolValue) {
        self.liveView.hidden = NO;
    } else {
        self.liveView.hidden = YES;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    self.stateLabel.text = [BDFaceAdjustParamsFileManager currentSelectionText];
}

- (void)toSettingPage {
    BDFaceSelectConfigController *lvc = [[BDFaceSelectConfigController alloc] init];
    [self.navigationController pushViewController:lvc animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}


- (IBAction)backAction:(UIButton *)sender {
    // 判定是否选择了两个动作或以上，在开启动作活体时候。
    NSNumber *liveMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"LiveMode"];
    if (BDFaceLivingConfigModel.sharedInstance.numOfLiveness >= 1 || !liveMode.boolValue){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        
        [self.view addSubview:self.warningView];
        [self.view addSubview:self.waringLabel];
        
    }
    NSNumber *orderMode = [[NSUserDefaults standardUserDefaults] objectForKey:ByOrder];
    BDFaceLivingConfigModel.sharedInstance.isByOrder = orderMode.boolValue;
}

# pragma mark - 动作活体button相应的部分

- (IBAction)liveEyeAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveEye)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveEye)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveMouthAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveMouth)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveMouth)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveHeadRightAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawRight)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveYawRight)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveHeadLeftAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYawLeft)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveYawLeft)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveHeadUpAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchUp)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLivePitchUp)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveHeadDownAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLivePitchDown)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLivePitchDown)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)liveYawAction:(UIButton *)sender {
    sender.selected ^= 1;
    if (sender.selected) {
        [sender setImage:[UIImage imageNamed:@"icon_check_select"] forState:UIControlStateSelected];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray addObject:@(FaceLivenessActionTypeLiveYaw)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness ++;
        
    } else {
        [sender setImage:[UIImage imageNamed:@"icon_check"] forState:UIControlStateNormal];
        [BDFaceLivingConfigModel.sharedInstance.liveActionArray removeObject:@(FaceLivenessActionTypeLiveYaw)];
        BDFaceLivingConfigModel.sharedInstance.numOfLiveness --;
    }
}

- (IBAction)buttonTagClick:(UIButton *)sender{
    BOOL desState = sender.selected;
    desState = !desState;
    NSInteger temp = self.totalSelected;
    if (desState) {
        self.totalSelected++;
    } else {
        self.totalSelected--;
    }
    if (self.totalSelected == 0) {
        self.totalSelected = temp;
        [BDFaceToastView showToast:self.view text:@"至少选择一项活体动作"];
        return;;
    }
    [self.warningView removeFromSuperview];
    [self.waringLabel removeFromSuperview];
    
    switch (sender.tag) {
        case 1:
            [self liveEyeAction:sender];
            break;
        case 2:
            [self liveMouthAction:sender];
            break;
        case 3:
            [self liveHeadRightAction:sender];
            break;
        case 4:
            [self liveHeadLeftAction:sender];
            break;
        case 5:
            [self liveHeadUpAction:sender];
            break;
        case 6:
            [self liveHeadDownAction:sender];
            break;
        case 7:
            [self liveYawAction:sender];
            break;
        default:
            break;
    }
    if (sender.selected){
        // 如果选择按照顺序，对活体动作按设置页面顺序排序
        NSNumber *orderMode = [[NSUserDefaults standardUserDefaults] objectForKey:ByOrder];
        if (orderMode.boolValue){
            [BDFaceLivingConfigModel.sharedInstance.liveActionArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                return [obj1 intValue] > [obj2 intValue];
            }];
        }
    }
}

- (NSString *)getLiveName:(int) k{
    switch (k) {
        case 1:
            return @"眨眨眼";
            break;
        case 2:
            return @"张张嘴";
            break;
        case 3:
            return @"向右摇头";
            break;
        case 4:
            return @"向左摇头";
            break;
        case 5:
            return @"向上抬头";
            break;
        case 6:
            return @"向下低头";
            break;
//        case 7:
//            return @"左右摇头";
//            break;
        default:
            break;
    }
    return @"";
}

- (void)changeSwitchColor:(UISwitch *)view {
    view.onTintColor = [UIColor face_colorWithRGBHex:0x00BAF2];
    view.layer.cornerRadius = CGRectGetHeight(view.frame) / 2.0f;
}
# pragma mark - switch button部分

- (IBAction)switchAction:(UISwitch *)sender {
    if (sender.isOn) {
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = YES;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:SoundSwitch];
        NSLog(@"打开了声音");
    } else {
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = NO;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:SoundSwitch];
        NSLog(@"关闭了声音");
    }
}

- (IBAction)isRunLiveDetect:(UISwitch *)sender{
    if (sender.isOn) {
        self.liveView.hidden = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:LiveDetect];
        NSLog(@"打开了活体检测");
    } else {
         self.liveView.hidden = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:LiveDetect];
        NSLog(@"关闭了活体检测");
    }
}

- (IBAction)isByOrderAction:(UISwitch *)sender {
    if (sender.isOn) {
        BDFaceLivingConfigModel.sharedInstance.isByOrder = NO;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:ByOrder];
        NSLog(@"不按照顺序");
    } else {
        
        BDFaceLivingConfigModel.sharedInstance.isByOrder = YES;
        // warning 本地存储是为了Demo呈现Switch开关状态, 实际上SDK声音开关运用跟本地存储无关
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:ByOrder];
        NSLog(@"按照顺序");
    }
}
@end
