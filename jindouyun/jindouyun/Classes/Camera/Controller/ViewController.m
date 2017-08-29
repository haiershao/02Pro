//
//  ViewController.m
//  Jiyi
//
//  Created by yuntai on 2017/6/12.
//  Copyright © 2017年 yuntai. All rights reserved.
//

#import "ViewController.h"
#import <BabyBluetooth.h>
#import <AVFoundation/AVFoundation.h>
#import "PeripheralInfo.h"
#import <Lottie/Lottie.h>
#import <SVProgressHUD.h>
#import "JDYAdjustViewController.h"
#import "JDYWave.h"
#import "JDYRockerSensitivityView.h"
#import "JDYXYZAxisView.h"
#import "LHJoyStick.h"
#import "JDYTravelingShoViewController.h"
#import "JDYAdjustAlertView.h"
#import "JDYAdjustProgressAlertView.h"
#import "LHGradientProgress.h"
#import <AFNetworking.h>
#import "JDYFirmWareFile.h"
#import "JDYFinishAlertView.h"
#import "JDYProgressView.h"

#define channelOnCharacteristicView @"CharacteristicView"
#define channelOnPeropheralView @"peripheralView"
#define RATIO  1280.0/720.0

typedef void(^onComplete)(Byte *blockFileByte,long fileLength);
typedef void(^onfinish)(BOOL finish);
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource, LHJoyStickDelegate, JDYXYZAxisViewDelegta, JDYAdjustAlertViewDelegta>{
    JDYWave *_doubleWaveView;
    BabyBluetooth *baby;
    __block  NSMutableArray *descriptors;
    
    CGPoint rectLeftTopPoint;
    CGPoint rectRightDownPoint
    ;
    
    BOOL isCoverHidden;
    
    //    int xPos;
    int unit;
    int unit1;
    BOOL isUpdateX;
    BOOL isUpdateY;
    BOOL isUpdateZ;
    NSString *flagStr;
    int flag;
    NSInteger rockerRow;
    NSInteger axisRow;
    NSInteger mainRow;
    __block NSArray *rockerArr;
    __block NSString *testStr;
    __block NSArray *testArr;
    BOOL isAllowSend;
    
    BOOL isFinish;
    
    __block long blockLength;
    dispatch_semaphore_t _seam;
    dispatch_semaphore_t _seamY;
    dispatch_semaphore_t _seamZ;
    BOOL signal;
    BOOL isXend;
    BOOL isYend;
    BOOL isZend;
    long totalCount;
    __block int heartFlag;
    _Bool startUpdate;
    BOOL isSend;//是否已发送获取版本号
    BOOL isJoy;//摇杆是否被触摸
    BOOL updateFlag;
    BOOL updateFlag0;
    JDYProgressView *circle;
    CGFloat circleW;
    JDYProgressView *progressView;
}
@property (weak, nonatomic) UIView *coverView;
@property (strong, nonatomic) NSMutableArray *peripheralDataArray;
@property (weak, nonatomic) UITableView *searchTableView;
@property (weak, nonatomic) CBPeripheral *peripheral;
@property __block NSMutableArray *services;
@property (nonatomic,strong)CBCharacteristic *characteristic;
@property (nonatomic,strong)CBCharacteristic *characteristic0;
@property (nonatomic,strong)CBCharacteristic *characteristic1;
@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *moreInfoBtn;
@property (weak, nonatomic) IBOutlet UILabel *connectStatusName;
@property (nonatomic, strong) NSArray *jsonFiles;
@property (nonatomic, copy) NSString *jsonStr0;
@property (nonatomic, copy) NSString *jsonStr1;
@property (nonatomic, strong) LOTAnimationView *laAnimation;
@property (nonatomic, strong) LOTAnimationView *laAnimation1;
@property (weak, nonatomic) IBOutlet UIView *hardwareBGView;
@property (weak, nonatomic) IBOutlet UIButton *updateBtn;
@property (weak, nonatomic) IBOutlet UIImageView *maibBGImageView;
@property (weak, nonatomic) IBOutlet UIView *rockView;
@property (weak, nonatomic) IBOutlet UIView *xyzView;
@property (strong, nonatomic) JDYRockerSensitivityView *subRockView;
@property (strong, nonatomic) JDYXYZAxisView *subAxisView;
@property (nonatomic, strong) NSArray *tempArr;
@property (weak, nonatomic) UITableView *rockerTBView;
@property (weak, nonatomic) UIPickerView *rockerPickerView;
@property (weak, nonatomic) UIPickerView *axisPickerView;
@property (nonatomic, strong) NSArray *mainArr;
@property (weak, nonatomic) IBOutlet UIPickerView *mainPickerView;
@property (weak, nonatomic) IBOutlet UIView *JoyBackView;
@property (weak, nonatomic) LHJoyStick *joystick;
@property (weak, nonatomic) IBOutlet UIView *mainBGPickerView;
@property (weak, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIView *titleView1;
@property (weak, nonatomic) IBOutlet UILabel *pitchAxisLabel;
@property (weak, nonatomic) IBOutlet UILabel *crossRollerLabel;
@property (weak, nonatomic) IBOutlet UILabel *headingAxisLabel;
@property (weak, nonatomic) JDYAdjustAlertView *alertView;
@property (weak, nonatomic) JDYAdjustProgressAlertView *progressAlertView;
@property (weak, nonatomic) JDYFinishAlertView *finishAlertView;
@property (assign, nonatomic) int isNext;
@property (copy  , nonatomic) dispatch_queue_t updateFilequeue;
@property (copy  , nonatomic) dispatch_queue_t updateFilequeueY;
@property (copy  , nonatomic) dispatch_queue_t updateFilequeueZ;
@property (copy  , nonatomic) dispatch_queue_t updateFilequeueZZ;
@property (weak, nonatomic) IBOutlet UIImageView *batteryImageView;
@property (copy, nonatomic) NSString *firmwareUrl;
@property (nonatomic, strong) NSData *updataFileData;
@property (strong, nonatomic) NSString *hardWareVersionStr;
@property (strong, nonatomic) NSString *fileSavePath;
@property (strong, nonatomic) NSString *positionStr;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *joyButton;
@property (weak, nonatomic) IBOutlet UIButton *xyzButton;

@end

static NSString *searchCellID = @"searchCellID";
static NSString *rockerCellID = @"rockerCellID";
static uint32_t  kUpdataFileLength = 0;
static dispatch_source_t _timer;
static dispatch_source_t _heartBeatTimer;

@implementation ViewController

- (dispatch_queue_t)updateFilequeue {
    if (_updateFilequeue == nil) {
        _updateFilequeue = dispatch_queue_create("updateFilequeue", DISPATCH_QUEUE_SERIAL);
    }
    return _updateFilequeue;
}

- (dispatch_queue_t)updateFilequeueY {
    if (_updateFilequeueY == nil) {
        _updateFilequeueY = dispatch_queue_create("updateFilequeueY", DISPATCH_QUEUE_SERIAL);
    }
    return _updateFilequeueY;
}

- (dispatch_queue_t)updateFilequeueZ {
    if (_updateFilequeueZ == nil) {
        _updateFilequeueZ = dispatch_queue_create("updateFilequeueZ", DISPATCH_QUEUE_SERIAL);
    }
    return _updateFilequeueZ;
}

- (dispatch_queue_t)updateFilequeueZZ {
    if (_updateFilequeueZZ == nil) {
        _updateFilequeueZZ = dispatch_queue_create("updateFilequeueZZ", DISPATCH_QUEUE_SERIAL);
    }
    return _updateFilequeueZZ;
}

- (NSArray *)tempArr{

    if (!_tempArr) {
        _tempArr = @[@"高",@"中",@"低"];
    }
    return _tempArr;
}

- (NSArray *)mainArr{
    
    if (!_mainArr) {
        _mainArr = @[@"全跟随",@"定点",@"航向",@"自拍",@"休眠"];
    }
    return _mainArr;
}

- (NSMutableArray *)peripheralDataArray{
    
    if (!_peripheralDataArray) {
        _peripheralDataArray = [NSMutableArray array];
    }
    return _peripheralDataArray;
}

- (NSMutableArray *)descriptors{
    
    if (!descriptors) {
        descriptors = [NSMutableArray array];
    }
    return descriptors;
}

- (NSMutableArray *)services{
    
    if (!_services) {
        _services = [NSMutableArray array];
    }
    return _services;
}

- (NSArray *)jsonFiles{
    
    if (!_jsonFiles) {
        _jsonFiles = [NSArray array];
    }
    return _jsonFiles;
}

- (BOOL)shouldAutorotate{

    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithImage:@"camera" highImage:@"cameraH" target:self action:@selector(cameraClick)];
    if(self.peripheral.state == CBPeripheralStateDisconnected && self.peripheral.name != nil) {
        [self setNotifiy];
        return;
    }
    

    NSLog(@"viewWillAppear %@",self.joystick);
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    NSLog(@"viewDidAppear");
    //这里就可以解决camera控制器一开始预览层不全平问题
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
    [self setUpJoyView];
    NSLog(@"viewDidAppear %@",self.joystick);
    
    
    //    [self refresh:NO];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    NSLog(@"viewWillDisappear");
    [SVProgressHUD dismiss];
    [self.coverView removeFromSuperview];
    if (_timer) {
        dispatch_source_cancel(_timer);
    }
    
}

- (void)viewDidDisappear:(BOOL)animated{
    
    [super viewDidDisappear:animated];
    if (!startUpdate) {
        [self stopReceiveAttitudeAngle];
    }

    
}

- (void)startReceiveAttitudeAngle{

    //请求姿态角
    Byte b[5] = {0XAA,0X60,0X02,0X01,0X01};
    [self writeValue:b length:sizeof(b)];
}

- (void)stopReceiveAttitudeAngle{

    //停止回复姿态角
    Byte b[5] = {0XAA,0X60,0X02,0X00,0X00};
    [self writeValue:b length:sizeof(b)];
}

- (void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    
}

- (void)setUpJoyView{

    CGFloat joyW = self.JoyBackView.width - 2*14;
    CGFloat joyY = 0.5*(self.JoyBackView.height - joyW);
    LHJoyStick *joystick = [LHJoyStick joystick];
    joystick.x = 14;
    joystick.y = joyY;
    joystick.width = joyW;
    joystick.height = joyW;
    joystick.delegate = self;
    [self.JoyBackView addSubview:joystick];
    self.joystick = joystick;
    
    UIImageView *imageTop = [[UIImageView alloc] init];
    imageTop.image = [UIImage imageNamed:@"arrow1"];
    imageTop.width = 21;
    imageTop.height = 14;
    imageTop.x = 0.5*(self.JoyBackView.width - imageTop.height);
    imageTop.y = joyY - imageTop.height;
    [self.JoyBackView addSubview:imageTop];
    
    UIImageView *imageBottom = [[UIImageView alloc] init];
    imageBottom.image = [UIImage imageNamed:@"arrow4"];
    imageBottom.width = 21;
    imageBottom.height = 14;
    imageBottom.x = 0.5*(self.JoyBackView.width - imageBottom.width);
    imageBottom.y = joyY + joystick.height;
    
    [self.JoyBackView addSubview:imageBottom];
    
    [self.JoyBackView bringSubviewToFront:joystick];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.width = screenW;
    self.view.height = screenH;
    isCoverHidden = NO;
    rectLeftTopPoint = CGPointZero;
    rectRightDownPoint = CGPointZero;
    isUpdateX = NO;
    flagStr = @"";
    flag = 0;
    rockerRow = 0;
    axisRow = 0;
    mainRow = 0;
    rockerArr = nil;
    testArr = @[@"1",@"2"];
    unit = 512;
    unit1 = 17;
    testStr = @"oooo";
    isUpdateX = NO;
    isUpdateY = NO;
    isUpdateZ = NO;
    flagStr = @"";
    flag = 0;
    isAllowSend = NO;
    
    blockLength = 0;
    signal = NO;
    isXend = NO;
    isYend = NO;
    isZend = NO;
    totalCount = 0;
    heartFlag = 3;
    startUpdate = NO;
    isSend = NO;
    isJoy = NO;
    self.positionStr = @"";
    updateFlag = NO;
    circleW = 0;
    updateFlag0 = NO;
    
    
    [self setUpSubViews];
    
    self.jsonFiles = [[NSBundle mainBundle] pathsForResourcesOfType:@"json" inDirectory:nil];
    self.jsonStr0 = self.jsonFiles[0];
    self.jsonStr1 = self.jsonFiles[1];
    
    //初始化BabyBluetooth 蓝牙库
    baby = [BabyBluetooth shareBabyBluetooth];
    
    //设置蓝牙委托
    [self babyDelegate];
    
    //3秒没收到姿态角，判定蓝牙断开
    if (startUpdate) {
       [self heartBeat];
    }
    
    [self setUpBatteryView];
    ////////////////////
    
///////
}

- (void)getHaardWareVersion{

    Byte b[5] = {0XAA,0X5f,0X02,0X01,0X01};
    [self writeValue:b length:sizeof(b)];
}

