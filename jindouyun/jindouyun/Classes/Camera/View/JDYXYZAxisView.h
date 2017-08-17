//
//  JDYXYZAxisView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/7.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JDYXYZAxisView;
@protocol JDYXYZAxisViewDelegta <NSObject>

- (void)XYZAxisView:(JDYXYZAxisView *)axisView confirmBtn:(UIButton *)confirmBtn;
@end

@interface JDYXYZAxisView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *axisView;

@property (weak, nonatomic) id<JDYXYZAxisViewDelegta>delegate;

+ (instancetype)XYZAxisView;
@end
