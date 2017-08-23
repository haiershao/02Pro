//
//  JDYProgressView.h
//  jindouyun
//
//  Created by jiyi on 2017/8/23.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface JDYProgressView : UIView

/**
 *  进度条高度  height: 5~100
 */
@property (nonatomic) CGFloat progressHeight;

/**
 *  进度值  maxValue:  <= YSProgressView.width
 */
@property (nonatomic) CGFloat progressValue;

/**
 *   动态进度条颜色  Dynamic progress
 */
@property (nonatomic, strong) UIColor *trackTintColor;
/**
 *  静态背景颜色    static progress
 */
@property (nonatomic, strong) UIColor *progressTintColor;
@end
