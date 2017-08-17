//
//  JDYWave.m
//  jindouyun
//
//  Created by jiyi on 2017/8/3.
//  Copyright © 2017年 lh. All rights reserved.
//




#import "JDYWave.h"
#import "JDYProxy.h"
@interface JDYWave () {
    CGFloat waveWidth;
    CGFloat waveHeight;
    
    CGFloat waveA;      // A
    CGFloat waveW;      // ω
    CGFloat offsetF;    // φ firstLayer
    CGFloat offsetS;    // φ secondLayer
    CGFloat currentK;   // k
    CGFloat waveSpeedF; // 外层波形移动速度
    CGFloat waveSpeedS; // 内层波形移动速度
    
    WaveDirectionType direction; //移动方向
}

@property(nonatomic,strong)CADisplayLink *waveDisplayLink;
@property(nonatomic,strong)CAShapeLayer *frontWaveLayer;
@property(nonatomic,strong)CAShapeLayer *insideWaveLayer;

@property(nonatomic,strong)JDYProxy *proxy;

@end
@implementation JDYWave

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _proxy = [JDYProxy proxyWithTarget:self];
        
        [self configWaveProperties];
        [self createWaves];
    }
    
    return self;
}

-(void)configWaveProperties
{
    _frontColor    = [UIColor blackColor];
    _insideColor   = [UIColor grayColor];
    _frontSpeed    = 0.01;
    _insideSpeed   = 0.01;
    _waveOffset    = M_PI;
    _directionType = WaveDirectionTypeBackWard;
}

-(void)createWaves
{
    waveWidth   = self.frame.size.width;
    waveHeight  = self.frame.size.height;
    
    waveA       = waveHeight / 2;
    waveW       = M_PI * 2 / waveWidth;
    offsetF     = 0;
    offsetS     = offsetF + _waveOffset;
    currentK    = waveHeight / 2;
    waveSpeedF  = _frontSpeed;
    waveSpeedS  = _insideSpeed;
    direction   = _directionType;
    
    _frontWaveLayer = [CAShapeLayer layer];
    _frontWaveLayer.fillColor = _frontColor.CGColor;
    [self.layer addSublayer:_frontWaveLayer];
    
    _insideWaveLayer = [CAShapeLayer layer];
    _insideWaveLayer.fillColor = _insideColor.CGColor;
    [self.layer insertSublayer:_insideWaveLayer below:_frontWaveLayer];
    
    
    _waveDisplayLink = [CADisplayLink displayLinkWithTarget:_proxy selector:@selector(refreshCurrentWave:)];
    [_waveDisplayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    //    [self refreshCurrentWave:nil];
}

-(void)refreshCurrentWave:(CADisplayLink *)displayLink
{
    offsetF += waveSpeedF * direction;
    offsetS += waveSpeedS * direction;
    
    [self drawCurrentWaveWithLayer:_frontWaveLayer offset:offsetF];
    [self drawCurrentWaveWithLayer:_insideWaveLayer offset:offsetS];
}

-(void)drawCurrentWaveWithLayer:(CAShapeLayer *)waveLayer offset:(CGFloat)offset
{
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat y = currentK;
    CGPathMoveToPoint(path, nil, 0, y);
    
    for (NSInteger i = 0; i <= waveWidth; i++) {
        
        y = waveA * sin(waveW * i + offset) + currentK;
        
        CGPathAddLineToPoint(path, nil, i, y);
    }
    
    CGPathAddLineToPoint(path, nil, waveWidth, waveHeight);
    CGPathAddLineToPoint(path, nil, 0, waveHeight);
    
    CGPathCloseSubpath(path);
    
    waveLayer.path = path;
    
    CGPathRelease(path);
}


-(void)dealloc
{
    NSLog(@"WaveView dealloc");
    [_waveDisplayLink invalidate];
    _waveDisplayLink = nil;
}


#pragma mark - WaveProperties Setter Methods

-(void)setFrontColor:(UIColor *)frontColor
{
    if (_frontColor != frontColor) {
        _frontColor = frontColor;
        _frontWaveLayer.fillColor = FrontColor.CGColor;
    }
}

-(void)setInsideColor:(UIColor *)insideColor
{
    if (_insideColor != insideColor) {
        _insideColor = insideColor;
        _insideWaveLayer.fillColor = InsideColor.CGColor;
    }
}

-(void)setFrontSpeed:(CGFloat)frontSpeed
{
    if (_frontSpeed != frontSpeed) {
        _frontSpeed = frontSpeed;
        waveSpeedF = _frontSpeed;
    }
}

-(void)setInsideSpeed:(CGFloat)insideSpeed
{
    if (_insideSpeed != insideSpeed) {
        _insideSpeed = insideSpeed;
        waveSpeedS = _insideSpeed;
    }
}

-(void)setWaveOffset:(CGFloat)waveOffset
{
    if (_waveOffset != waveOffset) {
        _waveOffset = waveOffset;
        offsetS = offsetF + _waveOffset;
    }
}

-(void)setDirectionType:(WaveDirectionType)directionType
{
    if (_directionType != directionType) {
        _directionType = directionType;
        direction = _directionType;
    }
}

@end
