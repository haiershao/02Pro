//
//  JDYAdjustViewController.m
//  jindouyun
//
//  Created by jiyi on 2017/8/3.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYAdjustViewController.h"
#import "JDYWave.h"
#import <BabyBluetooth.h>
#import "JDYAdjustAlertView.h"
#import "JDYAdjustProgressAlertView.h"
#import <Lottie/Lottie.h>
#import "LHGradientProgress.h"
#import "JDYFinishAlertView.h"

#define channelOnCharacteristicView @"CharacteristicView"
@interface JDYAdjustViewController () <JDYAdjustAlertViewDelegta,UIGestureRecognizerDelegate>{
    JDYWave *_doubleWaveView;
    NSString *flagStr;

}
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *addWatchBtn;
@property (weak, nonatomic) IBOutlet UIButton *gyroBtn;

@property (strong, nonatomic) JDYAdjustAlertView *adjustAlertView;
@property (strong, nonatomic) JDYAdjustProgressAlertView *adjustProgressAlertView;
@property (nonatomic, strong) LOTAnimationView *laAnimation;
@end

@implementation JDYAdjustViewController
- (BOOL)shouldAutorotate{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [self setUpPeripheralAndBaby];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = kBackgroundColor;
    
    [self setUpSubViews];
}

- (void)setUpPeripheralAndBaby{

    if (_currPeripheral) {
        //配置ble委托
        [self babyDelegate];
        NSLog(@"self.currPeripheral.services %@",self.currPeripheral.services);
        
        for (CBService *s in self.currPeripheral.services) {
            NSLog(@"self.currPeripheral.services UUID %@",[s.UUID UUIDString]);
            if ([[s.UUID UUIDString] isEqualToString:@"FFE0"]) {
                
                for (CBCharacteristic *characteristic in s.characteristics) {
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {//写无回复
                        self.characteristic0 = characteristic;
                        NSLog(@"JDYAdjustViewController self.characteristic0 %@",self.characteristic0);
                    }
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                        self.characteristic2 = characteristic;
                        NSLog(@"JDYAdjustViewController self.characteristic2 %@",self.characteristic2);
                    }
                }
            }
            
        }
        NSLog(@"JDYAdjustViewController self.characteristic %@",self.characteristic);
        NSLog(@"JDYAdjustViewController self.characteristic2 %@",self.characteristic2);
        //读取服务
        if (self.characteristic0 && self.characteristic2) {
            
            self.baby.channel(channelOnCharacteristicView).characteristicDetails(self.currPeripheral,self.characteristic0);
            [self setNotifiy];
        }
        
    }
}

