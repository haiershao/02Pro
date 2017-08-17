//
//  Constants.h
//  Jiyi
//
//  Created by yuntai on 2017/6/13.
//  Copyright © 2017年 yuntai. All rights reserved.
//

#ifndef Constants_h
#define Constants_h


#endif /* Constants_h */
#define kiOSVersionIs5 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 5.0 ? YES : NO)
#define kiOSVersionIs6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 ? YES : NO)
#define kiOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 ? YES : NO)
#define kiOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0 ? YES : NO)
#define kReSize(pad,phone) (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad ? pad : phone)
#define kiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)
#define kIsPad (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad ? YES : NO)
#define kPadOrPhone(pad, phone) (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad ? pad : phone)


