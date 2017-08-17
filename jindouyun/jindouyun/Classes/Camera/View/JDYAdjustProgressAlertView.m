//
//  JDYAdjustProgressAlertView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/11.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYAdjustProgressAlertView.h"
#import "LHGradientProgress.h"
@implementation JDYAdjustProgressAlertView



+ (instancetype)adjustProgressAlertView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JDYAdjustProgressAlertView" owner:self options:nil] lastObject];
}

+ (instancetype)showInView:(UIView *)view{
    
    JDYAdjustProgressAlertView *alertView = [self adjustProgressAlertView];
    alertView.frame = view.bounds;
    [view addSubview:alertView];
    
    return alertView;
}
@end
