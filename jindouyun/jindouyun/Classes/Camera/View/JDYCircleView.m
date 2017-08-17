//
//  JDYCircleView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/10.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYCircleView.h"
static CGFloat endPointMargin = 1.0f;
@interface JDYCircleView () {
    CAShapeLayer* _trackLayer;
    CAShapeLayer* _progressLayer;
    UIImageView* _endPoint;//在终点位置添加一个点
}

@end

@implementation JDYCircleView


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
    
    UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:-0.35f*M_PI clockwise:YES];
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.3f*M_PI) endAngle:-0.15f*M_PI clockwise:YES];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.1f*M_PI) endAngle:0.05f*M_PI clockwise:YES];
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.1f*M_PI) endAngle:0.25f*M_PI clockwise:YES];
    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.3f*M_PI) endAngle:0.45f*M_PI clockwise:YES];
    
    UIBezierPath *path5 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.50f*M_PI) endAngle:0.65f*M_PI clockwise:YES];
    
    UIBezierPath *path6 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.70f*M_PI) endAngle:0.85f*M_PI clockwise:YES];
    
    UIBezierPath *path7 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.90f*M_PI) endAngle:1.05f*M_PI clockwise:YES];
    
    UIBezierPath *path8 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(1.10f*M_PI) endAngle:1.25f*M_PI clockwise:YES];
    
    UIBezierPath *path9 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(1.3f*M_PI) endAngle:1.45f*M_PI clockwise:YES];
    //添加背景圆环
    CAShapeLayer *backLayer0 = [CAShapeLayer layer];
    backLayer0.frame = self.bounds;
    backLayer0.fillColor =  [[UIColor clearColor] CGColor];
    backLayer0.strokeColor  = kNormalBGColor.CGColor;
    backLayer0.lineWidth = _lineWidth;
    backLayer0.path = [path0 CGPath];
    backLayer0.strokeEnd = 1;
    [self.layer addSublayer:backLayer0];
    
    CAShapeLayer *backLayer1 = [CAShapeLayer layer];
    backLayer1.frame = self.bounds;
    backLayer1.fillColor =  [[UIColor clearColor] CGColor];
    backLayer1.strokeColor  = kNormalBGColor.CGColor;
    backLayer1.lineWidth = _lineWidth;
    backLayer1.path = [path1 CGPath];
    backLayer1.strokeEnd = 1;
    [self.layer addSublayer:backLayer1];
    
    CAShapeLayer *backLayer2 = [CAShapeLayer layer];
    backLayer2.frame = self.bounds;
    backLayer2.fillColor =  [[UIColor clearColor] CGColor];
    backLayer2.strokeColor  = kNormalBGColor.CGColor;
    backLayer2.lineWidth = _lineWidth;
    backLayer2.path = [path2 CGPath];
    backLayer2.strokeEnd = 1;
    [self.layer addSublayer:backLayer2];
    
    CAShapeLayer *backLayer3 = [CAShapeLayer layer];
    backLayer3.frame = self.bounds;
    backLayer3.fillColor =  [[UIColor clearColor] CGColor];
    backLayer3.strokeColor  = kNormalBGColor.CGColor;
    backLayer3.lineWidth = _lineWidth;
    backLayer3.path = [path3 CGPath];
    backLayer3.strokeEnd = 1;
    [self.layer addSublayer:backLayer3];
    
    CAShapeLayer *backLayer4 = [CAShapeLayer layer];
    backLayer4.frame = self.bounds;
    backLayer4.fillColor =  [[UIColor clearColor] CGColor];
    backLayer4.strokeColor  = kNormalBGColor.CGColor;
    backLayer4.lineWidth = _lineWidth;
    backLayer4.path = [path4 CGPath];
    backLayer4.strokeEnd = 1;
    [self.layer addSublayer:backLayer4];
    
    CAShapeLayer *backLayer5 = [CAShapeLayer layer];
    backLayer5.frame = self.bounds;
    backLayer5.fillColor =  [[UIColor clearColor] CGColor];
    backLayer5.strokeColor  = kNormalBGColor.CGColor;
    backLayer5.lineWidth = _lineWidth;
    backLayer5.path = [path5 CGPath];
    backLayer5.strokeEnd = 1;
    [self.layer addSublayer:backLayer5];
    
    CAShapeLayer *backLayer6 = [CAShapeLayer layer];
    backLayer6.frame = self.bounds;
    backLayer6.fillColor =  [[UIColor clearColor] CGColor];
    backLayer6.strokeColor  = kNormalBGColor.CGColor;
    backLayer6.lineWidth = _lineWidth;
    backLayer6.path = [path6 CGPath];
    backLayer6.strokeEnd = 1;
    [self.layer addSublayer:backLayer6];
    
    CAShapeLayer *backLayer7 = [CAShapeLayer layer];
    backLayer7.frame = self.bounds;
    backLayer7.fillColor =  [[UIColor clearColor] CGColor];
    backLayer7.strokeColor  = kNormalBGColor.CGColor;
    backLayer7.lineWidth = _lineWidth;
    backLayer7.path = [path7 CGPath];
    backLayer7.strokeEnd = 1;
    [self.layer addSublayer:backLayer7];
    
    CAShapeLayer *backLayer8 = [CAShapeLayer layer];
    backLayer8.frame = self.bounds;
    backLayer8.fillColor =  [[UIColor clearColor] CGColor];
    backLayer8.strokeColor  = kNormalBGColor.CGColor;
    backLayer8.lineWidth = _lineWidth;
    backLayer8.path = [path8 CGPath];
    backLayer8.strokeEnd = 1;
    [self.layer addSublayer:backLayer8];
    
    CAShapeLayer *backLayer9 = [CAShapeLayer layer];
    backLayer9.frame = self.bounds;
    backLayer9.fillColor =  [[UIColor clearColor] CGColor];
    backLayer9.strokeColor  = kNormalBGColor.CGColor;
    backLayer9.lineWidth = _lineWidth;
    backLayer9.path = [path9 CGPath];
    backLayer9.strokeEnd = 1;
    [self.layer addSublayer:backLayer9];
}

