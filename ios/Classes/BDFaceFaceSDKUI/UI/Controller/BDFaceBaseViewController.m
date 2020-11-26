//
//  BDFaceBaseViewController.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceBaseViewController.h"
#import "BDFaceVideoCaptureDevice.h"
#import "BDFaceImageUtils.h"
#import "BDFaceRemindView.h"
#import "BDFaceLogoView.h"
#import "NSBundle+AssociatedBundle.h"

// 判断是否是ipad
#define isPad ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)

// 判断iPhoneX
#define IS_IPHONE_X ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPHoneXr
#define IS_IPHONE_Xr ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs
#define IS_IPHONE_Xs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)
// 判断iPhoneXs Max
#define IS_IPHONE_Xs_Max ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) && !isPad : NO)

#define scaleValue 0.70
#define scaleValueX 0.80

#define ScreenRect [UIScreen mainScreen].bounds
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

#define ImageBundle [NSBundle bundleWithBundleName:@"ImageBundle.bundle" podName:@"fltbdface"]

@interface BDFaceBaseViewController () <CaptureDataOutputProtocol>
@property (nonatomic, readwrite, retain) BDFaceVideoCaptureDevice *videoCapture;
@property (nonatomic, readwrite, retain) UILabel *remindLabel;
@property (nonatomic, readwrite, retain) UIImageView *voiceImageView;
@property (nonatomic, readwrite, retain) BDFaceRemindView * remindView;
@property (nonatomic, readwrite, retain) UILabel * remindDetailLabel;

// 超时相关控件
@property (nonatomic, readwrite, retain) UIView *timeOutMainView;
@property (nonatomic, readwrite, retain) UIImageView *timeOutImageView;
@property (nonatomic, readwrite, retain) UILabel *timeOutLabel;
@property (nonatomic, readwrite, retain) UIView *timeOutLine;
@property (nonatomic, readwrite, retain) UIButton *timeOutRestartButton;
@property (nonatomic, readwrite, retain) UILabel *timeOutRestartLabel;
@property (nonatomic, readwrite, retain) UIView *timeOutLine2;
@property (nonatomic, readwrite, retain) UIButton *timeOutRestartButton2;
@property (nonatomic, readwrite, retain) UILabel *timeOutBackToMainLabel2;



@end

@implementation BDFaceBaseViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) setHasFinished:(BOOL)hasFinished {
    _hasFinished = hasFinished;
    if (hasFinished) {
        [self.videoCapture stopSession];
        self.videoCapture.delegate = nil;
    }
}

- (void)warningStatus:(WarningStatus)status warning:(NSString *)warning
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (status == PoseStatus) {
            [weakSelf.remindLabel setHidden:true];
            [weakSelf.remindView setHidden:false];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
        }else if (status == occlusionStatus) {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:false];
            weakSelf.remindDetailLabel.text = warning;
            weakSelf.remindLabel.text = @"脸部有遮挡";
        }else {
            [weakSelf.remindLabel setHidden:false];
            [weakSelf.remindView setHidden:true];
            [weakSelf.remindDetailLabel setHidden:true];
            weakSelf.remindLabel.text = warning;
        }
    });
}

