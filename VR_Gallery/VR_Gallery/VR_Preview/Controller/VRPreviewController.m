//
//  VRPreviewController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/24.
//  Copyright © 2017年 haiJiang. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import "VRPreviewController.h"
#import "MDVRLibrary.h"
#import "MWPhoto.h"
#import "ToolBar.h"
#import <CoreMotion/CoreMotion.h>

@interface VRPreviewController ()<IMDImageProvider, UIGestureRecognizerDelegate>{
    BOOL canRotate;
    BOOL isFirstLoad;
}
@property (nonatomic, strong) MDVRLibrary *vrLibrary;
@property (nonatomic, strong) CMMotionManager *motionManager;
@property (nonatomic, strong) NSMutableArray *D_valueArray;
@property (nonatomic, assign) BOOL isHideBar;
@property (nonatomic, assign) BOOL isGlass;
@property (nonatomic, weak) ToolBar *toolBar;
@property (nonatomic, weak) UILabel *titleLabel;

@end

@implementation VRPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isHideBar = NO; self.isGlass = NO; kAppDelegate.allowRotation = 3; [self crateUI];
    
    // TapGesture
    UITapGestureRecognizer * privateLetterTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAvatarView:)];
    privateLetterTap.numberOfTouchesRequired = 1;
    privateLetterTap.numberOfTapsRequired = 1;
    privateLetterTap.delegate = self;
    [self.view addGestureRecognizer:privateLetterTap];
    
    self.D_valueArray = [NSMutableArray array];
    canRotate = NO;
    isFirstLoad = YES;
    [self startMotionManager];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleDeviceOrientationDidChange:) name:UIDeviceOrientationDidChangeNotification object:nil
     ];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    MDVRConfiguration* config = [MDVRLibrary createConfig];
    [config displayMode:MDModeDisplayNormal];
    [config interactiveMode:MDModeInteractiveTouch];
    [config projectionMode:MDModeProjectionSphere];
    [config asImage:self];
    [config setContainer:self view:self.view];
    [config pinchEnabled:true];
    
    self.vrLibrary = [config build];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    kAppDelegate.allowRotation = 2;
    NSString *newPage = [NSString stringWithFormat:@"%ld",(long)_currentPage];
    NSNotification *notification = [NSNotification notificationWithName:@"back" object:newPage];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
    
    [self.toolBar removeFromSuperview];
    self.navigationController.navigationBar.hidden = NO;
    self.vrLibrary = nil;
    [_motionManager stopDeviceMotionUpdates];
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
}

#pragma mark -- Delegate
- (void)onProvideImage:(id<TextureCallback>)callback {
    if ([callback respondsToSelector:@selector(texture:)]) {
        [callback texture:self.image];
    }
}

#pragma mark -- tap gesture
- (void)tapAvatarView: (UITapGestureRecognizer *)gesture{
}

#pragma mark -- Determine whether locked the screen
- (void)handleDeviceOrientationDidChange:(UIInterfaceOrientation)interfaceOrientation{
    UIDevice *device = [UIDevice currentDevice];
    switch (device.orientation) {
        case UIDeviceOrientationLandscapeLeft:
            [_motionManager stopDeviceMotionUpdates];
            canRotate = YES;
            break;
        case UIDeviceOrientationLandscapeRight:
            [_motionManager stopDeviceMotionUpdates];
            canRotate = YES;
            break;
        default:
            break;
    }
}
- (void)startMotionManager{
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    _motionManager.deviceMotionUpdateInterval = 0.1;
    if (_motionManager.deviceMotionAvailable) {
        [_motionManager startDeviceMotionUpdatesToQueue:[NSOperationQueue currentQueue] withHandler: ^(CMDeviceMotion *motion, NSError *error){
            [self performSelectorOnMainThread:@selector(handleDeviceMotion:) withObject:motion waitUntilDone:YES];
        }];
    }else {
        [self setMotionManager:nil];
    }
}
- (void)handleDeviceMotion:(CMDeviceMotion *)deviceMotion{
    double x = deviceMotion.gravity.x;
    double y = deviceMotion.gravity.y;
    double z = deviceMotion.gravity.z;
    
    double d_value = fabs(x) - fabs(y);
    if (_D_valueArray.count < 5) {
        [self.D_valueArray addObject:[NSNumber numberWithDouble:d_value]];
        return;
    }else if(_D_valueArray.count == 5){
        [self.D_valueArray removeObjectAtIndex:0];
        [self.D_valueArray addObject:[NSNumber numberWithDouble:d_value]];
    }
    if ([_D_valueArray[0] doubleValue] > 0.5 && [_D_valueArray[1] doubleValue] > 0.5 && [_D_valueArray[2] doubleValue] > 0.5 && [_D_valueArray[3] doubleValue] > 0.5 && [_D_valueArray[4] doubleValue] > 0.5) {
        if (isFirstLoad) {
            return;
        }
        if(canRotate == NO){
            [_motionManager stopDeviceMotionUpdates];
            UIAlertController *ac = [UIAlertController alertControllerWithTitle:@"提醒" message:@"您打了开屏幕锁定,请在控制中心关闭" preferredStyle:UIAlertControllerStyleAlert];
            [ac addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
            }]];
            [self presentViewController:ac animated:YES completion:nil];
        }
    }
    if (fabs(y) - fabs(x) > 0.5){
        isFirstLoad = NO;
    }
    if (fabs(z) > 0.8){
        isFirstLoad = NO;
    }
}

#pragma mark -- Action
- (void)lastButtonClick{
    
}
- (void)nextButtonClick{
    
}
- (void)glassButtonClick{
    
}

#pragma mark -- UI
- (void)crateUI{
    UILabel *titleLabel = [[UILabel alloc] init];
    self.titleLabel = titleLabel;
    titleLabel.text = _imageName;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithHex:0x333333];
    titleLabel.font = [UIFont systemFontOfSize:50.0 * Pt];
    self.navigationItem.titleView = titleLabel;
    self.navigationItem.titleView.frame = CGRectMake(0, 0, 200, 32);
    
    ToolBar *toolBar = [[ToolBar alloc] initWithFrame:CGRectMake(0, ScreenHeight - ToolbarHeight, ScreenWidth, ToolbarHeight)];
    self.toolBar = toolBar;
    toolBar.last = ^{
        [self lastButtonClick];
    };
    toolBar.next = ^{
        [self nextButtonClick];
    };
    toolBar.glass = ^{
        [self glassButtonClick];
    };
    [self.view addSubview:toolBar];
    
    
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
