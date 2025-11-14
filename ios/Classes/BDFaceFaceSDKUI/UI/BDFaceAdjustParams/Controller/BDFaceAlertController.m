//
//  BDFaceAlertViewController.m
//  FaceSDKSample_IOS
//
//  Created by Zhang,Jian(MBD) on 2020/12/7.
//  Copyright © 2020 Baidu. All rights reserved.
//

#import "BDFaceAlertController.h"

@interface BDFaceAlertController()

@property(nonatomic, strong) NSArray *lightStringArray;
@property(nonatomic, copy) NSString *boldString;

@end

@implementation BDFaceAlertController


- (void)changeTextToBold:(NSString *)string {
    self.boldString = string;
}
- (void)changeTextToLight:(NSArray *)array {
    self.lightStringArray = array;
}

- (void)viewDidLayoutSubviews {
    NSMutableArray *array = [NSMutableArray array];
    [self findView:self.view array:array];
    
    for (UILabel *label in array) {
        if ([label.text isEqualToString:_boldString]) {
            label.font = [UIFont boldSystemFontOfSize:label.font.pointSize];
        }
        for (NSString *eachLight in self.lightStringArray) {
            if ([eachLight isEqualToString:label.text]) {
                label.font = [UIFont systemFontOfSize:label.font.pointSize];
            }
        }
    }
}

- (void)findView:(UIView *)view array:(NSMutableArray *)array {
    for (UIView *each in view.subviews) {
        if ([each isKindOfClass:[UILabel class]]) {
            [array addObject:each];
        }
        [self findView:each array:array];
    }
    
}


@end
