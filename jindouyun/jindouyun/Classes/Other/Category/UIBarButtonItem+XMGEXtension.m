//
//  UIBarButtonItem+XMGEXtension.m
//  百思不得姐
//
//  Created by hwawo on 16/6/29.
//  Copyright © 2016年 ichano. All rights reserved.
//

#import "UIBarButtonItem+XMGEXtension.h"

@implementation UIBarButtonItem (XMGEXtension)
+ (UIBarButtonItem *)itemWithImage:(NSString *)image highImage:(NSString *)highImage target:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    button.size = button.currentBackgroundImage.size;
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