- (void)checkoutVersion{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSDictionary *dic  = [NSDictionary dictionary];
    
    __weak typeof(self)weakSelf = self;
    [manager GET:@"http://192.168.15.113:8080/FileDownload/version/test.json" parameters:dic progress:nil success:
     ^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSLog(@"请求成功---%@---%@",responseObject,[responseObject class]);
         NSDictionary *result = (NSDictionary *)responseObject;
         NSLog(@"result---%@",result);
         weakSelf.firmwareUrl = result[@"FirmwareUrl"];
         JDYFirmWareFile *fileModel = [[JDYFirmWareFile alloc] init];
         fileModel.AppUrl = result[@"AppUrl"];
         fileModel.AppVersion = result[@"AppVersion"];
         fileModel.FirmwareUrl = result[@"FirmwareUrl"];
         fileModel.FirmwareVersion = result[@"FirmwareVersion"];
         NSString *updateFilePath = [[self createPathToMovie:@"updateFile"] stringByAppendingPathComponent:[NSString stringWithFormat:@"hardwareUpdateFile.bin"]];
         
         fileModel.localPath = updateFilePath;
         weakSelf.fileSavePath = updateFilePath;
         NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:fileModel];
         NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
         [UserDefaults setObject:modelData forKey:FirmwareVersionKey];
         [UserDefaults setObject:updateFilePath forKey:FirmwareLocalPathKey];
         [UserDefaults synchronize];
         
//         NSData *unData = [UserDefaults objectForKey:FirmwareVersionKey];
//         JDYFirmWareFile *unmodel = [NSKeyedUnarchiver unarchiveObjectWithData:unData];
//         NSLog(@"fileModel %@",unmodel.FirmwareUrl);
         NSUserDefaults *numUserDefaults = [NSUserDefaults standardUserDefaults];
         weakSelf.hardWareVersionStr = [numUserDefaults objectForKey:FirmwareNumFromHardWareKey];
         int temp0 = [weakSelf.hardWareVersionStr intValue];
         int temp1 = [fileModel.FirmwareVersion intValue];
         if (temp1 > temp0) {
             [self setUpNewVersionAlertView];
//             [weakSelf downloadUpdateFile:weakSelf.firmwareUrl localPath:updateFilePath];
         }
         
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         
         NSLog(@"请求失败--%@",error);
     }];
    
}

- (void)downloadUpdateFile:(NSString *)firmwareUrl localPath:(NSString *)localPath{

    [self updatingAlertView:@"正在下载固件"];
    //1.创建会话管理者
    AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
    NSURL *url = [NSURL URLWithString:firmwareUrl];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //2.下载文件
    /*
     第一个参数:请求对象
     第二个参数:progress 进度回调 downloadProgress
     第三个参数:destination 回调(目标位置)
     有返回值
     targetPath:临时文件路径
     response:响应头信息
     第四个参数:completionHandler 下载完成之后的回调
     filePath:最终的文件路径
     */
    
    /*
     第一个参数：请求对象
     第二个参数：进度回调
     downloadProgress.completedUnitCount :已经下载的数据
     downloadProgress.totalUnitCount：数据的总大小
     第三个参数：destination回调，该block需要返回值（NSURL类型），告诉系统应该把文件剪切到什么地方
     targetPath：文件的临时保存路径tmp，随时可能被删除
     response：响应头信息
     第四个参数：completionHandler请求完成后回调
     response：响应头信息
     filePath：文件的保存路径，即destination回调的返回值
     error：错误信息
     */
    NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //监听下载进度
        //completedUnitCount 已经下载的数据大小
        //totalUnitCount     文件数据的中大小
        NSLog(@"downloadProgress-> %f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        /**
         * 1:1：请求路径：NSUrl *url = [NSUrl urlWithString:path];从网络请求路径  2：把本地的file文件路径转成url，NSUrl *url = [NSURL fileURLWithPath:fullPath]；
         2：返回值是一个下载文件的路径
         *
         */
        NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
        
        NSLog(@"targetPath:%@",targetPath);
        NSLog(@"fullPath:%@",fullPath);
        
        return [NSURL fileURLWithPath:fullPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        /**
         *filePath:下载后文件的保存路径
         */
        NSLog(@"filePath %@ -- %@",filePath, error);
        if (error) {
//            [SVProgressHUD showInfoWithStatus:@"固件下载失败"];
            [self setUpAlertView:@"固件下载失败"];
        }else{
        
            NSData *data = [NSData dataWithContentsOfFile:(NSString *)filePath];
            if ([data writeToFile:localPath atomically:YES]) {
                NSLog(@"localPath 写入成功 -- %@",localPath);
                [self.progressAlertView removeFromSuperview];
                
                if (self.characteristic1 != nil && self.peripheral.state == CBPeripheralStateConnected) {
                   
                    [baby AutoReconnect:self.peripheral];
                     //关机设备
                    [self shutdown];
                    [self setUpAlertView:@"设备关机，请打开设备"];
//                    [baby cancelAllPeripheralsConnection];

//                    NSUserDefaults *UserDefaults = [NSUserDefaults standardUserDefaults];
//                    PeripheralInfo *model = [[PeripheralInfo alloc] init];
//                    model.peripheral = self.peripheral;
//                    NSData *modelData = [NSKeyedArchiver archivedDataWithRootObject:model];
//                    [UserDefaults setObject:modelData forKey:UpdatingPeripheralKey];
//                    [UserDefaults synchronize];
                }
            }else{
                
                NSLog(@"localPath 写入失败");
                
            }
        }
        
        
        
    }];
    

    [download resume];
    
}

- (void)shutdown{

    Byte b[5] = {0XAA,0X5b,0X02,0X01,0X01};
    [self writeValue:b length:sizeof(b)];
    sleep(2);//等个两秒，固件那边需要时间将硬件彻底关机
}

- (NSMutableString *)createPathToMovie:(NSString *)listStr{
    
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSMutableString *path = [NSMutableString stringWithString:[documents firstObject]];
    NSString *str = [NSString stringWithFormat:@"/JiYiYunTaiAlbum/%@",listStr];
    [path appendString:str];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return path;
    
}

- (void)setUpBatteryView{

    UIView *batteryView = [[UIView alloc] init];
    batteryView.backgroundColor = [UIColor greenColor];
    batteryView.frame = CGRectMake(2, 2, self.batteryImageView.width - 7, self.batteryImageView.height - 4);
    
    circleW = self.batteryImageView.width - 7;
    
    progressView = [[JDYProgressView alloc] initWithFrame:CGRectMake(2, 2, self.batteryImageView.width - 7, self.batteryImageView.height - 4)];

    [self sliderMethod:0.09];
    [self.batteryImageView addSubview:progressView];
    
}

-(void)sliderMethod:(CGFloat)value
{
    progressView.progressValue = value;
}

- (void)sendValue{
    
    NSTimeInterval period = 100; //设置时间间隔
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), period * NSEC_PER_MSEC, 0);
    // 事件回调
    dispatch_source_set_event_handler(_timer, ^{
        NSString *tempStr = @"000000";
        if (rockerArr.count == 6) {
            tempStr = [NSString stringWithFormat:@"%@%@%@%@%@%@",rockerArr[0],rockerArr[1],rockerArr[2],rockerArr[3],rockerArr[4],rockerArr[5]];
        }
        NSData *rockerData = [self convertHexStrToData:tempStr];
        Byte *rockerByte = (Byte *)[rockerData bytes];
        
//        NSLog(@"==================");
//        for (int i = 0; i<6; i++) {
//            NSLog(@"rockerArr %x",rockerByte[i]);
//        }
        if (isJoy) {
           [self writeValue:rockerByte length:6];
        }
        
        if ([self.positionStr isEqualToString:@"回中"]) {
            
            isJoy = NO;
        }
    });
    
    // 开启定时器
    dispatch_resume(_timer);
}

- (void)heartBeat{

    
      
        NSTimeInterval period = 1000; //设置时间间隔
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _heartBeatTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_source_set_timer(_heartBeatTimer, dispatch_walltime(NULL, 0), period * NSEC_PER_MSEC, 0);
        // 事件回调
        dispatch_source_set_event_handler(_heartBeatTimer, ^{
            if (self.peripheral.state == CBPeripheralStateConnected) {
            
                heartFlag --;
//                NSLog(@"heartFlag -- %d",heartFlag);
            }
            
            
        });
        
        // 开启定时器
        dispatch_resume(_heartBeatTimer);
    
}

- (IBAction)cameraActionClick:(UIButton *)sender {
    JDYAdjustViewController *adjustVc = [JDYAdjustViewController adjustViewController];
    adjustVc.view.frame = CGRectMake(0, 0, screenW, screenH);
    [self presentViewController:adjustVc animated:NO completion:nil];
}

- (void)setUpSubViews{
    
    self.mainPickerView.delegate = self;
    self.mainPickerView.dataSource = self;
    mainRow = 2;
    [self.mainPickerView selectRow:2 inComponent:0 animated:NO];
    [self.mainPickerView reloadComponent:0];
    
    UITapGestureRecognizer *tapGesture0 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rockViewCell:)];
    tapGesture0.delegate = self;
    
    [self.rockView addGestureRecognizer:tapGesture0];
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(xyzViewCell:)];
    tapGesture1.delegate = self;
    
    [self.xyzView addGestureRecognizer:tapGesture1];
    
    CAGradientLayer *gradient0 = [CAGradientLayer layer];
    gradient0.startPoint = CGPointMake(0, 0);
    gradient0.endPoint = CGPointMake(1, 0);
    gradient0.frame =CGRectMake(0,0,self.joyButton.width,self.joyButton.height);
    gradient0.colors = [NSArray arrayWithObjects:(id)kColor(252, 23, 83, 1.0).CGColor,kColor(251, 33, 46, 1).CGColor,nil];
    self.joyButton.layer.cornerRadius = 15;
    self.joyButton.layer.masksToBounds = YES;
    [self.joyButton.layer insertSublayer:gradient0 atIndex:0];
    
    CAGradientLayer *gradient1 = [CAGradientLayer layer];
    gradient1.startPoint = CGPointMake(0, 0);
    gradient1.endPoint = CGPointMake(1, 0);
    gradient1.frame =CGRectMake(0,0,self.xyzButton.width,self.xyzButton.height);
    gradient1.colors = [NSArray arrayWithObjects:(id)kColor(252, 23, 83, 1.0).CGColor,kColor(251, 33, 46, 1).CGColor,nil];
    self.xyzButton.layer.cornerRadius = 15;
    self.xyzButton.layer.masksToBounds = YES;
    [self.xyzButton.layer insertSublayer:gradient1 atIndex:0];
    
}

- (IBAction)rockBtnClick:(UIButton *)sender {
    
    [SVProgressHUD dismiss];
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    JDYRockerSensitivityView *rockView = [JDYRockerSensitivityView rockerSensitivityView];
    rockView.width = screenW;
    rockView.height = screenH;
    rockView.x = 0;
    rockView.y = 0;
    rockView.rockerPickerView.delegate = self;
    rockView.rockerPickerView.dataSource = self;
    self.rockerPickerView = rockView.rockerPickerView;
    rockerRow = 1;
    [rockView.rockerPickerView selectRow:1 inComponent:0 animated:NO];
    [rockView.rockerPickerView reloadComponent:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rockView:)];
    tapGesture.delegate = self;
    
    [rockView addGestureRecognizer:tapGesture];
    [self.view addSubview:rockView];
    self.subRockView = rockView;
}

- (void)rockViewCell:(UITapGestureRecognizer*)gesture{
    [SVProgressHUD dismiss];
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    JDYRockerSensitivityView *rockView = [JDYRockerSensitivityView rockerSensitivityView];
    rockView.width = screenW;
    rockView.height = screenH;
    rockView.x = 0;
    rockView.y = 0;
    rockView.rockerPickerView.delegate = self;
    rockView.rockerPickerView.dataSource = self;
    self.rockerPickerView = rockView.rockerPickerView;
    rockerRow = 1;
    [rockView.rockerPickerView selectRow:1 inComponent:0 animated:NO];
    [rockView.rockerPickerView reloadComponent:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(rockView:)];
    tapGesture.delegate = self;
    
    [rockView addGestureRecognizer:tapGesture];
    [self.view addSubview:rockView];
    self.subRockView = rockView;
}

- (void)rockView:(UITapGestureRecognizer*)gesture{
    
    [self.subRockView removeFromSuperview];
}
- (IBAction)xyzBtnClick:(UIButton *)sender {
    
    [SVProgressHUD dismiss];
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    JDYXYZAxisView *AxisView = [JDYXYZAxisView XYZAxisView];
    AxisView.width = screenW;
    AxisView.height = screenH;
    AxisView.x = 0;
    AxisView.y = 0;
    AxisView.axisView.delegate = self;
    AxisView.axisView.dataSource = self;
    AxisView.delegate = self;
    self.axisPickerView = AxisView.axisView;
    self.subAxisView = AxisView;
    axisRow = 1;
    [AxisView.axisView selectRow:1 inComponent:0 animated:NO];
    [AxisView.axisView reloadComponent:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(axisView:)];
    tapGesture.delegate = self;
    
    [AxisView addGestureRecognizer:tapGesture];
    [self.view addSubview:AxisView];
}

- (void)xyzViewCell:(UITapGestureRecognizer*)gesture{
    [SVProgressHUD dismiss];
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    JDYXYZAxisView *AxisView = [JDYXYZAxisView XYZAxisView];
    AxisView.width = screenW;
    AxisView.height = screenH;
    AxisView.x = 0;
    AxisView.y = 0;
    AxisView.axisView.delegate = self;
    AxisView.axisView.dataSource = self;
    AxisView.delegate = self;
    self.axisPickerView = AxisView.axisView;
    self.subAxisView = AxisView;
    axisRow = 1;
    [AxisView.axisView selectRow:1 inComponent:0 animated:NO];
    [AxisView.axisView reloadComponent:0];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(axisView:)];
    tapGesture.delegate = self;
    
    [AxisView addGestureRecognizer:tapGesture];
    [self.view addSubview:AxisView];
}

- (void)axisView:(UITapGestureRecognizer *)gesture{

    [self.subAxisView removeFromSuperview];
}

