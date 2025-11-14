//
//  BDFaceLog.h
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/9.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

@interface BDFaceLog : NSObject

+ (void)makeLogAfterFinishRecognizeAction:(BOOL)success;

@end

NS_ASSUME_NONNULL_END
