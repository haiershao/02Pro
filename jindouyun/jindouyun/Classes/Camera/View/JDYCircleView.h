//
//  JDYCircleView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/10.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JDYCircleView : UIView
-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth;

@property (assign,nonatomic) float progress;

@property (assign,nonatomic) CGFloat lineWidth;
@end