//一共多少列
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    
    return 1;
}
//每列对应多少行
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == self.rockerPickerView || pickerView == self.axisPickerView) {
       return self.tempArr.count;
    }else{
    
        return self.mainArr.count;
    }
    
}
//每列每行显示的数据是什么
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == self.rockerPickerView || pickerView == self.axisPickerView) {
        return self.tempArr[row];
    }else{
        
        return self.mainArr[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.minimumScaleFactor = 8;
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        pickerLabel.tag=row;
        if (rockerRow == row && pickerView == self.rockerPickerView) {
            pickerLabel.textColor = [UIColor redColor];
        }else if (axisRow == row && pickerView == self.axisPickerView){

            pickerLabel.textColor = [UIColor redColor];
        }else if (mainRow == row && pickerView == self.mainPickerView){
            
            pickerLabel.textColor = [UIColor redColor];
        }else{
        
            pickerLabel.textColor = kColor(134, 135, 142, 1);
        }
        
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    
    return pickerLabel;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    
    if (pickerView == self.rockerPickerView || pickerView == self.axisPickerView) {

        if (pickerView == self.axisPickerView) {
            axisRow = row;
            if (0 == row) {
                [self.xyzButton setTitle:@"高" forState:UIControlStateNormal];
            }else if (1 == row){
            
                [self.xyzButton setTitle:@"中" forState:UIControlStateNormal];
            }else if (2 == row){
            
                [self.xyzButton setTitle:@"低" forState:UIControlStateNormal];
            }
        }
        if (pickerView == self.rockerPickerView) {
            rockerRow = row;
            if (0 == row) {
                [self.joyButton setTitle:@"高" forState:UIControlStateNormal];
            }else if (1 == row){
                
                [self.joyButton setTitle:@"中" forState:UIControlStateNormal];
            }else if (2 == row){
                
                [self.joyButton setTitle:@"低" forState:UIControlStateNormal];
            }
        }
        [pickerView reloadComponent:0];
    }else{
        
        mainRow = row;
        
        if (0 == row) {
          
            Byte b[6] = {0XAA,0X58,0X03,0X06,0X03,0x09};
            [self writeValue:b length:6];
        }else if (1 == row){
        
            Byte b[6] = {0XAA,0X58,0X03,0X06,0X02,0x08};
            [self writeValue:b length:6];
        }else if (2 == row){
            
            Byte b[6] = {0XAA,0X58,0X03,0X06,0X01,0x07};
            [self writeValue:b length:6];
        }else if (3 == row){
            
            Byte b[6] = {0XAA,0X58,0X03,0X06,0X04,0x0a};
            [self writeValue:b length:6];
        }else if (4 == row){
            
            Byte b[6] = {0XAA,0X58,0X03,0X06,0X05,0x0b};
            [self writeValue:b length:6];
        }
//        else if (5 == row){
//        
//            Byte b[6] = {0XAA,0X58,0X03,0X06,0X06,0x0c};
//            [self writeValue:b length:6];
//        }
        
        [pickerView reloadComponent:0];
    }
    
}

- (void)discoverCharacteristicsForService:(NSNotification *)note{
    NSLog(@"发现特征通知 %@",note.object);
    NSDictionary *dict = note.object;
    CBPeripheral *peripheral = dict[@"peripheral"];
    CBService *service = dict[@"service"];
    for (CBCharacteristic *characteristic in service.characteristics) {
        //订阅一个特征的值
        [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        NSLog(@"discoverCharacteristicsForService %@ -- %@",peripheral, characteristic);
    }
    
}

#pragma mark -蓝牙配置和操作

//蓝牙网关初始化和委托方法设置
-(void)babyDelegate{
    
    __weak typeof(self) weakSelf = self;
    [baby setBlockOnCentralManagerDidUpdateState:^(CBCentralManager *central) {
        if (central.state == CBCentralManagerStatePoweredOn) {
//            [SVProgressHUD showInfoWithStatus:@"设备打开成功，开始扫描设备"];
            NSLog(@"设备打开成功，开始扫描设备");
        }
    }];
    
    //设置扫描到设备的委托
    [baby setBlockOnDiscoverToPeripherals:^(CBCentralManager *central, CBPeripheral *peripheral, NSDictionary *advertisementData, NSNumber *RSSI) {
        NSLog(@"搜索到了设备:%@  advertisementData:%@",peripheral.name, advertisementData);
        dispatch_async(dispatch_get_main_queue(), ^{
            //更新UI操作
            //.....
            weakSelf.coverView.hidden = NO;
            [weakSelf.laAnimation pause];
            [weakSelf.laAnimation removeFromSuperview];
        });
        
        if ([peripheral.name isEqualToString:@"MI"]) {
            [baby AutoReconnect:peripheral];
        }
        
        [weakSelf insertTableView:peripheral advertisementData:advertisementData RSSI:RSSI];
    }];
    
    
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristics:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        for (CBCharacteristic *c in service.characteristics) {
            NSLog(@"charateristic name is :%@",c.UUID);
        }
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        NSString *str = [[NSString alloc]initWithData:characteristics.value encoding:NSUTF8StringEncoding];
        NSLog(@"characteristic name:%@ value str is:%@",characteristics.UUID,str);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristic:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptors:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    
    //设置查找设备的过滤器
    [baby setFilterOnDiscoverPeripherals:^BOOL(NSString *peripheralName, NSDictionary *advertisementData, NSNumber *RSSI) {
        
        //设置查找规则是名称大于0 ， the search rule is peripheral.name length > 0
        if (peripheralName.length >0) {
            NSLog(@"peripheralName %@",peripheralName);
            return YES;
        }
        NSLog(@"peripheralName 为空");
        return NO;
    }];
    
    
    [baby setBlockOnCancelAllPeripheralsConnectionBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelAllPeripheralsConnectionBlock");
    }];
    
    [baby setBlockOnCancelScanBlock:^(CBCentralManager *centralManager) {
        NSLog(@"setBlockOnCancelScanBlock");
    }];
    
    //示例:
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    //连接设备->
    [baby setBabyOptionsWithScanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:nil scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
    
    
}

#pragma mark -UIViewController 方法
//插入table数据
-(void)insertTableView:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
    
    
    
    NSArray *peripherals = [_peripheralDataArray valueForKey:@"peripheral"];
    
    if(![peripherals containsObject:peripheral]) {
        NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:peripherals.count inSection:0];
        [indexPaths addObject:indexPath];
        
        NSMutableDictionary *item = [[NSMutableDictionary alloc] init];
        [item setValue:peripheral forKey:@"peripheral"];
        [item setValue:RSSI forKey:@"RSSI"];
        [item setValue:advertisementData forKey:@"advertisementData"];
        [_peripheralDataArray addObject:item];
        
        [self.searchTableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)searchBtnAction:(UIButton *)sender {
    
    if(self.peripheral.state == CBPeripheralStateConnected) {
        NSString *tempStr = [NSString stringWithFormat:@"%@已连接",self.peripheral.name];
        [SVProgressHUD showErrorWithStatus:tempStr];
        return;
    }
    
    updateFlag0 = YES;
    
    //    [self _loadAnimationFromURLString:self.jsonStr0];
    NSArray *components = [self.jsonStr0 componentsSeparatedByString:@"/"];
    [self _loadAnimationNamed:components.lastObject];
    self.laAnimation.loopAnimation = YES;
    [self.laAnimation play];
    [self coverBGView];
    
    
    //停止之前的连接
    [baby cancelAllPeripheralsConnection];
    //设置委托后直接可以使用，无需等待CBCentralManagerStatePoweredOn状态。
    baby.scanForPeripherals().begin();
    //baby.scanForPeripherals().begin().stop(10);
    
    
}

- (IBAction)adjustBtnClick:(UIButton *)sender {
    
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    
    JDYAdjustViewController *adjustVc = [JDYAdjustViewController adjustViewController];
    adjustVc.view.frame = CGRectMake(0, 0, screenW, screenH);
    adjustVc.currPeripheral = self.peripheral;
    adjustVc.baby = self->baby;
    
    adjustVc.services = self.services;
    NSLog(@"weakSelf.peripheral %@--%@",self.peripheral.services,adjustVc.baby);
    [self.laAnimation1 removeFromSuperview];
    [self presentViewController:adjustVc animated:NO completion:nil];
}

- (void)_loadAnimationFromURLString:(NSString *)URL {
    [self.laAnimation removeFromSuperview];
    self.laAnimation = nil;
    
    self.laAnimation = [[LOTAnimationView alloc] initWithContentsOfURL:[NSURL URLWithString:URL]];
    self.laAnimation.frame = CGRectMake(0, 0, screenW, screenH);
    self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.laAnimation];
    [self.view setNeedsLayout];
}

- (void)_loadAnimationNamed:(NSString *)named {
    [self.laAnimation removeFromSuperview];
    self.laAnimation = nil;
    
    self.laAnimation = [LOTAnimationView animationNamed:named];
    CGFloat laAnimationW = 100;
    CGFloat laAnimationH = 100;
    CGFloat laAnimationX = 0.5*(screenW - laAnimationW);
    CGFloat laAnimationY = 0.5*(screenH - laAnimationW);
    self.laAnimation.frame = CGRectMake(laAnimationX, laAnimationY, laAnimationW, laAnimationH);
    
    
    self.laAnimation.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:self.laAnimation];
    [self.view setNeedsLayout];
}

- (void)coverBGView{
    
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    view.x = 0;
    view.y = 0;
    view.width = screenW;
    view.height = screenH;
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewAction)];
    tapGesture.delegate = self;
    
    [view addGestureRecognizer:tapGesture];
    self.coverView = view;
    self.coverView.hidden = YES;
    
    // 添加到窗口
    [self.view addSubview:view];
    
    UITableView *searchTableView = [[UITableView alloc] init];
    searchTableView.delegate = self;
    searchTableView.dataSource = self;
    searchTableView.x = 50;
    searchTableView.y = 150;
    searchTableView.width = screenW - 2*searchTableView.x;
    searchTableView.height = screenH - 2*searchTableView.y;
    [self.coverView addSubview:searchTableView];
    self.searchTableView = searchTableView;
    
    UIView *topView = [[UIView alloc] init];
    topView.width = searchTableView.width;
    topView.height = 40;
    topView.x = searchTableView.x;
    topView.y = searchTableView.y - topView.height;
    [self.coverView addSubview:topView];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.frame =CGRectMake(0,0,topView.width,topView.height);
    gradient.colors = [NSArray arrayWithObjects:(id)kColor(252, 23, 83, 0.5).CGColor,kColor(251, 33, 46, 1).CGColor,nil];
    [topView.layer insertSublayer:gradient atIndex:0];
    
    UILabel *connectDeviceLabel = [[UILabel alloc] init];
    connectDeviceLabel.width = 100;
    connectDeviceLabel.height = 40;
    connectDeviceLabel.x = 0.5*(topView.width - connectDeviceLabel.width);
    connectDeviceLabel.y = 0;
    connectDeviceLabel.text = @"连接设备";
    connectDeviceLabel.font = [UIFont systemFontOfSize:18];
    connectDeviceLabel.textColor = [UIColor whiteColor];
    [topView addSubview:connectDeviceLabel];
    
    UIButton *closeBtn = [[UIButton alloc] init];
    closeBtn.width = 100;
    closeBtn.height = 40;
    closeBtn.x = CGRectGetMaxX(connectDeviceLabel.frame);
    closeBtn.y = 0;
    [closeBtn setImage:[UIImage imageNamed:@"no"] forState:UIControlStateNormal];
    [closeBtn addTarget:self action:@selector(closeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:closeBtn];
}

- (void)closeBtnClick:(UIButton *)sender{
    
    //    self.coverView.hidden = YES;
    
    [self.coverView removeFromSuperview];
    
    //    self.coverView = nil;
    
}

#pragma mark - ------------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        
        return NO;
    }
    return YES;
}

- (void)viewAction{
    
    //    self.coverView.hidden = YES;
    [self.coverView removeFromSuperview];
    //    self.coverView = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
      return self.peripheralDataArray.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
        UITableViewCell *searchCell = [self.searchTableView dequeueReusableCellWithIdentifier:searchCellID];
        NSDictionary *item = [self.peripheralDataArray objectAtIndex:indexPath.row];
        CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
        NSDictionary *advertisementData = [item objectForKey:@"advertisementData"];
        NSNumber *RSSI = [item objectForKey:@"RSSI"];
        
        if (!searchCell) {
            searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:searchCellID];
            searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        searchCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //peripheral的显示名称,优先用kCBAdvDataLocalName的定义，若没有再使用peripheral name
        NSString *peripheralName;
        if ([advertisementData objectForKey:@"kCBAdvDataLocalName"]) {
            peripheralName = [NSString stringWithFormat:@"%@",[advertisementData objectForKey:@"kCBAdvDataLocalName"]];
        }else if(!([peripheral.name isEqualToString:@""] || peripheral.name == nil)){
            peripheralName = peripheral.name;
        }else{
            peripheralName = [peripheral.identifier UUIDString];
        }
        
        searchCell.textLabel.text = peripheralName;
        //信号和服务
        searchCell.detailTextLabel.text = [NSString stringWithFormat:@"RSSI:%@",RSSI];
        return searchCell;

}

