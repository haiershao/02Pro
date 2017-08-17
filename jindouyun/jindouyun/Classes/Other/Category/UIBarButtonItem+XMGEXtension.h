//
//  UIBarButtonItem+XMGEXtension.h
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (XMGEXtension)
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action;
@end