- (void)singleActionSuccess:(BOOL)success
{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (success) {
            
        }else {
            
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 用于播放视频流
    if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) {
        self.detectRect = CGRectMake(ScreenWidth*(1-scaleValueX)/2.0, ScreenHeight*(1-scaleValueX)/2.0, ScreenWidth*scaleValueX, ScreenHeight*scaleValueX);
    } else {
        self.detectRect = CGRectMake(ScreenWidth*(1-scaleValue)/2.0, ScreenHeight*(1-scaleValue)/2.0, ScreenWidth*scaleValue, ScreenHeight*scaleValue);
    }
    
    // 超时的view初始化，但是不添加到当前view内
    // 超时的最底层view，大小和屏幕大小一致，为了突出弹窗的view的效果，背景为灰色，0.7的透视度
    _timeOutMainView = [[UIView alloc] init];
    _timeOutMainView.frame = ScreenRect;
    _timeOutMainView.alpha = 0.7;
    _timeOutMainView.backgroundColor = [UIColor grayColor];
    
    // 弹出的主体view
    self.timeOutView = [[UIView alloc] init];
    self.timeOutView.frame = CGRectMake((ScreenWidth-320) / 2, 179.3, 320, 281.3);
    self.timeOutView.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];
    
    // 超时的image
    _timeOutImageView = [[UIImageView alloc] init];
    _timeOutImageView.frame = CGRectMake((ScreenWidth-76) / 2, 217.3, 76, 76);
    
    NSString* imagePath = [ImageBundle pathForResource:@"icon_overtime" ofType:@"png"];
    _timeOutImageView.image = [[UIImage alloc] initWithContentsOfFile:imagePath];
