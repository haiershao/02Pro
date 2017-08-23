//
//  JDYConst.h
//  jindouyun
//
//  Created by jiyi on 2017/8/3.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>
#define screenFrame [UIScreen mainScreen].bounds
#define screenW [UIScreen mainScreen].bounds.size.width
#define screenH [UIScreen mainScreen].bounds.size.height

#define kColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]
#define kBackgroundColor  kColor(37, 39, 50, 1)
#define kNavBGColor [UIColor colorWithRed:252/255.0f green:25/255.0f blue:77/255.0f alpha:1.0]
#define FrontColor [UIColor colorWithRed:37/255.0 green:39/255.0 blue:50/255.0 alpha:1.0]
#define InsideColor [UIColor colorWithRed:252/255.0f green:67/255.0f blue:108/255.0f alpha:1.0]
#define kNormalBGColor [UIColor colorWithRed:134/255.0f green:135/255.0f blue:142/255.0f alpha:1.0]
#define kHighBGColor [UIColor colorWithRed:252/255.0f green:25/255.0f blue:77/255.0f alpha:1.0]

#define listCollectionCellCount 2
#define FirmwareVersionKey @"FirmwareVersion"
#define FirmwareNumFromHardWareKey @"FirmwareNumFromHardWare"
#define FirmwareIsSucessKey @"FirmwareIsSucess"

#define JYNotificationCenter [NSNotificationCenter defaultCenter]
#define JYLog(...) NSLog(__VA_ARGS__)
