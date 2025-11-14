//
//  BDFaceImageShow.h
//  FaceSDKSample_IOS
//
//  Created by 孙明喆 on 2020/4/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVKit/AVKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BDFaceImageShow : NSObject

@property (nonatomic, readwrite) UIImage *successImage;

@property (nonatomic,assign) float silentliveScore;

+ (instancetype)sharedInstance;

- (void)setSuccessImage:(UIImage *)image;

- (void)setSilentliveScore:(float)score;

- (UIImage *)getSuccessImage;

- (float)getSilentliveScore;

- (void) reset;

@end

NS_ASSUME_NONNULL_END