-(void)setProgress:(float)progress {

    _progress = progress;
    [self updateEndPoint:progress];
}

//更新小点的位置
-(void)updateEndPoint:(float)progress
{
    //创建贝塞尔路径
    
    float centerX = self.bounds.size.width/2.0;
    float centerY = self.bounds.size.height/2.0;
    //半径
    float radius = (self.bounds.size.width-_lineWidth)/2.0;
    
    UIBezierPath *path0 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.5f*M_PI) endAngle:-0.35f*M_PI clockwise:YES];
    
    UIBezierPath *path1 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.3f*M_PI) endAngle:-0.15f*M_PI clockwise:YES];
    
    UIBezierPath *path2 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(-0.1f*M_PI) endAngle:0.05f*M_PI clockwise:YES];
    
    UIBezierPath *path3 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.1f*M_PI) endAngle:0.25f*M_PI clockwise:YES];
    
    UIBezierPath *path4 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.3f*M_PI) endAngle:0.45f*M_PI clockwise:YES];
    
    UIBezierPath *path5 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.50f*M_PI) endAngle:0.65f*M_PI clockwise:YES];
    
    UIBezierPath *path6 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.70f*M_PI) endAngle:0.85f*M_PI clockwise:YES];
    
    UIBezierPath *path7 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(0.90f*M_PI) endAngle:1.05f*M_PI clockwise:YES];
    
    UIBezierPath *path8 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(1.10f*M_PI) endAngle:1.25f*M_PI clockwise:YES];
    
    UIBezierPath *path9 = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:(1.3f*M_PI) endAngle:1.45f*M_PI clockwise:YES];
    
    NSArray *arrColor = [NSArray arrayWithObjects:(id)[kColor(60, 64, 255, 1) CGColor],(id)[kColor(60, 64, 255, 1) CGColor], nil];
    if (progress>0 && progress<=0.1) {
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path0 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.1 && progress<=0.2){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path1 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.2 && progress<=0.3){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path2 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.3 && progress<=0.4){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path3 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.4 && progress<=0.5){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path4 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.5 && progress<=0.6){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path5 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.6 && progress<=0.7){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path6 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.7 && progress<=0.8){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path7 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.8 && progress<=0.9){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path8 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.9 && progress<=1){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path9 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.1 && progress<=0.2){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path1 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.1 && progress<=0.2){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path1 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.1 && progress<=0.2){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path1 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }else if (progress>0.1 && progress<=0.2){
        //创建进度layer
        CAShapeLayer *progressLayer = [CAShapeLayer layer];
        progressLayer.frame = self.bounds;
        progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        //指定path的渲染颜色
        progressLayer.strokeColor  = [[UIColor blackColor] CGColor];
        //kCALineCapRound
        progressLayer.lineCap = kCALineCapButt;
        progressLayer.lineWidth = _lineWidth;
        progressLayer.path = [path1 CGPath];
        progressLayer.strokeEnd = 0;
        
        //设置渐变颜色
        CAGradientLayer *gradientLayer =  [CAGradientLayer layer];
        gradientLayer.frame = self.bounds;
        [gradientLayer setColors:arrColor];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(0, 1);
        [gradientLayer setMask:progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
        progressLayer.strokeEnd = 10*progress;
    }
}

@end
