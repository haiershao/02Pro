//
//  JDYAdjustAlertView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/11.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYAdjustAlertView.h"
@interface JDYAdjustAlertView ()<UIGestureRecognizerDelegate>

@end

@implementation JDYAdjustAlertView


- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    
    [self removeFromSuperview];
    if ([self.delegate respondsToSelector:@selector(adjustAlertView:confirmBtn:flag:)]) {
        [self.delegate adjustAlertView:self confirmBtn:sender flag:self.flagStr];
    }
}

+ (instancetype)adjustAlertView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JDYAdjustAlertView" owner:self options:nil] lastObject];
}

+ (instancetype)showInView:(UIView *)view{

    JDYAdjustAlertView *alertView = [self adjustAlertView];
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    return alertView;
}

@end