//    _timeOutImageView.image = [UIImage imageNamed:@"icon_overtime"];
    
    // 超时的label
    _timeOutLabel = [[UILabel alloc] init];
    _timeOutLabel.frame = CGRectMake((ScreenWidth-160) / 2, 309.3, 160, 22);
    _timeOutLabel.text = @"检测超时，请按照提示重试";
    _timeOutLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    
    // 区分线
    _timeOutLine = [[UIView alloc] init];
    _timeOutLine.frame = CGRectMake((ScreenWidth-320) / 2, 361.2, 320, 0.3);
    _timeOutLine.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];

    
    // 重新开始采集button
    _timeOutRestartButton = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-320)/2, 376, 320, 18)];
    [_timeOutRestartButton addTarget:self action:@selector(reStart:) forControlEvents:UIControlEventTouchUpInside];
    
    // 重新采集的文字label
    _timeOutRestartLabel = [[UILabel alloc] init];
    _timeOutRestartLabel.frame = CGRectMake((ScreenWidth-72) / 2, 376.3, 72, 18);
    _timeOutRestartLabel.text = @"重新采集";
    _timeOutRestartLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutRestartLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:186 / 255.0 blue:242 / 255.0 alpha:1 / 1.0];
    
    // 区分线
    _timeOutLine2 = [[UIView alloc] init];
    _timeOutLine2.frame = CGRectMake((ScreenWidth-320) / 2, 409.2, 320, 0.3);
    _timeOutLine2.backgroundColor = [UIColor colorWithRed:255 / 255.0 green:255 / 255.0 blue:255 / 255.0 alpha:1 / 1.0];

    
    // 回到首页的button
    _timeOutRestartButton2 = [[UIButton alloc] initWithFrame:CGRectMake((ScreenWidth-320)/2, 424, 320, 18)];
    [_timeOutRestartButton2 addTarget:self action:@selector(backToPreView:) forControlEvents:UIControlEventTouchUpInside];
    
    // 回到首页的label
    _timeOutBackToMainLabel2 = [[UILabel alloc] init];
    _timeOutBackToMainLabel2.frame = CGRectMake((ScreenWidth-72) / 2, 424.3, 72, 18);
    _timeOutBackToMainLabel2.text = @"回到首页";
    _timeOutBackToMainLabel2.font = [UIFont fontWithName:@"PingFangSC-Medium" size:18];
    _timeOutBackToMainLabel2.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    
    // 初始化相机处理类
    self.videoCapture = [[BDFaceVideoCaptureDevice alloc] init];
    self.videoCapture.delegate = self;
    
    // 用于展示视频流的imageview
    self.displayImageView = [[UIImageView alloc] initWithFrame:self.detectRect];
    self.displayImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.displayImageView];
    
    // 画圈和圆形遮罩
    CGRect circleRect =CGRectMake(CGRectGetMidX(self.detectRect) - self.detectRect.size.width / 2, 175, self.detectRect.size.width, self.detectRect.size.width);
    
    if (IS_IPHONE_X || IS_IPHONE_Xr || IS_IPHONE_Xs || IS_IPHONE_Xs_Max) {
        self.previewRect = CGRectMake(circleRect.origin.x - circleRect.size.width*(1/scaleValueX-1)/2.0, circleRect.origin.y - circleRect.size.height*(1/scaleValueX-1)/2.0, circleRect.size.width/scaleValueX, circleRect.size.height/scaleValueX);
    } else {
        self.previewRect = CGRectMake(circleRect.origin.x - circleRect.size.width*(1/scaleValue-1)/2.0, circleRect.origin.y - circleRect.size.height*(1/scaleValue-1)/2.0, circleRect.size.width/scaleValue, circleRect.size.height/scaleValue);
    }
   
    CGPoint centerPoint = CGPointMake(CGRectGetMinX(self.detectRect) + self.detectRect.size.width / 2, 175 + self.detectRect.size.width / 2);
    //创建一个View
    UIView *maskView = [[UIView alloc] initWithFrame:ScreenRect];
    maskView.backgroundColor = [UIColor whiteColor];
    maskView.alpha = 1;
    [self.view addSubview:maskView];
    //贝塞尔曲线 画一个带有圆角的矩形
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRoundedRect:ScreenRect cornerRadius:0];
    //贝塞尔曲线 画一个圆形
    [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:centerPoint radius:self.detectRect.size.width / 2 startAngle:0 endAngle:2 * M_PI clockwise:NO]];
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
    // 添加图层蒙板
    maskView.layer.mask = shapeLayer;
    
    // 进度条view，活体检测页面
    CGRect circleProgressRect =  CGRectMake(CGRectGetMinX(circleRect) - 13.7, CGRectGetMinY(circleRect) - 13.7, CGRectGetWidth(circleRect) + (13.7 * 2), CGRectGetHeight(circleRect) + (13.7 * 2));
    self.circleProgressView = [[BDFaceCycleProgressView alloc] initWithFrame:circleProgressRect];
    
    // 动作活体动画
    self.remindAnimationView = [[BDFaceRemindAnimationView alloc] initWithFrame:circleRect];
    
    // 提示框（动作）
    self.remindLabel = [[UILabel alloc] init];
    self.remindLabel.frame = CGRectMake(0, 103.3, ScreenWidth, 22);
    self.remindLabel.textAlignment = NSTextAlignmentCenter;
    self.remindLabel.textColor = [UIColor colorWithRed:0 / 255.0 green:0 / 255.0 blue:0 / 255.0 alpha:1 / 1.0];
    self.remindLabel.font = [UIFont boldSystemFontOfSize:22];
    [self.view addSubview:self.remindLabel];
    
    // 提示label（遮挡等问题）
    self.remindDetailLabel = [[UILabel alloc] init];
    self.remindDetailLabel.frame = CGRectMake(0, 139.3, ScreenWidth, 16);
    self.remindDetailLabel.font = [UIFont systemFontOfSize:16];
    self.remindDetailLabel.textColor = [UIColor colorWithRed:102 / 255.0 green:102 / 255.0 blue:102 / 255.0 alpha:1 / 1.0];
    self.remindDetailLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.remindDetailLabel];
    [self.remindDetailLabel setHidden:true];
    
    UIButton *backButton = [[UIButton alloc] init];
    backButton.frame = CGRectMake(23.3, 43.3, 20, 20);
    [backButton setImage:[[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"icon_titlebar_close" ofType:@"png"]] forState:UIControlStateNormal];
    [backButton setTitle:@"关闭" forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backButton];
    
    // 音量imageView，可动态播放图片
    _voiceImageView = [[UIImageView alloc] init];
    _voiceImageView.frame = CGRectMake((ScreenWidth-22-20), 42.7, 22, 22);
    _voiceImageView.animationImages = [NSArray arrayWithObjects:
                                       [[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"icon_titlebar_voice1" ofType:@"png"]],
                                       [[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"icon_titlebar_voice2" ofType:@"png"]],nil];
    _voiceImageView.animationDuration = 2;
    _voiceImageView.animationRepeatCount = 0;
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    if (soundMode.boolValue){
        [_voiceImageView startAnimating];
    } else {
        _voiceImageView.image = [[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"icon_titlebar_voice_close" ofType:@"png"]];
    }
    _voiceImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *changeVoidceSet = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(changeVoidceSet:)];
    [_voiceImageView addGestureRecognizer:changeVoidceSet];
    [self.view addSubview:_voiceImageView];
    
    // 底部logo部分
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.frame = CGRectMake(0, CGRectGetMaxY(self.view.frame) - 221, ScreenWidth, 221);
//    logoImageView.image = [UIImage imageNamed:@"bg_bottom_pattern"];
    logoImageView.image = [[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"bg_bottom_pattern" ofType:@"png"]];
    [self.view addSubview:logoImageView];
    
    // 设置logo，底部的位置和大小，实例化显示
    BDFaceLogoView* logoView = [[BDFaceLogoView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-15-12), ScreenWidth, 12)];
    [self.view addSubview:logoView];
    
    // 监听重新返回APP
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppWillResignAction) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAppBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
//    UIImageView* circleImage= [[UIImageView alloc]init];
//    circleImage = [self creatRectangle:circleImage withRect:circleRect];
//    [self.view addSubview:circleImage];

