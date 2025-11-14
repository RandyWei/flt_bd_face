//
//  BDFaceAdjustParams.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParams.h"
#import "BDFaceAdjustParamsConstants.h"

@implementation BDFaceAdjustParams

- (instancetype)initWithJson:(NSString *)json {
    BDFaceAdjustParams *des = nil;
    NSDictionary *dic = nil;
    @try {
        if (json && [json isKindOfClass:[NSString class]]) {
            NSData *data = [json dataUsingEncoding:NSUTF8StringEncoding];
            if (data) {
               dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            }
        }
        if (dic) {
           des = [self initWithDic:dic];
        }
    } @catch (NSException *exception) {
        des = nil;
    } @finally {
        // do nothing
    }
    return des;
}

- (BOOL)compareToParams:(BDFaceAdjustParams *)obj {
    if (!obj) {
        return NO;
    }
    if (self == obj) {
        return NO;
    }
    if (self.minLightIntensity == obj.minLightIntensity
        && self.maxLightIntensity == obj.maxLightIntensity
        && self.ambiguity == obj.ambiguity
        && self.leftEyeOcclusion == obj.leftEyeOcclusion
        && self.rightEyeOcclusion == obj.rightEyeOcclusion
        && self.noseOcclusion == obj.noseOcclusion
        && self.mouthOcclusion == obj.mouthOcclusion
        && self.leftFaceOcclusion == obj.leftFaceOcclusion
        && self.rightFaceOcclusion == obj.rightFaceOcclusion
        && self.lowerJawOcclusion == obj.lowerJawOcclusion
        && self.upAndDownAngle == obj.upAndDownAngle
        && self.leftAndRightAngle == obj.leftAndRightAngle
        && self.spinAngle == obj.spinAngle) {
        return YES;
    } else {
        return NO;
    }
}

- (id)copyWithZone:(nullable NSZone *)zone {
    BDFaceAdjustParams *another = [[BDFaceAdjustParams alloc] init];
    another.minLightIntensity = self.minLightIntensity;
    another.maxLightIntensity = self.maxLightIntensity;
    another.ambiguity = self.ambiguity;
    
    another.leftEyeOcclusion = self.leftEyeOcclusion;
    another.rightEyeOcclusion =  self.rightEyeOcclusion;
    another.noseOcclusion = self.noseOcclusion;
    another.mouthOcclusion = self.mouthOcclusion;
    another.leftFaceOcclusion = self.leftFaceOcclusion;
    another.rightFaceOcclusion = self.rightFaceOcclusion;
    another.lowerJawOcclusion = self.lowerJawOcclusion;
    
    another.upAndDownAngle = self.upAndDownAngle;
    another.leftAndRightAngle = self.leftAndRightAngle;
    another.spinAngle = self.spinAngle;
    return another;
}

- (instancetype)initWithDic:(NSDictionary *)dic {
    if (!dic) {
        return nil;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    if (dic.allKeys.count == 0) {
        return nil;
    }
    BDFaceAdjustParams *des = [super init];
    des.minLightIntensity = [self getIntValue:dic key:minLightIntensityKey];
    des.maxLightIntensity = [self getIntValue:dic key:maxLightIntensityKey];
    des.ambiguity = [self getFloatValue:dic key:ambiguityKey];
    des.leftEyeOcclusion = [self getFloatValue:dic key:leftEyeOcclusionKey];
    des.rightEyeOcclusion = [self getFloatValue:dic key:rightEyeOcclusionKey];
    des.noseOcclusion = [self getFloatValue:dic key:noseOcclusionKey];
    des.mouthOcclusion = [self getFloatValue:dic key:mouthOcclusionKey];
    des.leftFaceOcclusion = [self getFloatValue:dic key:leftFaceOcclusionKey];
    des.rightFaceOcclusion = [self getFloatValue:dic key:rightFaceOcclusionKey];
    des.lowerJawOcclusion = [self getFloatValue:dic key:lowerJawOcclusionKey];
    des.upAndDownAngle = [self getFloatValue:dic key:upAndDownAngleKey];
    des.leftAndRightAngle = [self getFloatValue:dic key:leftAndRightAngleKey];
    des.spinAngle = [self getFloatValue:dic key:spinAngleKey];
    return des;
}

- (float)getFloatValue:(NSDictionary *)dic key:(NSString *)key {
    if (!dic) {
        return 0;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    if (![key isKindOfClass:[NSString class]]) {
        return 0;
    }
    NSString *value = dic[key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return value.floatValue;
    }
    return 0.0f;
}

- (NSInteger)getIntValue:(NSDictionary *)dic key:(NSString *)key  {
    if (!dic) {
        return 0;
    }
    if (![dic isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    if (![key isKindOfClass:[NSString class]]) {
        return 0;
    }
    NSString *value = dic[key];
    if (value && [value isKindOfClass:[NSNumber class]]) {
        return value.integerValue;
    }
    return 0;
}

- (NSDictionary *)toDic {
    NSDictionary *dic = nil;
    @try {
        dic = @{minLightIntensityKey : [self toNumber:self.minLightIntensity],
                maxLightIntensityKey : [self toNumber:self.maxLightIntensity],
                ambiguityKey : [self toNumber:self.ambiguity],
                leftEyeOcclusionKey : [self toNumber:self.leftEyeOcclusion],
                rightEyeOcclusionKey : [self toNumber:self.rightEyeOcclusion],
                noseOcclusionKey : [self toNumber:self.noseOcclusion],
                mouthOcclusionKey : [self toNumber:self.mouthOcclusion],
                leftFaceOcclusionKey : [self toNumber:self.leftFaceOcclusion],
                rightFaceOcclusionKey : [self toNumber:self.rightFaceOcclusion],
                lowerJawOcclusionKey : [self toNumber:self.lowerJawOcclusion],
                upAndDownAngleKey : [self toNumber:self.upAndDownAngle],
                leftAndRightAngleKey : [self toNumber:self.leftAndRightAngle],
                spinAngleKey : [self toNumber:self.spinAngle],
        };
    } @catch (NSException *exception) {
        dic = nil;
    } @finally {
    }
    return dic;
}

- (NSNumber *)toNumber:(float)value {
    NSString *str = [NSString stringWithFormat:@"%0.2f", value];
    return @(str.floatValue);
}

- (NSString *)description {
    NSString *content1 = [NSString stringWithFormat:@"content: minLightIntensity: %f, maxLightIntensity: %f, ambiguity:%f", (float)self.minLightIntensity, (float)self.maxLightIntensity, self.ambiguity];
    NSString *content2 = [NSString stringWithFormat:@"content: :leftEyeOcclusion: %f, rightEyeOcclusion: %f,noseOcclusion :%f", (float)self.leftEyeOcclusion, (float)self.rightEyeOcclusion, (float)self.noseOcclusion];
    NSString *content3 = [NSString stringWithFormat:@"content: :mouthOcclusion: %f, leftFaceOcclusion: %f,rightFaceOcclusion :%f; lowerJawOcclusion: %f", (float)self.mouthOcclusion, (float)self.leftFaceOcclusion, self.rightFaceOcclusion, self.lowerJawOcclusion];
    NSString *content4 = [NSString stringWithFormat:@"content: :upAndDownAngle: %f, :leftAndRightAngle %f,spinAngle :%f", (float)self.upAndDownAngle, (float)self.leftAndRightAngle, (float)self.spinAngle];
    NSString *value = [NSString stringWithFormat:@"%@%@%@%@", content1, content2, content3, content4];
    return value;
}

@end