- (void)loadAnimationNamed:(NSString *)named cell:(UITableViewCell *)cell{
//    [self.laAnimation1 removeFromSuperview];
//    self.laAnimation1 = nil;
//    
//    self.laAnimation1 = [LOTAnimationView animationNamed:named];
//    CGFloat laAnimationW = 40;
//    CGFloat laAnimationH = 40;
//    CGFloat laAnimationX = cell.width - laAnimationW;
//    CGFloat laAnimationY = 0;
//    
//    self.laAnimation1.frame = CGRectMake(laAnimationX, laAnimationY, laAnimationW, laAnimationH);
//    
//    
//    self.laAnimation1.contentMode = UIViewContentModeScaleAspectFit;
//    [cell addSubview:self.laAnimation1];
//    [self.view setNeedsLayout];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = [self.peripheralDataArray objectAtIndex:indexPath.row];
    CBPeripheral *peripheral = [item objectForKey:@"peripheral"];
    self.peripheral = peripheral;
    
    NSIndexPath *indexPathRow = [tableView indexPathForSelectedRow];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPathRow];
    NSArray *components = [self.jsonStr1 componentsSeparatedByString:@"/"];
    [self loadAnimationNamed:components.lastObject cell:cell];
    self.laAnimation.loopAnimation = YES;
    [self.laAnimation play];
    
    
    
    //停止扫描
    [baby cancelScan];
    [self babyDelegate2];
    //开始连接设备
    //    if (self.peripheral.state != CBPeripheralStateConnected) {
    //
    //        [baby connectBaby:baby peripheral:peripheral peripheralView:channelOnPeropheralView];
    //    }
    [self refresh:NO];
    //    baby.having(peripheral).and.channel(channelOnPeropheralView).then.connectToPeripherals().discoverServices().discoverCharacteristics().readValueForCharacteristic().discoverDescriptorsForCharacteristic().readValueForDescriptors().begin();
    
    
}

- (void)refresh:(BOOL)reconnect {
    if (self.peripheral.state != CBPeripheralStateConnected) {
        //        [SVProgressHUD showWithStatus:[NSString stringWithFormat:@"设备：%@--连接中...", self.peripheral.name]];
        [baby cancelAllPeripheralsConnection];
        reconnect = YES;
    }
    if (reconnect) {
        [baby connectBaby:baby peripheral:self.peripheral peripheralView:channelOnPeropheralView];
    }
    else {
        [self.searchTableView reloadData];
    }
}

- (void)babyDelegate2{
    
    //*******************************************连接用到的委托******************************************
    BabyRhythm *rhythm = [[BabyRhythm alloc]init];
    
    __weak typeof(self) weakSelf = self;
    //设置设备连接成功的委托,同一个baby对象，使用不同的channel切换委托回调
    [baby setBlockOnConnectedAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral) {
        
        NSDictionary *dict = @{
                               @"currPeripheral":peripheral,
                               
                               };
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewControllerPeripheralConnected" object:dict];
        //            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接成功",peripheral.name]];
        weakSelf.connectStatusName.text = [NSString stringWithFormat:@"已连接%@",peripheral.name];
        
        
    }];
    
    //设置设备连接失败的委托
    [baby setBlockOnFailToConnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        NSLog(@"设备：%@--连接失败",peripheral.name);
        [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--连接失败",peripheral.name]];
        [weakSelf performSelector:@selector(refresh:) withObject:@(YES) afterDelay:1];
    }];
    
    //设置设备断开连接的委托
    [baby setBlockOnDisconnectAtChannel:channelOnPeropheralView block:^(CBCentralManager *central, CBPeripheral *peripheral, NSError *error) {
        
        if (!error) {
            [SVProgressHUD showInfoWithStatus:[NSString stringWithFormat:@"设备：%@--断开失败",peripheral.name]];
            [weakSelf performSelector:@selector(refresh:) withObject:@(YES) afterDelay:1];
            [weakSelf.searchBtn setTitle:@"连接设备" forState:UIControlStateNormal];
        }else{
        
            NSLog(@"设备：%@--断开连接 error: %@",peripheral.name,error);
        }
        
    }];
    
    //设置发现设备的Services的委托
    [baby setBlockOnDiscoverServicesAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, NSError *error) {
        
        
        [rhythm beats];
    }];
    //设置发现设service的Characteristics的委托
    [baby setBlockOnDiscoverCharacteristicsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBService *service, NSError *error) {
        NSLog(@"===service name:%@",service.UUID);
        //插入row到tableview
        //        [weakSelf insertRowToTableView:service];
        
    }];
    //设置读取characteristics的委托
    [baby setBlockOnReadValueForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        NSLog(@"babyDelegate2 characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        weakSelf.coverView.hidden = YES;
        NSInteger i = 0;
        for (CBService *s in peripheral.services) {
            i++;
            ///插入section到tableview
            [weakSelf insertservices:s];

//            NSLog(@"----------------------------------%@",s);
            
        }
        
        [weakSelf initCharacteristic];
        
        if ((i = peripheral.services.count)&&self.services.count) {
            if (!isSend) {
                if (weakSelf.characteristic1) {
                    isSend = YES;
                    
                    [self.xyzButton setTitle:@"中" forState:UIControlStateNormal];
                    [self.joyButton setTitle:@"中" forState:UIControlStateNormal];
                    
                    [weakSelf setNotifiy];
                    [NSThread sleepForTimeInterval:0.1];
                    if (!startUpdate) {
                        //请求姿态角
                        [weakSelf startReceiveAttitudeAngle];
                        [NSThread sleepForTimeInterval:0.5];
                        [[NSOperationQueue new] addOperationWithBlock:^{
                            //发送摇杆位置信息
                            [self sendValue];
                        }];
                    }
                    
                    [NSThread sleepForTimeInterval:1];
                    [weakSelf getHaardWareVersion];
                    
                    [weakSelf.searchButton setTitle:[NSString stringWithFormat:@"已连接%@",weakSelf.peripheral.name] forState:UIControlStateNormal];
                }
                
            }
            if (weakSelf.characteristic1) {
            
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSString *str = [userDefaults objectForKey:FirmwareIsSucessKey];
                
                if ([str isEqualToString:@"NO"] && updateFlag0) {
                    updateFlag0 = NO;
                    updateFlag = YES;
                    isUpdateX = YES;
                    startUpdate = YES;
                    if (isSend) {
                        isSend = NO;
                        [weakSelf setNotifiy];
                    }
                    
                }
                
                if (startUpdate) {
                    
                    if (updateFlag) {
                        updateFlag = NO;
                        NSLog(@"重连成功");
//                        [weakSelf stopReceiveAttitudeAngle];
//                        sleep(1);
                        [weakSelf startSendX];
                        sleep(1);
                    }
                    
                }
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                JDYAdjustViewController *adjustVc = [JDYAdjustViewController adjustViewController];
                adjustVc.view.frame = CGRectMake(0, 0, screenW, screenH);
                adjustVc.currPeripheral = weakSelf.peripheral;
                adjustVc.baby = self->baby;
                
                adjustVc.services = weakSelf.services;
                NSLog(@"weakSelf.peripheral %@--%@",weakSelf.peripheral.services,adjustVc.baby);
                [weakSelf.laAnimation1 removeFromSuperview];
//                [weakSelf presentViewController:adjustVc animated:NO completion:nil];
            });
            
        }
        
        NSString *str = [[NSString alloc] initWithData:characteristics.value encoding:NSUTF8StringEncoding];
        NSLog(@"babyDelegate2 characteristic name:%@ value str is:%@",characteristics.UUID,str);
    }];
    //设置发现characteristics的descriptors的委托
    [baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            NSLog(@"CBDescriptor name is :%@",d.UUID);
        }
    }];
    //设置读取Descriptor的委托
    [baby setBlockOnReadValueForDescriptorsAtChannel:channelOnPeropheralView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
        NSLog(@"Descriptor name:%@ value is:%@",descriptor.characteristic.UUID, descriptor.value);
    }];
    
    //读取rssi的委托
    [baby setBlockOnDidReadRSSI:^(NSNumber *RSSI, NSError *error) {
        NSLog(@"setBlockOnDidReadRSSI:RSSI:%@",RSSI);
    }];
    
    
    //设置beats break委托
    [rhythm setBlockOnBeatsBreak:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsBreak call");
        
        //如果完成任务，即可停止beat,返回bry可以省去使用weak rhythm的麻烦
        //        if (<#condition#>) {
        //            [bry beatsOver];
        //        }
        
    }];
    
    //设置beats over委托
    [rhythm setBlockOnBeatsOver:^(BabyRhythm *bry) {
        NSLog(@"setBlockOnBeatsOver call");
    }];
    
    //扫描选项->CBCentralManagerScanOptionAllowDuplicatesKey:忽略同一个Peripheral端的多个发现事件被聚合成一个发现事件
    NSDictionary *scanForPeripheralsWithOptions = @{CBCentralManagerScanOptionAllowDuplicatesKey:@YES};
    /*连接选项->
     CBConnectPeripheralOptionNotifyOnConnectionKey :当应用挂起时，如果有一个连接成功时，如果我们想要系统为指定的peripheral显示一个提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnDisconnectionKey :当应用挂起时，如果连接断开时，如果我们想要系统为指定的peripheral显示一个断开连接的提示时，就使用这个key值。
     CBConnectPeripheralOptionNotifyOnNotificationKey:
     当应用挂起时，使用该key值表示只要接收到给定peripheral端的通知就显示一个提
     */
    NSDictionary *connectOptions = @{CBConnectPeripheralOptionNotifyOnConnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnDisconnectionKey:@YES,
                                     CBConnectPeripheralOptionNotifyOnNotificationKey:@YES};
    
    [baby setBabyOptionsAtChannel:channelOnPeropheralView scanForPeripheralsWithOptions:scanForPeripheralsWithOptions connectPeripheralWithOptions:connectOptions scanForPeripheralsWithServices:nil discoverWithServices:nil discoverWithCharacteristics:nil];
}

- (void)insertservices:(CBService *)service{
    
    PeripheralInfo *info = [[PeripheralInfo alloc]init];
    [info setServiceUUID:service.UUID];
    [self.services addObject:info];
//    NSLog(@"insertservices: %@ uuid: %@ info:%@",self.services,service.UUID, info);
    
}

- (IBAction)updateBtnClick:(UIButton *)sender {

    
    
    if (self.peripheral.state == CBPeripheralStateConnected) {
       
        [self updatingAlertView:@"检查跟更新中..."];
        
        if (self.characteristic1 != nil) {
//            [self getHaardWareVersion];
            [self checkoutVersion];
            updateFlag = YES;
            isUpdateX = YES;
            startUpdate = YES;
            
            //记录升级是否完成
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            NSString *str = @"NO";
            [userDefaults setObject:str forKey:FirmwareIsSucessKey];
            [userDefaults synchronize];
        }else{
        
            [self setUpAlertView:@"设备连接异常，请重新连接"];
        }
    }else{
    
        [self setUpAlertView:@"请连接设备"];
    }
    
    
    

//    [self startSendX];
}

- (void)setUpAlertView:(NSString *)contentStr{

    if (self.finishAlertView) {
        [self.finishAlertView removeFromSuperview];
    }
    self.finishAlertView = [JDYFinishAlertView showInView:self.view];
    self.finishAlertView.alertInfoLabel.text = contentStr;
}

- (void)adjustAlertViewClick:(UITapGestureRecognizer*)gesture{
    
    [self.alertView removeFromSuperview];
}

- (void)adjustAlertView:(JDYAdjustAlertView *)adjustAlertView confirmBtn:(UIButton *)confirmBtn flag:(NSString *)flagStr{

    if ([flagStr isEqualToString:@"updateBtnClick"]) {
        [self.alertView removeFromSuperview];
        [self downloadUpdateFile:self.firmwareUrl localPath:self.fileSavePath];
    }
}

- (void)updatingAlertView:(NSString *)contentStr{

        self.progressAlertView = [JDYAdjustProgressAlertView showInView:self.view];
        self.progressAlertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.progressAlertView.alertInfoLabel.text = contentStr;
        LHGradientProgress *gradProg = [LHGradientProgress sharedInstance];

        CGFloat gradProgW = self.progressAlertView.progressView.width;
        CGFloat gradProgH = 5;
        CGFloat gradProgX = 0;
        CGFloat gradProgY = self.progressAlertView.progressView.height - gradProgH;
        gradProg.frame = CGRectMake(gradProgX, gradProgY, gradProgW, gradProgH);
        [gradProg showOnParent:self.progressAlertView.progressView position:LHProgressPosDown];
        [gradProg setProgress:1];
        [gradProg simulateProgress];
//        [self startSendX];
}

- (void)nextUpdate0{
    
    if (isUpdateX) {
        Byte b[] = {0xaa,0x5a,0x02,0x21,0x20};
        NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        self.isNext = 2;
        NSLog(@" writeValue0-> %@",data0);
    }
}

- (void)nextUpdateY0{
    
    Byte b[] = {0xaa,0x5a,0x02,0x21,0x20};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    NSLog(@" writeValueY0-> %@",data0);
    //    dispatch_semaphore_wait(_seam, DISPATCH_TIME_FOREVER);
    //    if (isFinish) {
    
    self.isNext = 7;
    //    }else{
    //
    //        self.isNext = 6;
    //    }
    //
    
    
}

- (void)nextUpdateZ0{
    
    Byte b[] = {0xaa,0x5a,0x02,0x21,0x20};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    NSLog(@" writeValueZ0-> %@",data0);
    //    dispatch_semaphore_wait(_seam, DISPATCH_TIME_FOREVER);
    //    if (isFinish) {
    
    self.isNext = 12;
    //    }else{
    //
    //        self.isNext = 6;
    //    }
    //    
    
    
}

- (void)nextUpdate1{
    
    if (isUpdateX) {
        Byte b[] = {0xaa,0x5a,0x02,0x23,0x20};
        NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        self.isNext = 3;
        NSLog(@"writeValue1-> %@",data0);
    }
}

- (void)nextUpdateY1{
    
    
    Byte b[] = {0xaa,0x5a,0x02,0x23,0x20};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    self.isNext = 8;
    NSLog(@"writeValueY1-> %@",data0);
    
}

- (void)nextUpdateZ1{
    
    
    Byte b[] = {0xaa,0x5a,0x02,0x23,0x20};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    self.isNext = 13;
    NSLog(@" writeValueZ1-> %@",data0);
    
}

