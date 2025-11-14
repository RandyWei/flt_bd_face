//
//  BDFaceAdjustParamsFileManager.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/1.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAdjustParamsFileManager.h"
#import "BDFaceAdjustParams.h"
#import "BDFaceCalculateTool.h"
#import "BDFaceAdjustParams.h"
#import "BDFaceAdjustParamsTool.h"

static NSString *const BDFaceAdjustConfigFileName = @"BDFaceParamsConfig";
static NSString *const BDFaceAdjustConfigFileSurfix = @"json";
static NSString *const BDFaceAdjustConfigCustomFileName = @"BDFaceParamsConfigCache.plist";
static NSString *const BDFaceAjustParamsNormalPageJsonKey = @"normal";
static NSString *const BDFaceAjustParamsLoosePageJsonKey = @"loose";
static NSString *const BDFaceAjustParamsStrictPageJsonKey = @"strict";

static NSString *const BDFaceParamsConfigCacheForCustomConfigDicKey = @"BDFaceParamsConfigCacheForCustomConfigDicKey"; /// 保存的自定义参数的key

static NSString *const BDFaceParamsConfigCacheForUserSelectKey = @"BDFaceParamsConfigCacheForUserSelectKey"; /// select key


@interface BDFaceAdjustParamsFileManager()

@end

@implementation BDFaceAdjustParamsFileManager

+ (instancetype)sharedInstance {
    static BDFaceAdjustParamsFileManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[BDFaceAdjustParamsFileManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self loadConfigFile];
        [self readCustomCongfig];
        [self createCachePlist];
    }
    return self;
}

/// 读取配置文件
- (void)loadConfigFile {
    NSString *path = [[NSBundle mainBundle] pathForResource:BDFaceAdjustConfigFileName ofType:BDFaceAdjustConfigFileSurfix];
    NSDictionary *dic = nil;

    @try {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (dic && [dic isKindOfClass:[NSDictionary class]]) {
            NSDictionary *normal = dic[BDFaceAjustParamsNormalPageJsonKey];
            NSDictionary *loose = dic[BDFaceAjustParamsLoosePageJsonKey];
            NSDictionary *strict = dic[BDFaceAjustParamsStrictPageJsonKey];
            _normalConfig = [[BDFaceAdjustParams alloc] initWithDic:normal];
            _looseConfig = [[BDFaceAdjustParams alloc] initWithDic:loose];
            _strictConfig = [[BDFaceAdjustParams alloc] initWithDic:strict];
        }
    }@catch (NSException *exception) {
        dic = nil;
        _normalConfig = nil;
        _looseConfig = nil;
        _strictConfig = nil;
    } @finally {
        
    }
}

/// 创建缓存文件
- (void)createCachePlist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSMutableDictionary *desDic;
    NSString *path = [self.class cacheConfigFilePath];
    if (![fileManager fileExistsAtPath:path]) {
        desDic = [[NSMutableDictionary alloc] init];
        [desDic writeToFile:path atomically:YES];
    }
}

+ (NSString *)cacheConfigFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:BDFaceAdjustConfigCustomFileName];
    return path;
}

- (NSString *)numberString:(float)value {
    NSString *str = [NSString stringWithFormat:@"%0.2f", value];
    return [NSString stringWithFormat:@"%@", @(str.floatValue)];
}

- (void)setSelectType:(BDFaceSelectType)selectType {
    if (_selectType != selectType) {
        _selectType = selectType;
        [self saveUserSelection:selectType];
    }
}

- (BDFaceAdjustParams *)readCustomCongfig {
    BDFaceAdjustParams *config = nil;
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self.class cacheConfigFilePath]];
    if ([BDFaceCalculateTool noNullDic:dic]) {
        NSDictionary *customDic = dic[BDFaceParamsConfigCacheForCustomConfigDicKey];
        if ([BDFaceCalculateTool noNullDic:customDic]) {
            config = [[BDFaceAdjustParams alloc] initWithDic:customDic];
        }
    }
    if (config == nil) {
        config = [self.normalConfig copy];
    }
    _customConfig = config;
    return config;
}

