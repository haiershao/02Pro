//
//  JDYRockerSensitivityView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/7.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYRockerSensitivityView.h"
@interface JDYRockerSensitivityView ()

@end

@implementation JDYRockerSensitivityView

- (void)awakeFromNib{

    [super awakeFromNib];
    self.backgroundColor = kColor(0, 0,0, 0.5);
    [self.layer setFrame:CGRectMake(0, 10, screenW, self.height)];
}


- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmBtnClick:(UIButton *)sender {
    [self removeFromSuperview];
}
+ (instancetype)rockerSensitivityView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JDYRockerSensitivityView" owner:self options:nil] lastObject];
}

@end