- (void)nextUpdate2{
    
    if (isUpdateX) {
        Byte b[] = {0xaa,0x5a,0x02,0x30,0x20};
        NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        NSLog(@" writeValue2-> %@",data0);
        self.isNext = 5;
        sleep(1);
        //        while (true) {
        //           [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        //            NSLog(@" writeValue2-> %@",data0);
        //            dispatch_semaphore_wait(_seam, dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC));
        //            if (isFinish) {
        //                self.isNext = 5;
        //                flag = 0;
        //                break;
        //            }else if(flag == 5){
        //
        //                self.isNext = 0;
        //                break;
        //            }else{
        //
        //                flag++;
        //            }
        //        }
        
        
        
        
    }
}

- (void)nextUpdateY2{
    
    if (isUpdateY) {
        Byte b[] = {0xaa,0x5a,0x02,0x30,0x20};
        NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        self.isNext = 10;
        
        NSLog(@" writeValue2-> %@",data0);
    }
}

- (void)nextUpdateZ2{
    
    if (isUpdateZ) {
        Byte b[] = {0xaa,0x5a,0x02,0x30,0x20};
        NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
        [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        self.isNext = 15;
        
        NSLog(@" writeValue2-> %@",data0);
    }
}

- (void)updateFile{
    
    @autoreleasepool {
        isAllowSend = YES;
        
//        NSString * filePath=[[NSBundle mainBundle] pathForResource:@"default080301" ofType:@"bin"];
//        NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//        kUpdataFileLength = (uint32_t)[fileData length];//120604
//        Byte *fileByte = (Byte *)[fileData bytes];
        Byte *fileByte = (Byte *)[self.updataFileData bytes];
        NSLog(@"kUpdataFileLength =%uu -- %d",kUpdataFileLength, isAllowSend);
        
        if (isUpdateX) {
            
            [self binFileUnpack:fileByte blockLength:blockLength  onComplete:^(Byte *blockFileByte, long fileLength) {
                Byte FileByte[fileLength];
                blockLength += fileLength;
//                for (int i = 0; i< fileLength; i++) {
//                    FileByte[i] = blockFileByte[i];
//                                NSLog(@"binFileUnpack 一 fileByte= %x -- %d",FileByte[i], i);
//                }
                
                
                [self unpackDataFileByte0:blockFileByte fileByteLength0:fileLength];
                
            }];
        }
        
        //        if (isUpdateY && self.isPacket) {
        //
        //            NSLog(@"第一个包结束");
        //            blockLength = blockLength + 4;
        //
        //            self.isPacket1 = [self binFileUnpack:fileByte blockLength:blockLength  onComplete:^(Byte *blockFileByte, long fileLength) {
        //                Byte FileByte[fileLength];
        //                blockLength += fileLength;
        //                for (int i = 0; i< fileLength; i++) {
        //                    FileByte[i] = blockFileByte[i];
        //                    //                NSLog(@"binFileUnpack 二 fileByte= %x -- %d",FileByte[i], i);
        //                }
        //
        //                //YYYYYY
        //                [self unpackDataFileByte0:FileByte fileByteLength0:fileLength];
        //            }];
        //
        //            //            if (isPacket1) {
        //            //               NSLog(@"第二个包结束");
        //            //                blockLength = blockLength + 4;
        //            //
        //            //                BOOL isPacket2 = [self binFileUnpack:fileByte blockLength:blockLength onComplete:^(Byte *blockFileByte, long fileLength) {
        //            //                    Byte FileByte[fileLength];
        //            //
        //            //                    for (int i = 0; i< fileLength; i++) {
        //            //                        FileByte[i] = blockFileByte[i];
        //            //                        NSLog(@"binFileUnpack 三 fileByte= %x -- %d",FileByte[i], i);
        //            //                    }
        //            //                }];
        //            //                if (isPacket2) {
        //            //                   NSLog(@"第三个包结束");
        //            //                }
        //            //            }
        //
        //        }
    }
    
    
    
    
    
    
    
    //    //ZZZZZZ
    //    [self unpackDataFileByte0:fileByte2 fileByteLength0:fileLength2];
}

- (void)updateFileY{
    
    @autoreleasepool {
        
        if (isUpdateY) {
//            NSString * filePath=[[NSBundle mainBundle] pathForResource:@"default080301" ofType:@"bin"];
//            NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//            kUpdataFileLength = (uint32_t)[fileData length];//120604
//            Byte *fileByte = (Byte *)[fileData bytes];
            Byte *fileByte = (Byte *)[self.updataFileData bytes];
            NSLog(@"kUpdataFileLength =%uu -- %d",kUpdataFileLength, isAllowSend);
            
            blockLength = blockLength + 4;
            
            [self binFileUnpack:fileByte blockLength:blockLength  onComplete:^(Byte *blockFileByte, long fileLength) {
                Byte FileByte[fileLength];
                blockLength += fileLength;
                for (int i = 0; i< fileLength; i++) {
                    FileByte[i] = blockFileByte[i];
                    //                NSLog(@"binFileUnpack 二 fileByte= %x -- %d",FileByte[i], i);
                }
                
                //YYYYYY
                [self unpackDataFileByte1:FileByte fileByteLength1:fileLength];
            }];
            
            //            if (isPacket1) {
            //               NSLog(@"第二个包结束");
            //                blockLength = blockLength + 4;
            //
            //                BOOL isPacket2 = [self binFileUnpack:fileByte blockLength:blockLength onComplete:^(Byte *blockFileByte, long fileLength) {
            //                    Byte FileByte[fileLength];
            //
            //                    for (int i = 0; i< fileLength; i++) {
            //                        FileByte[i] = blockFileByte[i];
            //                        NSLog(@"binFileUnpack 三 fileByte= %x -- %d",FileByte[i], i);
            //                    }
            //                }];
            //                if (isPacket2) {
            //                   NSLog(@"第三个包结束");
            //                }
            //            }
            
        }
    }
}

- (void)updateFileZ{
    
    @autoreleasepool {
        
        if (isUpdateZ) {
//            NSString * filePath=[[NSBundle mainBundle] pathForResource:@"default080301" ofType:@"bin"];
//            NSData * fileData = [NSData dataWithContentsOfFile:filePath];
//            kUpdataFileLength = (uint32_t)[fileData length];//120604
//            Byte *fileByte = (Byte *)[fileData bytes];
            Byte *fileByte = (Byte *)[self.updataFileData bytes];
            //            NSLog(@"kUpdataFileLength =%uu -- %d",kUpdataFileLength, isAllowSend);
            
            blockLength = blockLength + 4;
            
            [self binFileUnpack:fileByte blockLength:blockLength  onComplete:^(Byte *blockFileByte, long fileLength) {
                Byte FileByte[fileLength];
                blockLength += fileLength;
                for (int i = 0; i< fileLength; i++) {
                    FileByte[i] = blockFileByte[i];
                    //                NSLog(@"binFileUnpack 二 fileByte= %x -- %d",FileByte[i], i);
                }
                
                //ZZZZZZ
                [self unpackDataFileByte2:FileByte fileByteLength2:fileLength];
            }];
            
            //            if (isPacket1) {
            //               NSLog(@"第二个包结束");
            //                blockLength = blockLength + 4;
            //
            //                BOOL isPacket2 = [self binFileUnpack:fileByte blockLength:blockLength onComplete:^(Byte *blockFileByte, long fileLength) {
            //                    Byte FileByte[fileLength];
            //
            //                    for (int i = 0; i< fileLength; i++) {
            //                        FileByte[i] = blockFileByte[i];
            //                        NSLog(@"binFileUnpack 三 fileByte= %x -- %d",FileByte[i], i);
            //                    }
            //                }];
            //                if (isPacket2) {
            //                   NSLog(@"第三个包结束");
            //                }
            //            }
            
        }
    }
}

- (void)startSendX{
    
    NSString *localPath = [[self createPathToMovie:@"updateFile"] stringByAppendingPathComponent:[NSString stringWithFormat:@"hardwareUpdateFile.bin"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:localPath]) {

        NSData *data = [NSData dataWithContentsOfFile:localPath];
        if (data) {
            self.updataFileData = data;
            
            NSLog(@" 开始升级");
            [self updatingAlertView:@"正在升级中..."];
    
            if (isUpdateX) {
                Byte b[] = {0xaa,0x5a,0x03,0xbb,0x66,0x13};
                NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
                [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
                self.isNext = 1;
                NSLog(@"writeValue -> %@",data0);
            }
        }else{
            
//            [SVProgressHUD showInfoWithStatus:@"固件已损毁"];
            [self setUpAlertView:@"固件已损毁"];
        }
    }else{
    
        [self setUpAlertView:@"固件不存在了"];
//        [SVProgressHUD showInfoWithStatus:@"固件不存在了"];
    }
   
    
}

- (void)startSendY{
    
    Byte b[] = {0xaa,0x5a,0x03,0xbb,0x66,0x14};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    self.isNext = 6;
    NSLog(@" writeValueY-> %@",data0);
}

- (void)startSendZ{
    
    Byte b[] = {0xaa,0x5a,0x03,0xbb,0x66,0x15};
    NSData *data0 = [NSData dataWithBytes:&b length:sizeof(b)];
    [self.peripheral writeValue:data0 forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
    self.isNext = 11;
    NSLog(@" writeValueZ-> %@",data0);
}

//blockLength = blockLength + 4
- (BOOL)binFileUnpack:(Byte [])fileByte blockLength:(long)blockLength onComplete:(onComplete)complete{
    
    NSString *fileStr1 = @"";
    for (int i = 0; i< 4; i++) {
        NSString *str = [NSString stringWithFormat:@"%x",fileByte[blockLength +i]];
        if (str.length == 1) {
            fileStr1 = [fileStr1 stringByAppendingFormat:@"0%x", fileByte[blockLength +i]];
        }else{
            fileStr1 = [fileStr1 stringByAppendingFormat:@"%x", fileByte[blockLength +i]];
        }
        NSLog(@"%@ -- fileByte1= %x",fileStr1,fileByte[blockLength +i]);//00005920
    }
    
    NSInteger fileLength0 = [self numberWithHexString:fileStr1];//22816
    
    while (true) {
        Byte fileByte0[fileLength0];
        for(NSInteger i = blockLength + 4; i < fileLength0 + blockLength  + 4; i++){// 84 33 17 4B最后4个数
            
            fileByte0[i-(blockLength + 4)] = fileByte[i];
            //        NSLog(@"第二个大包 %x -- %x",fileByte1[i-(fileLength0 + 8)],fileByte[i]);
            if (i >=fileLength0 + blockLength + 4 - 1) {
                complete(fileByte0, fileLength0);
                return YES;
            }
        }
    }
    
    
    //    NSString *fileStr = @"";
    //    for(int i = 0; i < 4; i++){
    //        NSString *str = [NSString stringWithFormat:@"%x",fileByte[i]];
    //        if (str.length == 1) {
    //            fileStr = [fileStr stringByAppendingFormat:@"0%x", fileByte[i]];
    //        }else{
    //            fileStr = [fileStr stringByAppendingFormat:@"%x", fileByte[i]];
    //        }
    //
    //    }
    //
    //    NSLog(@"binFileUnpack %@--%ld",fileStr, (long)[self numberWithHexString:fileStr]);
    //    NSInteger fileLength0 = [self numberWithHexString:fileStr];//67904
    //
    //    Byte fileByte0[fileLength0];
    //    while (true) {
    //
    //        for(NSInteger i = 4; i < fileLength0 + 4; i++){
    //            NSLog(@"**--%d",i);
    //
    //
    //            fileByte0[i-4] = fileByte[i];
    //            //                NSLog(@"binFileUnpack 第一个大包 %x -- %x",fileByte0[i-4], fileByte[i]);
    //            if (i >= fileLength0 + 4 - 1) {
    //                complete(fileByte0, fileLength0);
    //                return YES;
    //            }}
    //    }
    
}

- (void)unpackDataFileByte0:(Byte [])fileByte0 fileByteLength0:(long)fileByteLength0{
//    for (int i = 0; i< fileByteLength0; i++) {
////        FileByte[i] = blockFileByte[i];
//        NSLog(@"fileByte0 一 fileByte= %x -- %d",fileByte0[i], i);
//        if (i<516) {
//            NSLog(@"-----------------------------");
//        }
//    }

    
    __weak typeof(self)weakSelf = self;
    @autoreleasepool {
        //        NSLog(@"%ld",fileByteLength0);
        int index = 0;
        long subLength = 1;
        int h = 0;
        
        //        NSLog(@"--------->>>>>start send data 1");
        while (index < fileByteLength0) {
            Byte bigFileByte[515];
            bigFileByte[0] = 0x27;
            if (index + unit >= fileByteLength0) {//走到这里时fileByte0数组里的元素不足512了，所以bigFileByte需要重新分配length那么多的空间
                long length = fileByteLength0 - index;//数据长度
                subLength = length + 3;
                memset(bigFileByte, 0, length+3);
                //                Byte bigFileByte[length + 3];
                bigFileByte[0] = 0x27;
                bigFileByte[1] = (Byte)((fileByteLength0 - index)/4);
                //                NSLog(@"sizeof %x",(Byte)(fileByteLength0 - index));
                //                NSLog(@"sizeof bigFileByte %lu",sizeof(bigFileByte));
                //#if 1
                for (int i = 2; i< length + 2; i++) {//91 FB 63 58 5C 最后4个数
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                    
                }
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, length);
                //#endif
                
                bigFileByte[length + 3 - 1] = 0x20;
                //                NSLog(@"最后一个%x",bigFileByte[length + 3 - 2]);
                //                memset(leftByte, 0, length+3);
                
                Byte tempByte[length + 3];
                for (int i= 0; i<length+3; i++) {
                    tempByte[i] = bigFileByte[i];
                    //                    NSLog(@"unpack 不足512的数组%x -- %d\n",bigFileByte[i], i);
                }
                
            }else{
                
                bigFileByte[1] = 0x80;
                //#if 1
                for (int i = 2; i<unit + 2; i++) {
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                }
                
                
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, unit);
                //#endif
                
                bigFileByte[514] = 0x20;
                
//                for (int i= 0; i<515; i++) {
//                    NSLog(@"bigFileByte %x -- %d -- %d\n",bigFileByte[i],index, i);
//                }

                
                
            }
            
            
            
            //            if (index + unit>= fileByteLength0) {
            //
            //                for (int i= 0; i<subLength; i++) {
            //                    NSLog(@"unpack XX外面输出%x -- %d -- %d\n",bigFileByte[i],index, i);
            //                }
            //            }
//            if (index <1) {
//                for (int i= 0; i<515; i++) {
//                    NSLog(@"unpack XX外面输出%x -- %d -- %d\n",bigFileByte[i],index, i);
//                }
//            }
            
            //            NSLog(@"index %d",index);
            int t = 0;
            
            //            NSLog(@"--------->>>>>start send data 2");
            while (true) {
                int length = sizeof(bigFileByte);
                
                int xPos = 0;
                int p = 0;
                if (index + unit>= fileByteLength0) {
                    
                    //                    NSLog(@"--------->>>>>start send data 4");
                    
                    while (xPos < subLength) {//不满512
                        
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        NSLog(@"subLength %ld",subLength);
                        if (xPos + unit1 >= subLength) {//不满512 不满17
                            subbigFileByte[2] = (Byte)(subLength - xPos);
                            long length1 = subLength - xPos;
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            NSLog(@"4444=============================");
                            for (int i = 0; i<length1+3; i++) {
                                NSLog(@"最后一个数组 %x\n",subbigFileByte[i]);
                                
                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:length1+3];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                
                                //                                if (finish) {
                                //                                    isAllowSend = NO;
                                weakSelf.isNext = 4;
                                isFinish = NO;
                                signal = NO;
                                NSLog(@"结束了");
                                //                                [NSThread sleepForTimeInterval:0.02f];
                                //                                }
                                
                            }];
                        }else{//不满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"3333=============================");
                            //                            for (int i = 0; i<unit1+3; i++) {
                            //                                NSLog(@"不满512 满17 %x -- %d",subbigFileByte[i],i);
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:unit1 + 3];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish && xPos == subLength) {
                                    //                               isAllowSend = NO;
                                }
                                
                            }];
                        }
                        
                        //                        if (xPos + unit1 >= subLength) {
                        //                            //                        self.isNext = 0;
                        //                            isAllowSend = NO;
                        //                            if(isUpdateX){
                        //
                        //                                self.isNext = 4;
                        //                            }
                        //
                        //                            NSLog(@"结束了");
                        //                        }
                        xPos += unit1;
                    }
                    
                    //                    NSLog(@"--------->>>>>start send data 5");
                    
                    break;
                    
                }else{
                    int j = 0;
                    
                    while (xPos < length) {//满512
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        
                        if (xPos + unit1 >= length) {//满512 不满17
                            subbigFileByte[2] = (Byte)(length - xPos);
                            int length1 = length - xPos;
                            //                            NSLog(@"%x -- %x",subbigFileByte[0],subbigFileByte[1]);
                            
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                                
                            }
                            
                                                        NSLog(@"2222=============================");
                                                        for (int i = 0; i<length1+3; i++) {
                                                            NSLog(@"满512 不满17 %x -- %d\n",subbigFileByte[i],i);
                            
                                                        }
                                                        NSLog(@"满512 不满17==========================================%d \n",p++);
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:length1+3];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                }
                                
                            }];
                            
                        }else{//满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            NSLog(@"1111====================================%d",j++);
                            for (int i = 0; i<20; i++) {
                                NSLog(@"满512 满17 subbigFileByte %x -- %d\n",subbigFileByte[i],i);
                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            if (!_seam) {
                                _seam = dispatch_semaphore_create(0);
                            }
                            //                            NSLog(@"<<<<<=========================>>>>>>2");
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                    
                                }
                                
                            }];
                            //                            NSLog(@"<<<<<=========================>>>>>>1");
                        }
                        xPos += unit1;
                        //                        NSLog(@"============================99");
                    }
                    
                    //                    NSLog(@"============================77%d",t++);
                    
                    break;
                }
                
            }
            
            //            NSLog(@"--------->>>>>start send data 3");
            
            //美512才会回复
            //            dispatch_semaphore_wait(_seam, dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC));
            if (!isXend) {
                NSLog(@"dispatch_semaphore_wait_X--->1");
                //                dispatch_semaphore_wait(_seam, dispatch_time(DISPATCH_TIME_NOW, 5.0*NSEC_PER_SEC));
                dispatch_semaphore_wait(_seam, DISPATCH_TIME_FOREVER);
                NSLog(@"dispatch_semaphore_wait_X--->2");
                if (isFinish) {
                    isFinish = NO;
                    index += unit;
                }else{
                    //                    NSLog(@"错了============================88-> %d",h++);
                    index = index;
                }
                
                //            if (index + unit>= fileByteLength0 && isFinish) {
                //                self.isNext = 4;
                //                NSLog(@"结束了");
                //            }
                //                NSLog(@"============================88-> %d--%d",h++,isFinish);
            }
            
        }
    }
}

