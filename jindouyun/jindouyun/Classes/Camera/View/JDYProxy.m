//
//  JDYProxy.m
//  jindouyun
//
//  Created by jiyi on 2017/8/4.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYProxy.h"

@implementation JDYProxy
+(instancetype)proxyWithTarget:(id)target
{
    return [[self alloc] initWithTarget:target];
}

-(instancetype)initWithTarget:(id)target
{
    _target = target;
    return self;
}

//获得目标对象的方法签名
-(NSMethodSignature *)methodSignatureForSelector:(SEL)sel
{
    return [_target methodSignatureForSelector:sel];
}

//转发给目标对象
-(void)forwardInvocation:(NSInvocation *)invocation
{
    if ([_target respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_target];
    }
}
@end
