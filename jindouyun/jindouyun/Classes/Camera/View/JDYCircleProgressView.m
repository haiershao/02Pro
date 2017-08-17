//
//  JDYCircleProgressView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/10.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYCircleProgressView.h"

#define RGB(r, g, b) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

static CGFloat endPointMargin = 1.0f;

@interface JDYCircleProgressView () {
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    UIImageView* _endPoint;//在终点位置添加一个点
}
@end

@implementation JDYCircleProgressView


-(instancetype)initWithFrame:(CGRect)frame lineWidth:(float)lineWidth
{
    self = [super initWithFrame:frame];
    if (self) {
        _lineWidth = lineWidth;
        [self buildLayout];
    }
    return self;
}

-(void)buildLayout
{
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    
    //创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:1.5f*M_PI clockwise:YES];
    
    //添加背景圆环
    
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor =  [[UIColor clearColor] CGColor];
    backLayer.strokeColor  = kNormalBGColor.CGColor;
    backLayer.lineWidth = _lineWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    //创建进度layer
    _progressLayer = [CAShapeLayer layer];
    _progressLayer.frame = self.bounds;
    _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
    //指定path的渲染颜色
    _progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
    _progressLayer.lineCap = kCALineCapRound;
    _progressLayer.lineWidth = _lineWidth;
    _progressLayer.path = [path CGPath];
    _progressLayer.strokeEnd = 0;
    
    //设置渐变颜色
    CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)[kHighBGColor CGColor],(id)[kHighBGColor CGColor], nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
    [self.layer addSublayer:gradientLayer];
    
    
    //用于显示结束位置的小点
    _endPoint = [[UIImageView alloc] init];
    _endPoint.frame = CGRectMake(0, 0, _lineWidth - endPointMargin*2,_lineWidth - endPointMargin*2);
    _endPoint.hidden = true;
    _endPoint.backgroundColor = [UIColor blackColor];
    _endPoint.image = [UIImage imageNamed:@"endPoint"];
    _endPoint.layer.masksToBounds = true;
    _endPoint.layer.cornerRadius = _endPoint.bounds.size.width/2;
    [self addSubview:_endPoint];
}

-(void)setProgress:(float)progress
{
    _progress = progress;
    _progressLayer.strokeEnd = progress;
    [_progressLayer removeAllAnimations];
}



@end