//    UIImageView* previewImage= [[UIImageView alloc]init];
//    previewImage = [self creatRectangle:previewImage withRect:self.previewRect];
//    [self.view addSubview:previewImage];
//
//    UIImageView* detectImage= [[UIImageView alloc]init];
//    detectImage = [self creatRectangle:detectImage withRect:self.detectRect];
//    [self.view addSubview:detectImage];
//
//    CGRect _minRect = CGRectMake(CGRectGetMinX(self.previewRect)+115, CGRectGetMinY(self.previewRect)+115, CGRectGetWidth(self.previewRect)-230, CGRectGetHeight(self.previewRect)-230);
//
//    UIImageView* minImage= [[UIImageView alloc]init];
//    minImage = [self creatRectangle:minImage withRect:_minRect];
//    [self.view addSubview:minImage];
}
#pragma mark-绘框方法
- (UIImageView *)creatRectangle:(UIImageView *)imageView withRect:(CGRect) rect{
    
    CAShapeLayer *lineLayer = [CAShapeLayer layer];
    //创建需要画线的视图
    UIBezierPath *linePath = [UIBezierPath bezierPath];
    //起点
    float x = rect.origin.x;
    float y = rect.origin.y;
    float W = rect.size.width;
    float H = rect.size.height;
    [linePath moveToPoint:CGPointMake(x, y)];
    //其他点
    [linePath addLineToPoint:CGPointMake(x + W, y)];
    [linePath addLineToPoint:CGPointMake(x + W, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y + H)];
    [linePath addLineToPoint:CGPointMake(x, y)];
    lineLayer.lineWidth = 2;
    lineLayer.strokeColor = [UIColor redColor].CGColor;
    lineLayer.path = linePath.CGPath;
    lineLayer.fillColor = nil; // 默认为blackColor
    [imageView.layer addSublayer:lineLayer];
    return imageView;
}
- (void)isTimeOut:(BOOL)isOrNot {
    if (isOrNot){
        // 加载超时的view
        [self outTimeViewLoad];
    }
}

