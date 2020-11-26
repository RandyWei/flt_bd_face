//
//  BDFaceLivingConfigModel.m
//  FaceSDKSample_IOS
//
//  Created by 阿凡树 on 2017/5/23.
//  Copyright © 2017年 Baidu. All rights reserved.
//

#import "BDFaceLivingConfigModel.h"
@interface BDFaceLivingConfigModel ()

@end
@implementation BDFaceLivingConfigModel

- (instancetype)init {
    if (self = [super init]) {
        _liveActionArray = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static BDFaceLivingConfigModel *_model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _model=[[BDFaceLivingConfigModel alloc] init];
    });
    return _model;
}

- (void)resetState {
    [_liveActionArray removeAllObjects];
    _isByOrder = false;
    _numOfLiveness = 0;
}

@end
