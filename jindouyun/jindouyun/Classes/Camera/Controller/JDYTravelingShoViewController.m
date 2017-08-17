//
//  JDYTravelingShoViewController.m
//  jindouyun
//
//  Created by jiyi on 2017/8/9.
//  Copyright © 2017年 lh. All rights reserved.
//

#import "JDYTravelingShoViewController.h"
#import "JDYWave.h"
#import "JDYCircleView.h"
#import "JDYCircleProgressView.h"
@interface JDYTravelingShoViewController (){
    JDYWave *_doubleWaveView;
    NSString *flagStr;
    JDYCircleView* _circle;
    JDYCircleProgressView *_circleProgress;
}

@property (weak, nonatomic) IBOutlet UIView *navView;
@property (weak, nonatomic) IBOutlet UIView *locationView;
@property (weak, nonatomic) IBOutlet UIView *progressValueView;
@end

@implementation JDYTravelingShoViewController

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    [self setUpCircleViews];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpSubViews];
}

- (void)setUpCircleViews{

    float lineWidth = 0.05*self.locationView.width;
    CGRect circleFrame = CGRectMake(0, 0, self.locationView.width, self.locationView.height);
    _circle = [[JDYCircleView alloc] initWithFrame:circleFrame lineWidth:lineWidth];
    [self.locationView addSubview:_circle];
    
    _circle.progress = 0.099;
    
    CGRect circleProgressFrame = CGRectMake(0, 0, self.progressValueView.width, self.locationView.height);
    _circleProgress = [[JDYCircleProgressView alloc] initWithFrame:circleProgressFrame lineWidth:lineWidth];
    [self.progressValueView addSubview:_circleProgress];
    _circleProgress.progress = 0.5;
}



- (void)setUpSubViews{
    self.navView.backgroundColor = kNavBGColor;
    _doubleWaveView = [[JDYWave alloc] initWithFrame:CGRectMake(0, self.navView.size.height - 15, screenW, 15)];
    _doubleWaveView.frontColor = FrontColor;
    _doubleWaveView.insideColor = InsideColor;
    _doubleWaveView.directionType = WaveDirectionTypeFoward;
    [self.navView addSubview:_doubleWaveView];
    
    
}

+ (instancetype)travelingShoViewController{

    return [[JDYTravelingShoViewController alloc] initWithNibName:@"JDYTravelingShoViewController" bundle:nil];
}

- (IBAction)sendLocation:(UIButton *)sender {
    
    
}

- (IBAction)startBtnClick:(UIButton *)sender {
    
    
}

- (IBAction)endBtnClick:(UIButton *)sender {
    
    
}

- (IBAction)cancelBtnClick:(UIButton *)sender {
    
    
}

- (IBAction)backBtnCLick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
