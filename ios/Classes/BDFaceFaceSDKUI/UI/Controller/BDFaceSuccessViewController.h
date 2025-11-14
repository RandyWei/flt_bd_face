//
//  BDFaceSuccessViewController.h
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/3/12.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceSuccessViewController : UIViewController

@property (nonatomic, readwrite, retain) UIImage *successImage;

- (void)setSuccessImage:(UIImage * _Nonnull)successImage;

@end

NS_ASSUME_NONNULL_END