- (void)setUpSubViews{
    self.navView.backgroundColor = kNavBGColor;
    _doubleWaveView = [[JDYWave alloc] initWithFrame:CGRectMake(0, self.navView.size.height - 15, screenW, 15)];
    _doubleWaveView.frontColor = FrontColor;
    _doubleWaveView.insideColor = InsideColor;
    _doubleWaveView.directionType = WaveDirectionTypeFoward;
    [self.navView addSubview:_doubleWaveView];

    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.frame =CGRectMake(0,0,screenW,44);
    gradient.colors = [NSArray arrayWithObjects:(id)kColor(252, 23, 83, 1.0).CGColor,kColor(251, 33, 46, 1).CGColor,nil];
    [self.addWatchBtn addTarget:self action:@selector(addWatchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.addWatchBtn.layer.cornerRadius = 20;
    self.addWatchBtn.layer.masksToBounds = YES;
    [self.addWatchBtn.layer insertSublayer:gradient atIndex:0];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.startPoint = CGPointMake(0, 0);
    gradient1.endPoint = CGPointMake(1, 0);
    gradient1.frame =CGRectMake(0,0,screenW,44);
    gradient1.colors = [NSArray arrayWithObjects:(id)kColor(252, 23, 83, 1.0).CGColor,kColor(251, 33, 46, 1).CGColor,nil];
    [self.gyroBtn addTarget:self action:@selector(gyroBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.gyroBtn.layer.cornerRadius = 20;
    self.gyroBtn.layer.masksToBounds = YES;
    [self.gyroBtn.layer insertSublayer:gradient1 atIndex:0];
    
}

- (void)addWatchBtnClick:(UIButton *)btn{
    JDYAdjustAlertView *adjustAlertView = [JDYAdjustAlertView adjustAlertView];
    adjustAlertView.delegate = self;
    adjustAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    adjustAlertView.frame = CGRectMake(0, 0, screenW, screenH);
    adjustAlertView.flagStr = @"accelerometer";
    adjustAlertView.alertInfoLabel0.text = @"请确保你的手柄直立在稳定平面上(可用手帮助手柄保持稳定)且云台可自由转动";
    adjustAlertView.alertInfoLabel1.text = @"按确认后云台将自动校准";
    [self.view addSubview:adjustAlertView];
    self.adjustAlertView = adjustAlertView;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adjustAlertViewClick:)];
    tapGesture.delegate = self;
    
    [adjustAlertView addGestureRecognizer:tapGesture];

}

- (void)gyroBtnClick:(UIButton *)btn{

    JDYAdjustAlertView *adjustAlertView = [JDYAdjustAlertView adjustAlertView];
    adjustAlertView.delegate = self;
    adjustAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    adjustAlertView.frame = CGRectMake(0, 0, screenW, screenH);
    adjustAlertView.flagStr = @"gyroscope";
    adjustAlertView.alertInfoLabel0.text = @"请确保你的手柄直立在稳定平面上(可用手帮助手柄保持稳定)且云台可自由转动";
    adjustAlertView.alertInfoLabel1.text = @"按确认后云台将自动校准";
    [self.view addSubview:adjustAlertView];
    self.adjustAlertView = adjustAlertView;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adjustAlertViewClick:)];
    tapGesture.delegate = self;
    
    [adjustAlertView addGestureRecognizer:tapGesture];


}

- (void)adjustAlertViewClick:(UITapGestureRecognizer*)gesture{

    [self.adjustAlertView removeFromSuperview];
}

- (void)adjustAlertView:(JDYAdjustAlertView *)adjustAlertView confirmBtn:(UIButton *)confirmBtn flag:(NSString *)flagStr{
    
    
//    [self loadAnimationNamed:@"loading3.json"];
    if ([flagStr isEqualToString:@"accelerometer"]) {
        //加速计校准
        Byte b[5] = {0XAA,0X59,0X02,0X03,0X03};
        [self writeValue:b length:sizeof(b)];
    }else if ([flagStr isEqualToString:@"gyroscope"]){
    
        //陀螺仪校准
        Byte b[5] = {0XAA,0X59,0X02,0X02,0X02};
    
        [self writeValue:b length:sizeof(b)];
    }
}

- (void)loadAnimationNamed:(NSString *)named {
    [self.laAnimation removeFromSuperview];
    self.laAnimation = nil;
    
    self.laAnimation = [LOTAnimationView animationNamed:named];
    CGFloat laAnimationW = self.adjustProgressAlertView.progressView.width;
    CGFloat laAnimationH = 5;
    CGFloat laAnimationX = 0;
    CGFloat laAnimationY = self.adjustProgressAlertView.progressView.height - laAnimationH;
    self.laAnimation.frame = CGRectMake(laAnimationX, laAnimationY, laAnimationW, laAnimationH);
    self.laAnimation.loopAnimation = YES;
    [self.laAnimation play];
    
    self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
    [self.adjustProgressAlertView.progressView addSubview:self.laAnimation];
    [self.adjustProgressAlertView.progressView setNeedsLayout];
}

- (void)setCurrPeripheral:(CBPeripheral *)currPeripheral{
    
    _currPeripheral = currPeripheral;
    
}

- (void)setBaby:(BabyBluetooth *)baby{
    
    NSLog(@"baby -- %@",baby);
    _baby = baby;
    
    
}

