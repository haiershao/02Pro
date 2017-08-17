//
//  JDYFinishAlertView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/14.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYFinishAlertView.h"

@implementation JDYFinishAlertView

+ (instancetype)finishAlertView{

    return [[[NSBundle mainBundle] loadNibNamed:@"JDYFinishAlertView" owner:self options:nil] lastObject];
}

+ (instancetype)showInView:(UIView *)view{

    JDYFinishAlertView *alertView = [self finishAlertView];
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    return alertView;
}
- (IBAction)confirmBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

@end