- (void)outTimeViewLoad{
    
    // 显示超时view，并停止视频流工作
    self.remindLabel.text = @"";
    self.remindDetailLabel.text = @"";
    self.videoCapture.runningStatus = NO;
    [self.videoCapture stopSession];
    [self.view addSubview:_timeOutMainView];
    [self.view addSubview:_timeOutView];
    [self.view addSubview:_timeOutImageView];
    [self.view addSubview:_timeOutLabel];
    [self.view addSubview:_timeOutRestartButton];
    [self.view addSubview:_timeOutLine];
    [self.view addSubview:_timeOutRestartLabel];
    [self.view addSubview:_timeOutLine2];
    [self.view addSubview:_timeOutRestartButton2];
    [self.view addSubview:_timeOutBackToMainLabel2];
}

- (void)outTimeViewUnload{
    
    // 关闭超时的view，恢复视频流工作
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
    [_timeOutMainView removeFromSuperview];
    [_timeOutView removeFromSuperview];
    [_timeOutImageView removeFromSuperview];
    [_timeOutLabel removeFromSuperview];
    [_timeOutRestartButton removeFromSuperview];
    [_timeOutLine removeFromSuperview];
    [_timeOutRestartLabel removeFromSuperview];
    [_timeOutLine2 removeFromSuperview];
    [_timeOutBackToMainLabel2 removeFromSuperview];
    [_timeOutRestartButton2 removeFromSuperview];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.hasFinished = YES;
    self.videoCapture.runningStatus = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _hasFinished = NO;
    self.videoCapture.runningStatus = YES;
    [self.videoCapture startSession];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)faceProcesss:(UIImage *)image {
}

- (void)closeAction {
    _hasFinished = YES;
    self.videoCapture.runningStatus = NO;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - ButtonFunction
- (IBAction)reStart:(UIButton *)sender{
    // 对应页面去补充
    dispatch_async(dispatch_get_main_queue(), ^{
        [self outTimeViewUnload];
    });
    // 调用相应的部分设置
    [self selfReplayFunction];
    
}

- (void)selfReplayFunction{
    // 相应的功能在采集/检测时候写
}

- (IBAction)backToPreView:(UIButton *)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Notification

- (void)onAppWillResignAction {
    _hasFinished = YES;
}

- (void)onAppBecomeActive {
    _hasFinished = NO;
}


#pragma mark - voiceImageView tap
- (void)changeVoidceSet:(UITapGestureRecognizer *)sender {
    NSNumber *soundMode = [[NSUserDefaults standardUserDefaults] objectForKey:@"SoundMode"];
    NSLog(@"点击");
    if (soundMode.boolValue && _voiceImageView.animating) {
        [_voiceImageView stopAnimating];
        _voiceImageView.image = [[UIImage alloc] initWithContentsOfFile:[ImageBundle pathForResource:@"icon_titlebar_voice_close" ofType:@"png"]];
        // 之前是开启的，点击后关闭
        [[NSUserDefaults standardUserDefaults] setObject:@(NO) forKey:@"SoundMode"];
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = NO;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = NO;
    } else {
        [_voiceImageView startAnimating];
        [[NSUserDefaults standardUserDefaults] setObject:@(YES) forKey:@"SoundMode"];
        // 活体声音
        [IDLFaceLivenessManager sharedInstance].enableSound  = YES;
        // 图像采集声音
        [IDLFaceDetectionManager sharedInstance].enableSound = YES;
    }
}

#pragma mark - CaptureDataOutputProtocol

- (void)captureOutputSampleBuffer:(UIImage *)image {
    if (_hasFinished) {
        return;
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.displayImageView.image = image;
    });
    [self faceProcesss:image];
}

- (void)captureError {
    NSString *errorStr = @"出现未知错误，请检查相机设置";
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        errorStr = @"相机权限受限,请在设置中启用";
    }
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道啦" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            NSLog(@"知道啦");
        }];
        [alert addAction:action];
        UIViewController* fatherViewController = weakSelf.presentingViewController;
        [weakSelf dismissViewControllerAnimated:YES completion:^{
            [fatherViewController presentViewController:alert animated:YES completion:nil];
        }];
    });
}
@end