//写一个值
-(void)writeValue:(Byte [])b length:(int)length{
    if (self.characteristic0 != nil) {
    
        Byte value[length];
        for (int i =0; i<length; i++) {
            value[i] = b[i];
            NSLog(@"value %x",value[i]);
        }
        NSData *data = [NSData dataWithBytes:&value length:length];
        [self.currPeripheral writeValue:data forCharacteristic:self.characteristic0 type:CBCharacteristicWriteWithResponse];
        
        NSLog(@"writeValue -> %@",data);
    }
   
}

//订阅一个值
-(void)setNotifiy{
    
    __weak typeof(self)weakSelf = self;
    if(self.currPeripheral.state != CBPeripheralStateConnected) {
        NSString *tempStr = [NSString stringWithFormat:@"%@已经断开连接，请重新连接",self.currPeripheral.name];
        [SVProgressHUD showErrorWithStatus:tempStr];
        return;
    }
    if (self.characteristic2.properties & CBCharacteristicPropertyNotify ||  self.characteristic2.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.characteristic2.isNotifying) {
            [self.baby cancelNotify:self.currPeripheral characteristic:self.characteristic];
            
        }else{
            [weakSelf.currPeripheral setNotifyValue:YES forCharacteristic:self.characteristic2];
            NSLog(@"JDYAdjustViewController 已订阅%@--%@",self.currPeripheral,self.characteristic2);
            [self.baby notify:self.currPeripheral
               characteristic:self.characteristic2
                        block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                            NSLog(@"JDYAdjustViewController new value: %@\n",characteristics.value);
                            
                            if (error) {
                                NSLog(@"notify block error%@",error);
                            }else{
                            
                                NSString *temp = [NSString stringWithFormat:@"%@",characteristics.value];
                                temp = [temp componentsSeparatedByString:@"<"].lastObject;
                                temp = [temp componentsSeparatedByString:@">"].firstObject;
                                if ([temp containsString:@"55b007"]) {
                                    NSData * data = characteristics.value;
                                    [self adjustValue:data];
                                }else if ([temp containsString:@"55aa08"]){
                                    NSLog(@"校准temp %@",temp);
                                    NSRange range = NSMakeRange(13, 2);
                                    temp = [temp substringWithRange:range];
                                    
                                    
                                    NSLog(@"校准%@",temp);
                                    JDYFinishAlertView *finishAlertView = [JDYFinishAlertView showInView:self.view];
                                    finishAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
                                    finishAlertView.hidden = YES;
                                    if ([temp isEqualToString:@"14"]) {//陀螺仪校准中

                                        [self setUpAdjustProgressAlertView];
                                    }else if ([temp isEqualToString:@"15"]){//陀螺仪校准成功
                                    
                                        finishAlertView.alertInfoLabel.text = @"陀螺仪校准成功";
                                        [self.adjustProgressAlertView removeFromSuperview];
                                        finishAlertView.hidden = NO;
                                    }else if ([temp isEqualToString:@"1e"]){//加速计校准中
                                        
                                        [self setUpAdjustProgressAlertView];
                                    }else if ([temp isEqualToString:@"1f"]){//加速计校准成功
                                        [self.adjustProgressAlertView removeFromSuperview];
                                        finishAlertView.alertInfoLabel.text = @"加速计校准成功";
                                        finishAlertView.hidden = NO;
                                    }
                                }
                            }
                            
                        }];
        }
    }
    else{
        NSString *tempStr = [NSString stringWithFormat:@"%@已经断开连接，请重新连接",self.characteristic];
        [SVProgressHUD showErrorWithStatus:tempStr];
        return;
    }
    
}

