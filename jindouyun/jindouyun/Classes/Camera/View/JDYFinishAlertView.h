//
//  JDYFinishAlertView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/14.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDYFinishAlertView : UIView
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel;

+ (instancetype)showInView:(UIView *)view;
@end
