//
//  JDYRockerSensitivityView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/7.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDYRockerSensitivityView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *rockerPickerView;

+ (instancetype)rockerSensitivityView;
@end
