//
//  JDYProgressView.m
//  jindouyun
//
//  Created by jiyi on 2017/8/23.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYProgressView.h"

@interface JDYProgressView (){

    CGRect changeRect;
}

/**
 *  进度条 progressView
 */
@property (nonatomic, strong) UIView *progressView;

/**
 *  progressView Rect
 */
@property (nonatomic) CGRect rect_progressView;

/**
 *  限制高度大小
 *
 *  @param height self.height
 */
- (void)_setHeightRestrictionOfFrame:(CGFloat)height;
@end

@implementation JDYProgressView

- (UIView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIView alloc] initWithFrame:CGRectZero];
        _progressView.backgroundColor = [UIColor clearColor];
        [self addSubview:self.progressView];
    }
    return _progressView;
}

#pragma mark -  initWithFrame

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        [self _setHeightRestrictionOfFrame:frame.size.height];
    }
    return self;
}

#pragma mark - Privite Method
- (void)_setHeightRestrictionOfFrame:(CGFloat)height
{
    CGRect rect = self.frame;
    
    _progressHeight = MIN(height, 100.0);
    _progressHeight = MAX(_progressHeight, 5.0);
    
    self.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, _progressHeight);
    
    self.rect_progressView = CGRectZero;
    changeRect.size.height = _progressHeight;
    self.progressView.frame = self.rect_progressView;
    
}

#pragma mark - Setter

- (void)setProgressHeight:(CGFloat)progressHeight
{
    [self _setHeightRestrictionOfFrame:progressHeight];
}

- (void)setProgressTintColor:(UIColor *)progressTintColor
{
    _progressTintColor = progressTintColor;

    self.backgroundColor = _progressTintColor;
}

- (void)setTrackTintColor:(UIColor *)trackTintColor
{
    _trackTintColor = trackTintColor;
    
    self.progressView.backgroundColor = _trackTintColor;
}

- (void)setProgressValue:(CGFloat)progressValue
{
    _progressValue = progressValue;
    changeRect.size.width = _progressValue*self.frame.size.width;
    
    
    CGFloat maxValue = self.bounds.size.width;
    
    double durationValue = (_progressValue/2.0) / maxValue + .5;
    
    [UIView animateWithDuration:durationValue animations:^{
        
        self.progressView.frame = changeRect;
    }];
    
    if (_progressValue > 0.1 ){
        
       _trackTintColor = [UIColor greenColor];
    }else{
        
        _trackTintColor = [UIColor redColor];
    }
    self.progressView.backgroundColor = _trackTintColor;
}
@end