- (void)unpackDataFileByte1:(Byte [])fileByte0 fileByteLength1:(long)fileByteLength0{
    
    __weak typeof(self)weakSelf = self;
    //    _seam = nil;
    //    NSLog(@"_seam %@",_seam);
    @autoreleasepool {
        //        NSLog(@"%ld",fileByteLength0);
        int index = 0;
        long subLength = 1;
        int h = 0;
        while (index < fileByteLength0) {
            
            Byte bigFileByte[515];
            bigFileByte[0] = 0x27;
            if (index + unit >= fileByteLength0) {//走到这里时fileByte0数组里的元素不足512了，所以bigFileByte需要重新分配length那么多的空间
                long length = fileByteLength0 - index;
                subLength = length + 3;
                memset(bigFileByte, 0, length+3);
                //                Byte bigFileByte[length + 3];
                bigFileByte[0] = 0x27;
                bigFileByte[1] = (Byte)((fileByteLength0 - index)/4);
                //                NSLog(@"sizeof %x",(Byte)(fileByteLength0 - index));
                //                NSLog(@"sizeof bigFileByte %lu",sizeof(bigFileByte));
                //#if 1
                for (int i = 2; i< length + 2; i++) {//91 FB 63 58 5C 最后4个数
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                    
                }
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, length);
                //#endif
                
                bigFileByte[length + 3 - 1] = 0x20;
                //                NSLog(@"最后一个%x",bigFileByte[length + 3 - 2]);
                //                memset(leftByte, 0, length+3);
                
                Byte tempByte[length + 3];
                for (int i= 0; i<length+3; i++) {
                    tempByte[i] = bigFileByte[i];
                    //                    NSLog(@"unpack 不足512的数组%x -- %d\n",bigFileByte[i], i);
                }
                
            }else{
                
                bigFileByte[1] = 0x80;
                //#if 1
                for (int i = 2; i<unit + 2; i++) {
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                }
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, unit);
                //#endif
                
                bigFileByte[514] = 0x20;
                
            }
            
            
            
            //            if (index + unit>= fileByteLength0) {
            //
            //                for (int i= 0; i<subLength; i++) {
            //                    NSLog(@"unpack XX外面输出%x -- %d -- %d\n",bigFileByte[i],index, i);
            //                }
            //            }
            
            //            NSLog(@"index %d",index);
            int t = 0;
            while (true) {
                
                int length = sizeof(bigFileByte);
                int xPos = 0;
                int p = 0;
                if (index + unit>= fileByteLength0) {
                    
                    while (xPos < subLength) {//不满512
                        
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        NSLog(@"subLength %ld",subLength);
                        if (xPos + unit1 >= subLength) {//不满512 不满17
                            subbigFileByte[2] = (Byte)(subLength - xPos);
                            long length1 = subLength - xPos;
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Y4444=============================");
                            //                            for (int i = 0; i<length1+3; i++) {
                            //                                NSLog(@"最后一个数组 %x\n",subbigFileByte[i]);
                            //
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                
                                //                                if (finish) {
                                //                                    isAllowSend = NO;
                                weakSelf.isNext = 9;
                                isFinish = NO;
                                signal = NO;
                                NSLog(@"Y结束了");
                                
                                //                                }
                                
                            }];
                        }else{//不满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Y3333=============================");
                            //                            for (int i = 0; i<unit1+3; i++) {
                            //                                NSLog(@"不满512 满17 %x -- %d",subbigFileByte[i],i);
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish && xPos == subLength) {
                                    //                               isAllowSend = NO;
                                }
                                
                            }];
                        }
                        
                        //                        if (xPos + unit1 >= subLength) {
                        //                            //                        self.isNext = 0;
                        //                            isAllowSend = NO;
                        //                            if(isUpdateX){
                        //
                        //                                self.isNext = 4;
                        //                            }
                        //
                        //                            NSLog(@"结束了");
                        //                        }
                        xPos += unit1;
                    }
                    
                    break;
                    
                }else{
                    int j = 0;
                    
                    while (xPos < length) {//满512
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        
                        if (xPos + unit1 >= length) {//满512 不满17
                            subbigFileByte[2] = (Byte)(length - xPos);
                            int length1 = length - xPos;
                            //                            NSLog(@"YYYY %x -- %x",subbigFileByte[0],subbigFileByte[1]);
                            
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                                
                            }
                            
                            //                            NSLog(@"Y2222=============================");
                            //                            for (int i = 0; i<length1+3; i++) {
                            //                                NSLog(@"满512 不满17 %x -- %d\n",subbigFileByte[i],i);
                            //
                            //                            }
                            //                            NSLog(@"满512 不满17==========================================%d \n",p++);
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                }
                                
                            }];
                            
                        }else{//满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Y1111====================================%d",j++);
                            //                            for (int i = 0; i<20; i++) {
                            //                                NSLog(@"Y满512 满17 subbigFileByte %x -- %d\n",subbigFileByte[i],i);
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            
                            if (!_seamY) {
                                _seamY = dispatch_semaphore_create(0);
                            }
                            
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                    
                                }
                                
                            }];
                        }
                        xPos += unit1;
                        //                        NSLog(@"============================99");
                    }
                    
                    //                    NSLog(@"============================77%d",t++);
                    
                    break;
                }
                
            }
            
            //美512才会回复 22816
            //            dispatch_semaphore_wait(_seam, dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC));
            if (!isYend) {
                NSLog(@"dispatch_semaphore_wait_Y--->1");
                //                dispatch_semaphore_wait(_seamY, dispatch_time(DISPATCH_TIME_NOW, 5.0*NSEC_PER_SEC));
                dispatch_semaphore_wait(_seamY, DISPATCH_TIME_FOREVER);
                NSLog(@"dispatch_semaphore_wait_X--->2");
                if (isFinish) {
                    isFinish = NO;
                    index += unit;
                }else{
                    //                    NSLog(@"Y错了============================88-> %d",h++);
                    index = index;
                }
                //                NSLog(@"Y============================88-> %d--%d--isYend:%d",h++,isFinish,isYend);
            }
            
        }
    }

    
}

