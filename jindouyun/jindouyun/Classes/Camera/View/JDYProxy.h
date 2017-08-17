//
//  JDYProxy.h
//  jindouyun
//
//  Created by jiyi on 2017/8/4.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDYProxy : NSProxy
@property(nonatomic, weak, readonly) id target;

+(instancetype)proxyWithTarget:(id)target;
@end
