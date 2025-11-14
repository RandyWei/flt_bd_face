//
//  BDFaceLog.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/9.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceLog.h"
#import <UIKit/UIKit.h>
#import "BDFaceDevice.h"

static NSString *urlStr = @"https://brain.baidu.com/record/api";

@implementation BDFaceLog

+ (void)makeLogAfterFinishRecognizeAction:(BOOL)success {
    NSMutableDictionary *dic = [self wrapDic:success];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    [request setHTTPMethod:@"POST"];
    [request setURL:url];
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:jsonData];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (error) {
            if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
                NSLog(@"HTTP Error: %d %@", (int)httpResponse.statusCode, error);
                return;
            }
            NSLog(@"Error %@", error);
            return;
        }
        if (receivedData) {
            NSString *responeString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
            NSLog(@"%@", responeString);
        }
    });
}

+(NSMutableDictionary *)wrapDic:(BOOL)success {
    NSMutableDictionary *dataDic = [NSMutableDictionary dictionary];
    NSString *bundleId = [self getBundleID];
    NSString *versionStr = @"4.1.0.0";
    NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
    NSString *osString = [[UIDevice currentDevice] systemName];
    NSString *imei = [UIDevice currentDevice].identifierForVendor.UUIDString;
    NSString *device = [BDFaceDevice deviceName];
    NSString *finish = success ? @"1" : @"2";
    [dataDic setObject:@"faceprint" forKey:@"scene"];
    [dataDic setObject:bundleId ? bundleId : @"" forKey:@"appid"];
    [dataDic setObject:finish ? finish : @"" forKey:@"finish"];
    [dataDic setObject:@"facesdk" forKey:@"type"];
    [dataDic setObject:@"iphone" forKey:@"device"];
    [dataDic setObject:@"1" forKey:@"isliving"];
    [dataDic setObject:osString ? osString : @"" forKey:@"os"];
    [dataDic setObject:device ? device : @"" forKey:@"device"];
    [dataDic setObject:imei ? imei : @"" forKey:@"imei"];
    [dataDic setObject:versionStr ? versionStr : @"" forKey:@"version"];
    [dataDic setObject:systemVersion ? systemVersion : @"" forKey:@"system"];
    
    NSDate *date  = [NSDate date];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *calendarComps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond|NSCalendarUnitWeekOfYear|NSCalendarUnitWeekday fromDate:date];
    NSString *year = [NSString stringWithFormat:@"%ld", (long)calendarComps.year];
    NSString *month = [NSString stringWithFormat:@"%ld", (long)calendarComps.month];
    NSString *day = [NSString stringWithFormat:@"%ld", (long)calendarComps.day];
    NSString *hour = [NSString stringWithFormat:@"%ld", (long)calendarComps.hour];
    [dataDic setObject:year forKey:@"year"];
    [dataDic setObject:month forKey:@"month"];
    [dataDic setObject:day forKey:@"day"];
    [dataDic setObject:hour forKey:@"hour"];
    
    NSMutableArray *array = [NSMutableArray array];
    [array addObject:dataDic];
    
    NSMutableDictionary *desDic = [NSMutableDictionary dictionary];
    [desDic setObject:array forKey:@"dt"];
    [desDic setObject:@"faceSdkStatistic" forKey:@"mh"];
    return desDic;
}

+(NSString*)getBundleID {
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
}


@end