- (void)unpackDataFileByte2:(Byte [])fileByte0 fileByteLength2:(long)fileByteLength0{
    
    __weak typeof(self)weakSelf = self;
    //    _seamY = nil;
    //    NSLog(@"_seam %@",_seamY);
    @autoreleasepool {
        //        NSLog(@"%ld",fileByteLength0);
        int index = 0;
        long subLength = 1;
        int h = 0;
        while (index < fileByteLength0) {
            
            Byte bigFileByte[515];
            bigFileByte[0] = 0x27;
            if (index + unit >= fileByteLength0) {//走到这里时fileByte0数组里的元素不足512了，所以bigFileByte需要重新分配length那么多的空间
                long length = fileByteLength0 - index;
                subLength = length + 3;
                memset(bigFileByte, 0, length+3);
                //                Byte bigFileByte[length + 3];
                bigFileByte[0] = 0x27;
                bigFileByte[1] = (Byte)((fileByteLength0 - index)/4);
                //                NSLog(@"sizeof %x",(Byte)(fileByteLength0 - index));
                //                NSLog(@"sizeof bigFileByte %lu",sizeof(bigFileByte));
                //#if 1
                for (int i = 2; i< length + 2; i++) {//91 FB 63 58 5C 最后4个数
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                    
                }
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, length);
                //#endif
                bigFileByte[length + 3 - 1] = 0x20;
                //                NSLog(@"最后一个%x",bigFileByte[length + 3 - 2]);
                //                memset(leftByte, 0, length+3);
                
                Byte tempByte[length + 3];
                for (int i= 0; i<length+3; i++) {
                    tempByte[i] = bigFileByte[i];
                    //                    NSLog(@"unpack 不足512的数组%x -- %d\n",bigFileByte[i], i);
                }
                
            }else{
                
                bigFileByte[1] = 0x80;
                //#if 1
                for (int i = 2; i<unit + 2; i++) {
                    
                    bigFileByte[i] = fileByte0[index + i - 2];
                }
                //#else
                //
                //                memcpy(bigFileByte + 2, fileByte0 + index, unit);
                //#endif
                
                bigFileByte[514] = 0x20;
                
            }
            
            
            
            //            if (index + unit>= fileByteLength0) {
            //
            //                for (int i= 0; i<subLength; i++) {
            //                    NSLog(@"unpack XX外面输出%x -- %d -- %d\n",bigFileByte[i],index, i);
            //                }
            //            }
            
            //            NSLog(@"index %d",index);
            int t = 0;
            while (true) {
                
                int length = sizeof(bigFileByte);
                int xPos = 0;
                int p = 0;
                if (index + unit>= fileByteLength0) {
                    
                    while (xPos < subLength) {//不满512
                        
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        NSLog(@"subLength %ld",subLength);
                        if (xPos + unit1 >= subLength) {//不满512 不满17
                            subbigFileByte[2] = (Byte)(subLength - xPos);
                            long length1 = subLength - xPos;
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Z4444=============================");
                            //                            for (int i = 0; i<length1+3; i++) {
                            //                                NSLog(@"Z最后一个数组 %x\n",subbigFileByte[i]);
                            //
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                
                                //                                if (finish) {
                                //                                    isAllowSend = NO;
                                weakSelf.isNext = 14;
                                isFinish = NO;
                                signal = NO;
                                NSLog(@"Z结束了");
                                
                                //                                }
                                
                            }];
                        }else{//不满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Z3333=============================");
                            //                            for (int i = 0; i<unit1+3; i++) {
                            //                                NSLog(@"不满512 满17 %x -- %d",subbigFileByte[i],i);
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish && xPos == subLength) {
                                    //                               isAllowSend = NO;
                                }
                                
                            }];
                        }
                        
                        //                        if (xPos + unit1 >= subLength) {
                        //                            //                        self.isNext = 0;
                        //                            isAllowSend = NO;
                        //                            if(isUpdateX){
                        //
                        //                                self.isNext = 4;
                        //                            }
                        //
                        //                            NSLog(@"结束了");
                        //                        }
                        xPos += unit1;
                    }
                    
                    break;
                    
                }else{
                    int j = 0;
                    
                    while (xPos < length) {//满512
                        Byte subbigFileByte[20];
                        subbigFileByte[0] = 0xAA;
                        subbigFileByte[1] = 0x5A;
                        
                        if (xPos + unit1 >= length) {//满512 不满17
                            subbigFileByte[2] = (Byte)(length - xPos);
                            int length1 = length - xPos;
                            //                            NSLog(@"ZZZZ %x -- %x",subbigFileByte[0],subbigFileByte[1]);
                            
                            for (int i = 3; i<length1+3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                                
                            }
                            
                            //                            NSLog(@"Z2222=============================");
                            //                            for (int i = 0; i<length1+3; i++) {
                            //                                NSLog(@"满512 不满17 %x -- %d\n",subbigFileByte[i],i);
                            //
                            //                            }
                            //                            NSLog(@"满512 不满17==========================================%d \n",p++);
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                }
                                
                            }];
                            
                        }else{//满512 满17
                            
                            subbigFileByte[2] = 0x11;
                            for (int i = 3; i<unit1 + 3; i++) {
                                subbigFileByte[i] = bigFileByte[xPos + i - 3];
                            }
                            
                            //                            NSLog(@"Z1111====================================%d",j++);
                            //                            for (int i = 0; i<20; i++) {
                            //                                NSLog(@"Z满512 满17 subbigFileByte %x -- %d\n",subbigFileByte[i],i);
                            //                            }
                            
                            NSData *data = [NSData dataWithBytes:subbigFileByte length:sizeof(subbigFileByte)];
                            
                            if (!_seamZ) {
                                _seamZ = dispatch_semaphore_create(0);
                            }
                            
                            [self setNotifiyWriteValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse onFinish:^(BOOL finish) {
                                if (finish) {
                                    
                                    
                                }
                                
                            }];
                        }
                        xPos += unit1;
                        //                        NSLog(@"============================99");
                    }
                    
                    //                    NSLog(@"============================77%d",t++);
                    
                    break;
                }
                
            }
            
            //美512才会回复 22816
            //            dispatch_semaphore_wait(_seam, dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC));
            if (!isZend) {
                
                NSLog(@"dispatch_semaphore_wait_Z--->1");
                //                dispatch_semaphore_wait(_seamZ, dispatch_time(DISPATCH_TIME_NOW, 5.0*NSEC_PER_SEC));
                dispatch_semaphore_wait(_seamZ, DISPATCH_TIME_FOREVER);
                NSLog(@"dispatch_semaphore_wait_Z--->2");
                if (isFinish) {
                    isFinish = NO;
                    index += unit;
                }else{
                    //                    NSLog(@"Z错了============================88-> %d",h++);
                    index = index;
                }
                //                NSLog(@"Z============================88-> %d--%d",h++,isFinish);
            }
            
        }
    }
    
}

-(void)setNotifiyWriteValue:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type onFinish:(onfinish)finish{
    
    
    //    if (!_subDataWriteOK) {
    //        _subDataWriteOK = dispatch_semaphore_create(0);
    //    }
    
    //    NSLog(@"<<<<<=========================>>>>>>3");
    //    if (!) {
    //
    //    }
    //    BOOL canBe = [[self->baby peripheralManager] updateValue:data forCharacteristic:self.mutCharacteristic onSubscribedCentrals:nil];
    //    NSLog(@"<<<<<<<========%d=========>>>>>>", canBe);
    [self.peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    //    NSLog(@"--------->>>dispatch_semaphore_wait_write_OK_1");
    //    dispatch_semaphore_wait(_subDataWriteOK, DISPATCH_TIME_FOREVER);
    //    NSLog(@"--------->>>dispatch_semaphore_wait_write_OK_2");
    //    sleep(0.03);
    //    NSLog(@"<<<<<=========================>>>>>>4");
    usleep(10*1000);
    //    NSLog(@"<<<<<=========================>>>>>>5");
    //    [self.peripheral discoverDescriptorsForCharacteristic:characteristic];
    totalCount += data.length-3;
    NSLog(@"WriteValue-> %@ %@--%ld\n",data,characteristic.UUID,totalCount);
    finish(YES);
}

- (void)initCharacteristic{
    
    if (!self.characteristic0 || self.characteristic1) {
        
        for (CBService *s in self.peripheral.services) {
            
            if ([[s.UUID UUIDString] isEqualToString:@"FFE0"]) {
                
                for (CBCharacteristic *characteristic in s.characteristics) {
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE2"]]) {//可写
                        self.characteristic1 = characteristic;
                    }
                    
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:@"FFE1"]]) {
                        self.characteristic0 = characteristic;
                    }
                }
            }
            
        }
    }
}

-(void)setNotifiy{
    
    self->baby.channel(channelOnCharacteristicView).characteristicDetails(self.peripheral,self.characteristic1);
    __weak typeof(self)weakSelf = self;
    
    if(self.peripheral.state == CBPeripheralStateDisconnected && self.peripheral.name != nil) {
        NSString *tempStr = [NSString stringWithFormat:@"%@已经断开连接，请重新连接",self.peripheral.name];
        [SVProgressHUD showErrorWithStatus:tempStr];
        return;
    }
    
    [self babyDelegate3];
    
    if (!(self.characteristic0 && self.characteristic1)) {
        return;
    }
    
    if (self.characteristic0.properties & CBCharacteristicPropertyNotify ||  self.characteristic0.properties & CBCharacteristicPropertyIndicate) {
        
        if(self.characteristic0.isNotifying) {
            [self->baby cancelNotify:self.peripheral characteristic:self.characteristic0];
            NSLog(@"已取消Notify");
        }else{
            
            [weakSelf.peripheral setNotifyValue:YES forCharacteristic:self.characteristic0];
            
            NSLog(@"已订阅%@--%@",self.peripheral,self.characteristic0);
            [self->baby notify:self.peripheral
                characteristic:self.characteristic0
                         block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
                             
                             
                             if (error) {
                                 NSLog(@"notify block error%@",error);
                             }else{
                                 
                                 NSString *temp = [NSString stringWithFormat:@"%@",characteristics.value];
                                 temp = [temp componentsSeparatedByString:@"<"].lastObject;
                                 temp = [temp componentsSeparatedByString:@">"].firstObject;
                                 NSLog(@"temp %@",temp);
                                 if ([temp containsString:@"55b007"]) {
                                     NSData * data = characteristics.value;
                                     heartFlag = 3;
                                     [self adjustValue:data];
                                 }else if (0 == heartFlag){
                                     
                                     heartFlag = 3;
                                     [baby cancelPeripheralConnection:weakSelf.peripheral];
                                 }
                                 
                                 self.hardWareVersionStr = @"";
                                 if ([temp containsString:@"55af0501"]) {
                                     NSLog(@"version temp %@",temp);
                                     NSRange range = NSMakeRange(11, 2);
                                     NSString *str = [temp substringWithRange:range];
                                     NSLog(@"--%@",str);
                                     self.hardWareVersionStr = str;
                                     NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                     [userDefaults setObject:str forKey:FirmwareNumFromHardWareKey];
                                     [userDefaults synchronize];
//                                     [self checkoutVersion];
                                 }
                                 
                                 
                                 if (startUpdate) {
                                     flagStr = temp;
                                     
                                     if ([flagStr isEqualToString:@"55ae0312 1022"]) {
                                         
                                         isFinish = YES;
                                         if (weakSelf.isNext == 1) {
                                             weakSelf.isNext = 0;
                                             dispatch_sync(weakSelf.updateFilequeue, ^{
                                                 
                                                 [weakSelf nextUpdate0];
                                             });
                                             
                                             isAllowSend = NO;
                                         }else if(weakSelf.isNext == 2){
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             dispatch_sync(weakSelf.updateFilequeue, ^{
                                                 [weakSelf nextUpdate1];
                                             });
                                             
                                             
                                         }else if(weakSelf.isNext == 3){
                                             if (!signal) {
                                                 signal = YES;
                                                 //                                            weakSelf.isNext = 0;
                                                 dispatch_async(weakSelf.updateFilequeue, ^{
                                                     //                                                weakSelf.isNext = 0;
                                                     [weakSelf updateFile];
                                                 });
                                                 //                                                _seam = nil;
                                             }else{
                                                 
                                                 //                                                if (_seam) {
                                                 //                                                    dispatch_semaphore_signal(_seam);
                                                 //                                                }
                                             }
                                             
                                             
                                         }else if(weakSelf.isNext == 4){
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             //                isUpdateY = NO;
                                             dispatch_sync(weakSelf.updateFilequeueY, ^{
                                                 
                                                 [weakSelf nextUpdate2];
                                             });
                                             
                                             //                isUpdateY = YES;
                                         }else if(weakSelf.isNext == 5){
                                             NSLog(@"X 升级完毕");
                                             totalCount = 0;
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             isUpdateX = NO;
                                             isXend = YES;
                                             dispatch_sync(weakSelf.updateFilequeueY, ^{
                                                 
                                                 [self startSendY];
                                             });
                                             
                                             
                                         }else if (weakSelf.isNext == 6){
                                             
                                             weakSelf.isNext = 0;
                                             
                                             isAllowSend = NO;
                                             dispatch_sync(weakSelf.updateFilequeueY, ^{
                                                 
                                                 [weakSelf nextUpdateY0];
                                             });
                                         }else if (weakSelf.isNext == 7){
                                             
                                             weakSelf.isNext = 0;
                                             dispatch_sync(weakSelf.updateFilequeueY, ^{
                                                 
                                                 [weakSelf nextUpdateY1];
                                             });
                                             
                                             isAllowSend = NO;
                                         }else if (weakSelf.isNext == 8){
                                             if (!signal) {
                                                 signal = YES;
                                                 isUpdateY = YES;
                                                 dispatch_async(weakSelf.updateFilequeueY, ^{
                                                     
                                                     [weakSelf updateFileY];
                                                 });
                                             }
                                             
                                             
                                         }else if (weakSelf.isNext == 9){
                                             
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             //                isUpdateY = NO;
                                             dispatch_sync(weakSelf.updateFilequeueZ, ^{
                                                 
                                                 [weakSelf nextUpdateY2];
                                             });
                                             
                                             //                isUpdateY = YES;
                                         }else if (weakSelf.isNext == 10){
                                             NSLog(@"Y 升级完毕");
                                             weakSelf.isNext = 0;
                                             totalCount = 0;
                                             isAllowSend = NO;
                                             isUpdateY = NO;
                                             isYend = YES;
                                             //                                            isUpdateZ = YES;
                                             dispatch_sync(weakSelf.updateFilequeueZ, ^{
                                                 
                                                 [self startSendZ];
                                             });
                                         }else if (weakSelf.isNext == 11){
                                             
                                             weakSelf.isNext = 0;
                                             
                                             isAllowSend = NO;
                                             dispatch_sync(weakSelf.updateFilequeueZ, ^{
                                                 
                                                 [weakSelf nextUpdateZ0];
                                             });
                                         }else if (weakSelf.isNext == 12){
                                             
                                             weakSelf.isNext = 0;
                                             dispatch_sync(weakSelf.updateFilequeueZ, ^{
                                                 
                                                 [weakSelf nextUpdateZ1];
                                             });
                                         }else if (weakSelf.isNext == 13){
                                             
                                             if (!signal) {
                                                 signal = YES;
                                                 isUpdateZ = YES;
                                                 dispatch_async(weakSelf.updateFilequeueZ, ^{
                                                     
                                                     [weakSelf updateFileZ];
                                                 });
                                             }
                                         }else if (weakSelf.isNext == 14){
                                             
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             //                isUpdateY = NO;
                                             dispatch_sync(weakSelf.updateFilequeueZZ, ^{
                                                 
                                                 [weakSelf nextUpdateZ2];
                                             });
                                         }else if (weakSelf.isNext == 15){
                                             
                                             NSLog(@"Z 升级完毕");
                                             weakSelf.isNext = 0;
                                             isAllowSend = NO;
                                             isUpdateZ = NO;
                                             isZend = YES;
                                             startUpdate = NO;
                                             isSend = NO;
                                             [weakSelf.laAnimation1 removeFromSuperview];
                                             [weakSelf.progressAlertView removeFromSuperview];
                                             NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                                             NSString *str = @"YES";
                                             [userDefaults setObject:str forKey:FirmwareIsSucessKey];
                                             [userDefaults synchronize];
                                             
                                             [self setUpAlertView:@"升级完成..."];
//                                             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"成功" message:@"更新完成"
//                                                                                            delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//                                             [alert show];
                                             
                                         }
                                     }else{
                                         
                                         isFinish = NO;
                                         isAllowSend = NO;
                                     }
                                     
                                     if (_seam && signal && !isXend) {
                                         NSLog(@"dispatch_semaphore_signal_X1.1");
                                         dispatch_semaphore_signal(_seam);
                                         NSLog(@"dispatch_semaphore_signal_X1.2");
                                     }
                                     if (_seamY && signal && !isYend) {
                                         NSLog(@"dispatch_semaphore_signal_Y1.1");
                                         dispatch_semaphore_signal(_seamY);
                                         NSLog(@"dispatch_semaphore_signal_Y1.12");
                                     }
                                     if (_seamZ && signal && !isZend) {
                                         NSLog(@"dispatch_semaphore_signal_Z1.1");
                                         dispatch_semaphore_signal(_seamZ);
                                         NSLog(@"dispatch_semaphore_signal_Z1.2");
                                     }
                                    if (startUpdate) {
                                        
                                     NSLog(@"setNotifiy: %d -- %d -- %d -- %@ -- %@ -- %@ \n",isFinish, weakSelf.isNext, isUpdateY,_seam, _seamY,_seamZ);
                                    }
                                 }
                                 
                                 
                                 
                             }//收到回复
                             
                         }];
        }
        
    }else{
        NSString *tempStr = [NSString stringWithFormat:@"%@已经断开连接，请重新连接",self.characteristic];
        [SVProgressHUD showErrorWithStatus:tempStr];
        return;
    }
    
