//
//  JDYXYZAxisView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/7.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYXYZAxisView.h"

@implementation JDYXYZAxisView

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
    if ([self.delegate respondsToSelector:@selector(XYZAxisView:confirmBtn:)]) {
        [self.delegate XYZAxisView:self confirmBtn:sender];
    }
}

+ (instancetype)XYZAxisView{
    
    return [[[NSBundle mainBundle] loadNibNamed:@"JDYXYZAxisView" owner:self options:nil] lastObject];
}


@end
