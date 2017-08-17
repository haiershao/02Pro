//
//  LHGradientProgress.h
//  jindouyun
//
//  Created by jiyi on 2017/8/11.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, WProgressPos)
{
    LHProgressPosDown = 0,        //default, progress is on the down border of parent view
    LHProgressPosUp               //progress is on the up border of parent view
};

@interface LHGradientProgress : UIView
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) WProgressPos position;

+ (LHGradientProgress *)sharedInstance;

/**
 *  the main interface to show WGradientProgress obj, position is WProgressPosDown by default.
 *
 *  @param parentView which view to be attach
 */
- (void)showOnParent:(UIView *)parentView;

/**
 *  the main interface to show WGradientProgress obj
 *
 *  @param parentView which view to be attach
 *  @param pos        up or down
 */
- (void)showOnParent:(UIView *)parentView position:(WProgressPos)pos;

/**
 *  the main interface to hide WGradientProgress obj
 */
- (void)hide;
- (void)simulateProgress;
@end
