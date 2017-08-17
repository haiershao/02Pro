//
//  LHJoyStick.m
//  jindouyun
//
//  Created by jiyi on 2017/8/9.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "LHJoyStick.h"

#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
@interface LHJoyStick ()

@property (weak, nonatomic) IBOutlet UIImageView *backImage;

@property (weak, nonatomic) IBOutlet UIImageView *joystickImage;

@property (weak, nonatomic) IBOutlet UIButton *joystickBtn;

@property (copy, nonatomic) NSString *positionStr;
@property (copy, nonatomic) NSString *speedStr;
@end

@implementation LHJoyStick

+ (LHJoyStick *)joystick
{
    return [LHJoyStick joystickWithFrame:CGRectZero];
}


+ (LHJoyStick *)joystickWithFrame:(CGRect)frame
{
    LHJoyStick *joystick = [[[NSBundle mainBundle] loadNibNamed:@"LHJoyStick" owner:nil options:nil] firstObject];
    joystick.frame = frame;
    return joystick;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.vertical = 0x80;
    self.horizontal = 0x80;
}



- (IBAction)joysticTouchDown:(UIButton *)sender {
    
    NSLog(@"TouchDown");
    
    [sender removeFromSuperview];
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //    NSLog(@"touchesBegan");
    
    UITouch *touchCenter = [touches anyObject];
    
    CGPoint point1 = [touchCenter locationInView:self];
    
    [self point:point1 inCircleRect:self.backImage.frame];
    
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touchCenter = [touches anyObject];
    
    CGPoint point1 = [touchCenter locationInView:self];
    
    [self point:point1 inCircleRect:self.backImage.frame];
    
    
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    self.joystickImage.center = self.backImage.center;
    self.vertical = 0x80;
    self.horizontal = 0x80;
    self.positionStr = @"回中";
    if ([self.delegate respondsToSelector:@selector(joyStick:position:speed:)]) {
        [self.delegate joyStick:self position:self.positionStr speed:self.speedStr];
    }
}


