//
//  LHJoyStick.h
//  jindouyun
//
//  Created by jiyi on 2017/8/9.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^ReturnParameter) (NSUInteger vertical, NSUInteger horizontal);
@class LHJoyStick;
@protocol LHJoyStickDelegate <NSObject>

- (void)joyStick:(LHJoyStick *)joyStick position:(NSString *)positionStr speed:(NSString *)speedStr;
@end

@interface LHJoyStick : UIView
@property (nonatomic, assign) NSUInteger vertical;

@property (nonatomic, assign) NSUInteger horizontal;

+ (LHJoyStick *)joystick;

+ (LHJoyStick *)joystickWithFrame:(CGRect)frame;

@property (nonatomic, copy) ReturnParameter returnPar;

@property (weak, nonatomic) id<LHJoyStickDelegate>delegate;
@end