- (void)setUpAdjustProgressAlertView{

    self.adjustProgressAlertView = [JDYAdjustProgressAlertView adjustProgressAlertView];
    self.adjustProgressAlertView.frame = CGRectMake(0, 0, screenW, screenH);
    self.adjustProgressAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    self.adjustProgressAlertView.alertInfoLabel.text = @"正在校准中...";
    [self.view addSubview:self.adjustProgressAlertView];
    
    LHGradientProgress *gradProg = [LHGradientProgress sharedInstance];
    
    CGFloat gradProgW = self.adjustProgressAlertView.progressView.width;
    CGFloat gradProgH = 5;
    CGFloat gradProgX = 0;
    CGFloat gradProgY = self.adjustProgressAlertView.progressView.height - gradProgH;
    gradProg.frame = CGRectMake(gradProgX, gradProgY, gradProgW, gradProgH);
    [gradProg showOnParent:self.adjustProgressAlertView.progressView position:LHProgressPosDown];
    [gradProg setProgress:1];
    [gradProg simulateProgress];
}

- (void)adjustValue:(NSData *)data{
    Byte * resultByte = (Byte *)[data bytes];
    Byte xByte[2] = {resultByte[4],resultByte[3]};
    Byte yByte[2] = {resultByte[6],resultByte[5]};
    Byte zByte[2] = {resultByte[8],resultByte[7]};
    
    long xTemp = [[self numberHexString:[NSString stringWithFormat:@"%x%x",xByte[0],xByte[1]]] longValue];
    long yTemp = [[self numberHexString:[NSString stringWithFormat:@"%x%x",yByte[0],yByte[1]]] longValue];
    long zTemp = [[self numberHexString:[NSString stringWithFormat:@"%x%x",zByte[0],zByte[1]]] longValue];
    NSLog(@"adjustValue %ld--%ld--%ld",xTemp,yTemp,zTemp);
    if (xTemp >32768) {
        xTemp = (xTemp - 65536);
    }
    
    if (yTemp >32768) {
        yTemp = (yTemp - 65536);
    }
    
    if (zTemp >32768) {
        zTemp = (zTemp - 65536);
    }
    
    double x = ((double)xTemp/32768)*360;
    double y = ((double)yTemp/32768)*360;
    double z = ((double)zTemp/32768)*360;
    NSLog(@"adjustValue %f--%f--%f",x,y,z);
    
}

- (NSNumber *)numberHexString:(NSString *)aHexString
{
    // 为空,直接返回.
    if (nil == aHexString)
    {
        return nil;
    }
    
    NSScanner * scanner = [NSScanner scannerWithString:aHexString];
    unsigned long long longlongValue;
    [scanner scanHexLongLong:&longlongValue];
    
    //将整数转换为NSNumber,存储到数组中,并返回.
    NSNumber * hexNumber = [NSNumber numberWithLongLong:longlongValue];
    
    return hexNumber;
    
}

-(void)babyDelegate{
    
    __weak typeof(self)weakSelf = self;
    //设置读取characteristics的委托
    [self.baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
    }];
    //设置发现characteristics的descriptors的委托
    [self.baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            
        }
    }];
    //设置读取Descriptor的委托
    [self.baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        for (int i =0 ; i<descriptors.count; i++) {
            if (descriptors[i]==descriptor) {
                //                UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i inSection:2]];
                NSString *valueStr = [[NSString alloc]initWithData:descriptor.value encoding:NSUTF8StringEncoding];
                NSLog(@"CharacteristicViewController Descriptor valueStr %@",valueStr);
                //                cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",descriptor.value];
            }
        }
        NSLog(@"CharacteristicViewController Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
        
        if (error) {
            NSLog(@"CharacteristicViewController Descriptor error%@",error);
        }
    }];
    
    //设置写数据成功的block
    [self.baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
        
        if (error) {
            NSLog(@"WriteValueForCharacteristicAtChannel error%@",error);
            
        }
        
    }];
    
    //设置通知状态改变的block
    [self.baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    
    
}


- (IBAction)backBtnCLick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}


+ (instancetype)adjustViewController{

    return [[JDYAdjustViewController alloc] initWithNibName:@"JDYAdjustViewController" bundle:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