/// 持久化自定义文件
- (void)saveToCustomConfigFile:(BDFaceAdjustParams *)config {
    _customConfig = [config copy];
    NSDictionary *dic = config.toDic;
    [self createCachePlist];
    NSDictionary *beforeDic = [[NSDictionary alloc] initWithContentsOfFile:[self.class cacheConfigFilePath]];
    NSMutableDictionary *muDic = nil;
    if (beforeDic) {
        muDic = [NSMutableDictionary dictionaryWithDictionary:beforeDic];
        [muDic setValue:dic forKey:BDFaceParamsConfigCacheForCustomConfigDicKey];
    } else {
        muDic = [NSMutableDictionary dictionary];
        [muDic setValue:dic forKey:BDFaceParamsConfigCacheForCustomConfigDicKey];
    }
    if ([BDFaceCalculateTool noNullDic:muDic]) {
        @try {
            [muDic writeToFile:[self.class cacheConfigFilePath] atomically:NO];
        } @catch (NSException *exception) {
            [muDic writeToFile:[self.class cacheConfigFilePath] atomically:YES];
        } @finally {
            
        }
        
    }
}

+ (BDFaceSelectType)readCacheSelect {
    NSString *select = nil;
    BDFaceSelectType selectType;
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self.class cacheConfigFilePath]];
    if ([BDFaceCalculateTool noNullDic:dic]) {
        select = dic[BDFaceParamsConfigCacheForUserSelectKey];
    }
    if (select) {
        selectType = select.integerValue;
    } else {
        selectType = BDFaceSelectTypeNormal;
    }
    return selectType;
}

+ (NSString *)currentSelectionText {
    BDFaceSelectType type = [BDFaceAdjustParamsFileManager readCacheSelect];
    NSString *text = @"";
    switch (type) {
        case BDFaceSelectTypeLoose:
        {
            text = @"宽松";
        }
            break;
        case BDFaceSelectTypeNormal:
        {
            text = @"正常";
        }
            break;
        case BDFaceSelectTypeStrict:
        {
            text = @"严格";
        }
            break;
        case BDFaceSelectTypeCustom:
        {
            text = @"自定义";
        }
            break;
            
        default:
            break;
    }
    return text;
}

- (void)saveUserSelection:(BDFaceSelectType)select {
    [self createCachePlist];
    NSDictionary *dic = [[NSDictionary alloc] initWithContentsOfFile:[self.class cacheConfigFilePath]];
    NSMutableDictionary *muDic = nil;
    if (dic) {
        muDic = [NSMutableDictionary dictionaryWithDictionary:dic];
        [muDic setValue:[NSString stringWithFormat:@"%d", (int)select] forKey:BDFaceParamsConfigCacheForUserSelectKey];
    } else {
        muDic = [NSMutableDictionary dictionary];
        [muDic setValue:[NSString stringWithFormat:@"%d", (int)select] forKey:BDFaceParamsConfigCacheForUserSelectKey];
    }
    if ([BDFaceCalculateTool noNullDic:muDic]) {
        [muDic writeToFile:[self.class cacheConfigFilePath] atomically:YES];
    }
}

- (BDFaceAdjustParams *)configBySelection:(BDFaceSelectType)type {
    BDFaceAdjustParams *params = [BDFaceAdjustParamsFileManager sharedInstance].normalConfig;
    switch (type) {
        case BDFaceSelectTypeLoose:
        {
            params = self.looseConfig;
        }
            break;
        case BDFaceSelectTypeStrict:
        {
            params = self.strictConfig;
        }
            break;
        case BDFaceSelectTypeCustom:
        {
            params = self.customConfig;
        }
            break;
            
        default:
            break;
    }
    return params;
}

@end