//    if (self.hardWareVersionStr == nil) {
//        [self getHaardWareVersion];
//    }
    
}

- (void)setUpNewVersionAlertView{

    [self.progressAlertView removeFromSuperview];
    JDYAdjustAlertView *alertView = [JDYAdjustAlertView showInView:self.view];
    alertView.delegate = self;
    alertView.flagStr = @"updateBtnClick";
    self.alertView = alertView;
    alertView.alertInfoLabel2.text = @"新版本上线";
    alertView.alertInfoLabel3.text = @"是否升级?";
    alertView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adjustAlertViewClick:)];
    tapGesture.delegate = self;
    
    [alertView addGestureRecognizer:tapGesture];
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
    self.pitchAxisLabel.text = [NSString stringWithFormat:@"%.2f°",x];
    self.crossRollerLabel.text = [NSString stringWithFormat:@"%.2f°",y];
    self.headingAxisLabel.text = [NSString stringWithFormat:@"%.2f°",z];
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

-(void)writeValue{
    
    //    Byte b[20] = {0xaa,0x5a,0x11,0x27, 0x80,0xfa,0xe3,0x24, 0x99,0x08,0xed,0x19, 0x96,0x00,0xa0,0xe0, 0xae,0x1c,0x3b,0xb5};
    Byte b[] = {0xaa,0x5a,0x03,0xbb,0x66,0x13};
    NSData *data = [NSData dataWithBytes:&b length:sizeof(b)];
    NSLog(@"data length: %lu",sizeof(b));
    //CBCharacteristicWriteWithResponse 这个写的不对回报Domain=CBATTErrorDomain Code=3 "Writing is not permitted这个错
    [self.peripheral writeValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
}

- (NSInteger)numberWithHexString:(NSString *)hexString{
    
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    
    int hexNumber;
    
    sscanf(hexChar, "%x", &hexNumber);
    
    return (NSInteger)hexNumber;
}

-(void)babyDelegate3{
    
    __weak typeof(self)weakSelf = self;
    //设置读取characteristics的委托
    [self->baby setBlockOnReadValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristics, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@ value is:%@",characteristics.UUID,characteristics.value);
        
    }];
    //设置发现characteristics的descriptors的委托
    [self->baby setBlockOnDiscoverDescriptorsForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        //        NSLog(@"CharacteristicViewController===characteristic name:%@",characteristic.service.UUID);
        for (CBDescriptor *d in characteristic.descriptors) {
            //            NSLog(@"CharacteristicViewController CBDescriptor name is :%@",d.UUID);
            
        }
    }];
    //设置读取Descriptor的委托
    [self->baby setBlockOnReadValueForDescriptorsAtChannel:channelOnCharacteristicView block:^(CBPeripheral *peripheral, CBDescriptor *descriptor, NSError *error) {
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
    [self->baby setBlockOnDidWriteValueForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
//        NSLog(@"setBlockOnDidWriteValueForCharacteristicAtChannel characteristic:%@ and new value:%@",characteristic.UUID, characteristic.value);
//        
//        if (error) {
//            NSLog(@"WriteValueForCharacteristicAtChannel error%@",error);
//            
//        }
        
    }];
    
    //设置通知状态改变的block
    [self->baby setBlockOnDidUpdateNotificationStateForCharacteristicAtChannel:channelOnCharacteristicView block:^(CBCharacteristic *characteristic, NSError *error) {
        NSLog(@"uid:%@,isNotifying:%@",characteristic.UUID,characteristic.isNotifying?@"on":@"off");
    }];
    
    
    
}

- (void)joyStick:(LHJoyStick *)joyStick position:(NSString *)positionStr speed:(NSString *)speedStr{

    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    
    isJoy = YES;
    self.positionStr = positionStr;
    NSLog(@"ViewController joyStick %@ -- %@",positionStr, speedStr);
    NSMutableArray *mutableArry = [NSMutableArray array];
    Byte tempArr[6];
    tempArr[0] = 0xaa;
    tempArr[1] = 0x5e;
    tempArr[2] = 0x03;
    [mutableArry addObject:@"aa"];
    [mutableArry addObject:@"5e"];
    [mutableArry addObject:@"03"];
    
    if ([positionStr isEqualToString:@"回中"]) {
        if ([speedStr isEqualToString:@"低"]) {
            tempArr[3] = 0x00;
            tempArr[4] = 0x01;
            tempArr[5] = 0x01;
            [mutableArry addObject:@"00"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"01"];
        }else if ([speedStr isEqualToString:@"中"]){
        
            tempArr[3] = 0x00;
            tempArr[4] = 0x02;
            tempArr[5] = 0x02;
            [mutableArry addObject:@"00"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"02"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x00;
            tempArr[4] = 0x03;
            tempArr[5] = 0x03;
            [mutableArry addObject:@"00"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"03"];
        }
    }else if ([positionStr isEqualToString:@"上"]){
    
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x01;
            tempArr[4] = 0x01;
            tempArr[5] = 0x02;
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"02"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x01;
            tempArr[4] = 0x02;
            tempArr[5] = 0x03;
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"03"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x01;
            tempArr[4] = 0x03;
            tempArr[5] = 0x04;
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"04"];
        }
    }else if ([positionStr isEqualToString:@"右上"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x02;
            tempArr[4] = 0x01;
            tempArr[5] = 0x03;
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"03"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x02;
            tempArr[4] = 0x02;
            tempArr[5] = 0x04;
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"04"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x02;
            tempArr[4] = 0x03;
            tempArr[5] = 0x05;
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"05"];
        }
    }else if ([positionStr isEqualToString:@"右"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x03;
            tempArr[4] = 0x01;
            tempArr[5] = 0x04;
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"04"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x03;
            tempArr[4] = 0x02;
            tempArr[5] = 0x05;
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"05"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x03;
            tempArr[4] = 0x03;
            tempArr[5] = 0x06;
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"06"];
        }
    }else if ([positionStr isEqualToString:@"右下"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x04;
            tempArr[4] = 0x01;
            tempArr[5] = 0x05;
            [mutableArry addObject:@"04"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"05"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x04;
            tempArr[4] = 0x02;
            tempArr[5] = 0x06;
            [mutableArry addObject:@"04"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"06"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x04;
            tempArr[4] = 0x03;
            tempArr[5] = 0x07;
            [mutableArry addObject:@"04"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"07"];
        }
    }else if ([positionStr isEqualToString:@"下"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x05;
            tempArr[4] = 0x01;
            tempArr[5] = 0x06;
            [mutableArry addObject:@"05"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"06"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x05;
            tempArr[4] = 0x02;
            tempArr[5] = 0x07;
            [mutableArry addObject:@"05"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"07"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x05;
            tempArr[4] = 0x03;
            tempArr[5] = 0x08;
            [mutableArry addObject:@"05"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"08"];
        }
    }else if ([positionStr isEqualToString:@"左下"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x06;
            tempArr[4] = 0x01;
            tempArr[5] = 0x07;
            [mutableArry addObject:@"06"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"07"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x06;
            tempArr[4] = 0x02;
            tempArr[5] = 0x08;
            [mutableArry addObject:@"06"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"08"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x06;
            tempArr[4] = 0x03;
            tempArr[5] = 0x09;
            [mutableArry addObject:@"06"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"09"];
        }
    }else if ([positionStr isEqualToString:@"左"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x07;
            tempArr[4] = 0x01;
            tempArr[5] = 0x08;
            [mutableArry addObject:@"07"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"08"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x07;
            tempArr[4] = 0x02;
            tempArr[5] = 0x09;
            [mutableArry addObject:@"07"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"09"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x07;
            tempArr[4] = 0x03;
            tempArr[5] = 0x0a;
            [mutableArry addObject:@"07"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"0a"];
        }
    }else if ([positionStr isEqualToString:@"左上"]){
        
        if ([speedStr isEqualToString:@"低"]) {
            
            tempArr[3] = 0x08;
            tempArr[4] = 0x01;
            tempArr[5] = 0x09;
            [mutableArry addObject:@"08"];
            [mutableArry addObject:@"01"];
            [mutableArry addObject:@"09"];
        }else if ([speedStr isEqualToString:@"中"]){
            
            tempArr[3] = 0x08;
            tempArr[4] = 0x02;
            tempArr[5] = 0x0a;
            [mutableArry addObject:@"08"];
            [mutableArry addObject:@"02"];
            [mutableArry addObject:@"0a"];
        }else if ([speedStr isEqualToString:@"高"]){
            
            tempArr[3] = 0x08;
            tempArr[4] = 0x03;
            tempArr[5] = 0x0b;
            [mutableArry addObject:@"08"];
            [mutableArry addObject:@"03"];
            [mutableArry addObject:@"0b"];
        }
    }

    rockerArr = mutableArry;
    testArr = mutableArry;

}

- (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    
    return hexData;
}

//写一个值
-(void)writeValue:(Byte [])b length:(int)length{
    
    if (self.characteristic1 != nil) {
        Byte value[length];

        for (int i =0; i<length; i++) {
            value[i] = b[i];
//            NSLog(@"value %x",value[i]);
        }
        
        NSData *data = [NSData dataWithBytes:&value length:length];
        [self.peripheral writeValue:data forCharacteristic:self.characteristic1 type:CBCharacteristicWriteWithoutResponse];
        
        NSLog(@"writeValue -> %@",data);
    }
    
}

- (void)XYZAxisView:(JDYXYZAxisView *)axisView confirmBtn:(UIButton *)confirmBtn{

    NSString *str = @"";
    if (0 == axisRow) {
        str = [NSString stringWithFormat:@"0x%@",[self ToHex:100]];
        unsigned long red = strtoul([str UTF8String],0,16);
        Byte b[6] = {0XAA,0X58,0X03,0X03,red,red};
        [self writeValue:b length:6];
    }else if (1 == axisRow){
    
        str = [NSString stringWithFormat:@"0x%@",[self ToHex:66]];
        unsigned long red = strtoul([str UTF8String],0,16);
        Byte b[6] = {0XAA,0X58,0X03,0X03,red,red};
        [self writeValue:b length:6];
    }else if (2 == axisRow){
        str = [NSString stringWithFormat:@"0x%@",[self ToHex:33]];
        unsigned long red = strtoul([str UTF8String],0,16);
        Byte b[6] = {0XAA,0X58,0X03,0X03,red,red};
        [self writeValue:b length:6];
    }
}

-(NSString *)ToHex:(long long int)tmpid
{
    NSString *nLetterValue;
    NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<9; i++) {
        ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                nLetterValue =@"A";break;
            case 11:
                nLetterValue =@"B";break;
            case 12:
                nLetterValue =@"C";break;
            case 13:
                nLetterValue =@"D";break;
            case 14:
                nLetterValue =@"E";break;
            case 15:
                nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
                
        }
        str = [nLetterValue stringByAppendingString:str];
        if (tmpid == 0) {
            break;  
        }  
        
    }  
    return str;  
}
- (IBAction)restBtnClick:(UIButton *)sender {
    
    if (self.peripheral.state == CBPeripheralStateDisconnected) {
        [self setUpAlertView:@"请连接设备"];
        return;
    }
    if (self.characteristic1 != nil) {
       
        Byte b[6] = {0XAA,0X5e,0X03,0X09,0X01,0x0a};
        [self writeValue:b length:6];
    }
    
}

- (IBAction)knowMoreBtnClick:(UIButton *)sender {
    
    
}


#pragma 移动摄影
- (IBAction)travelingShotBtnClick:(UIButton *)sender {
    
    JDYTravelingShoViewController *TravelingShoVc = [JDYTravelingShoViewController travelingShoViewController];
    TravelingShoVc.view.frame = CGRectMake(0, 0, screenW, screenH);
    [self presentViewController:TravelingShoVc animated:NO completion:nil];
}


@end
