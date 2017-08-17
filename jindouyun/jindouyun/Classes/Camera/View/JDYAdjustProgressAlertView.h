//
//  JDYAdjustProgressAlertView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/11.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDYAdjustProgressAlertView : UIView
@property (weak, nonatomic) IBOutlet UIView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel;

+ (instancetype)adjustProgressAlertView;
+ (instancetype)showInView:(UIView *)view;
@end
