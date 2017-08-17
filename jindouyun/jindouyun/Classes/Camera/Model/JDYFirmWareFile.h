//
//  JDYFirmWareFile.h
//  jindouyun
//
//  Created by jiyi on 2017/8/17.
//  Copyright © 2017年 lh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JDYFirmWareFile : NSObject <NSCoding>
@property (copy, nonatomic) NSString *AppUrl;
@property (copy, nonatomic) NSString *AppVersion;
@property (copy, nonatomic) NSString *FirmwareUrl;
@property (copy, nonatomic) NSString *FirmwareVersion;
@property (copy, nonatomic) NSString *localPath;
@end
