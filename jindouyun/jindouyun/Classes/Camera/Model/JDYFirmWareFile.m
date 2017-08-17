//
//  JDYFirmWareFile.m
//  jindouyun
//
//  Created by jiyi on 2017/8/17.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYFirmWareFile.h"

@implementation JDYFirmWareFile
- (id)initWithCoder:(NSCoder *)aDecoder
{
    if(self = [super init])
    {
        self.AppUrl = [aDecoder decodeObjectForKey:@"AppUrl"];
        self.AppVersion = [aDecoder decodeObjectForKey:@"AppVersion"];
        self.FirmwareUrl = [aDecoder decodeObjectForKey:@"FirmwareUrl"];
        self.FirmwareVersion = [aDecoder decodeObjectForKey:@"FirmwareVersion"];
        self.localPath = [aDecoder decodeObjectForKey:@"localPath"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.AppUrl forKey:@"AppUrl"];
    [aCoder encodeObject:self.AppVersion forKey:@"AppVersion"];
    [aCoder encodeObject:self.FirmwareUrl forKey:@"FirmwareUrl"];
    [aCoder encodeObject:self.FirmwareVersion forKey:@"FirmwareVersion"];
    [aCoder encodeObject:self.localPath forKey:@"localPath"];
}
@end