//圆心到点的距离 > 半径
- (void)point:(CGPoint)point inCircleRect:(CGRect)rect {
    
    CGFloat r = rect.size.width/2.0;   //圆的半径
    CGPoint center = CGPointMake(rect.origin.x + r, rect.origin.y + r); //圆心
    
    double a = fabs(point.x - center.x);    // a            /|
    double b = fabs(point.y - center.y);    // b         c / |b
    double c = hypot(a, b);                 // c          /__|
    //              a
    double radian = acos(a/c);
    //    double radian = acos(a/c)*(point.y < center.y?-1:1);
    
    //    double angle =
    
    
    //    NSLog(@"外面 %f",a/c);
    
    if (c <= r) {   //点击的位置在圆内
        
        self.joystickImage.center = point;
        if (point.x > center.x && point.y < center.y) {         //一项限   以圆心为原点来分象限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"右 -- %f",angle);
                self.positionStr = @"右";
            }else if (angle > 67.5){
                
                NSLog(@"上 -- %f",angle);
                self.positionStr = @"上";
            }else{
                
                NSLog(@"右上 -- %f",angle);
                self.positionStr = @"右上";
            }
            
        } else if (point.x < center.x && point.y < center.y) {  //二项限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"左 -- %f",angle);
                self.positionStr = @"左";
            }else if (angle > 67.5){
                
                NSLog(@"上 -- %f",angle);
                self.positionStr = @"上";
            }else{
                
                NSLog(@"左上 -- %f",angle);
                self.positionStr = @"左上";
            }
            
        } else if (point.x < center.x && point.y > center.y) {  //三项限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"左 -- %f",angle);
                self.positionStr = @"左";
            }else if (angle > 67.5){
                
                NSLog(@"下 -- %f",angle);
                self.positionStr = @"下";
            }else{
                
                NSLog(@"左下 -- %f",angle);
                self.positionStr = @"左下";
            }
            
        } else if (point.x > center.x && point.y > center.y) {  //四项限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"右 -- %f",angle);
                self.positionStr = @"右";
            }else if (angle > 67.5){
                
                NSLog(@"下 -- %f",angle);
                self.positionStr = @"下";
            }else{
                
                NSLog(@"右下 -- %f",angle);
                self.positionStr = @"右下";
            }
            
        }
    } else {
        //圆参数方程 x = m + r*cosθ, y = n + r*sinθ   (m,n)为圆心
        if (point.x > center.x && point.y < center.y) {         //一项限   以圆心为原点来分象限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"右 -- %f",angle);
                self.positionStr = @"右";
            }else if (angle > 67.5){
                
                NSLog(@"上 -- %f",angle);
                self.positionStr = @"上";
            }else{
                
                NSLog(@"右上 -- %f",angle);
                self.positionStr = @"右上";
            }
            
            //     m + r * cosθ             n + r * sinθ
            self.joystickImage.center = CGPointMake(center.x + r * (a / c) , center.y - r * (b / c));
            
        } else if (point.x < center.x && point.y < center.y) {  //二项限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"左 -- %f",angle);
                self.positionStr = @"左";
            }else if (angle > 67.5){
                
                NSLog(@"上 -- %f",angle);
                self.positionStr = @"上";
            }else{
                
                NSLog(@"左上 -- %f",angle);
                self.positionStr = @"左上";
            }
            
            self.joystickImage.center = CGPointMake(center.x - r * (a / c) , center.y - r * (b / c));
            
        } else if (point.x < center.x && point.y > center.y) {  //三项限
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"左 -- %f",angle);
                self.positionStr = @"左";
            }else if (angle > 67.5){
                
                NSLog(@"下 -- %f",angle);
                self.positionStr = @"下";
            }else{
                
                NSLog(@"左下 -- %f",angle);
                self.positionStr = @"左下";
            }
            
            self.joystickImage.center = CGPointMake(center.x - r * (a / c) , center.y + r * (b / c));
            
        } else if (point.x > center.x && point.y > center.y) {  //四项限
            
            double angle = RADIANS_TO_DEGREES(radian);
            if (angle < 22.5) {
                NSLog(@"右 -- %f",angle);
                self.positionStr = @"右";
            }else if (angle > 67.5){
                
                NSLog(@"下 -- %f",angle);
                self.positionStr = @"下";
            }else{
                
                NSLog(@"右下 -- %f",angle);
                self.positionStr = @"右下";
            }
            
            self.joystickImage.center = CGPointMake(center.x + r * (a / c) , center.y + r * (b / c));
            
        }
        
    }

    if (c <= r) {
        NSLog(@"point c: %f -- %f -- %f",c, r,(r/3)*2);
        if (c<=(r/3)) {
            self.speedStr = @"低";
        }else if (c<=(r/3)*2 && c>(r/3)){
            
            self.speedStr = @"中";
        }else if (c>(r/3)*2){
            
            self.speedStr = @"高";
        }
    }
    
    
    if ([self.delegate respondsToSelector:@selector(joyStick:position:speed:)]) {
        [self.delegate joyStick:self position:self.positionStr speed:self.speedStr];
    }
    //  (边长、直径)
    CGFloat vertical = (self.backImage.center.y - self.joystickImage.center.y + r) / (r * 2);
    
    CGFloat horizontal = (self.joystickImage.center.x - self.backImage.center.x + r) / (r * 2);
    
    //    NSLog(@"vertical:%f ---  horizontal:%f", vertical, horizontal);
    
    if (vertical > 0.999)   vertical = 1.0;
    if (vertical < 0.001)   vertical = 0.0;
    
    if (horizontal > 0.999)   horizontal = 1.0;
    if (horizontal < 0.001)   horizontal = 0.0;
    
    
    if (self.returnPar) {
        
        NSUInteger v = vertical * 0xFF;
        
        NSUInteger h = horizontal * 0xFF;
        
        self.returnPar(v, h);
    }
    
    //    return c <= r;
}

// 重力感应
- (void)setVertical:(NSUInteger)vertical
{
    _vertical = vertical;
}


- (void)setHorizontal:(NSUInteger)horizontal
{
    _horizontal = horizontal;
}
@end
