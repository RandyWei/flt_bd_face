//
//  LivenessViewController.h
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceBaseViewController.h"

@interface BDFaceLivenessViewController : BDFaceBaseViewController

@property(nonatomic, copy) void(^resultHandler)(NSString *);

- (void)livenesswithList:(NSArray *)livenessArray order:(BOOL)order numberOfLiveness:(NSInteger)numberOfLiveness;

@end
