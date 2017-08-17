//
//  JDYAdjustViewController.h
//  jindouyun
//
//  Created by jiyi on 2017/8/3.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>
@class BabyBluetooth;
@interface JDYAdjustViewController : UIViewController{
@public
    
    NSMutableArray *sect;
    __block  NSMutableArray *readValueArray;
    __block  NSMutableArray *descriptors;
}
@property (nonatomic,strong) BabyBluetooth *baby;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBCharacteristic *characteristic2;
@property (nonatomic,strong)CBCharacteristic *characteristic0;
@property (strong,nonatomic) NSMutableArray *services;
@property(strong,nonatomic) CBPeripheral *currPeripheral;

+ (instancetype)adjustViewController;
@end
