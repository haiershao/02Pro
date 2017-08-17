//
//  JDYAdjustAlertView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/11.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JDYAdjustAlertView;
@protocol JDYAdjustAlertViewDelegta <NSObject>

- (void)adjustAlertView:(JDYAdjustAlertView *)adjustAlertView confirmBtn:(UIButton *)confirmBtn flag:(NSString *)flagStr;
@end
@interface JDYAdjustAlertView : UIView

@property (weak, nonatomic) id<JDYAdjustAlertViewDelegta>delegate;
@property (strong, nonatomic) NSString *flagStr;
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel0;
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel1;
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel2;
@property (weak, nonatomic) IBOutlet UILabel *alertInfoLabel3;

+ (instancetype)adjustAlertView;
+ (instancetype)showInView:(UIView *)view;
@end
