//
//  GalleryViewController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"

#import "GalleryViewController.h"
#import "ContainerViewController.h"
#import "SelectFooterView.h"

@interface GalleryViewController ()

@property (nonatomic, weak) ContainerViewController *containerViewController;

@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, weak) SelectFooterView *selectFooter;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.containerViewController swapToViewControllerWithSigueID:SegueIdentifierMoment];
    
    [self creatNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(momentImageDelete:) name:@"momentImageDeleteNotification" object:nil];
}

#pragma mark -- Action
- (void)leftBarButtonItemClick:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"取消"]) {
        [self.rightBarButtonItem setTitle:@"选择"];
        [self.containerViewController cancleBtnClick];
        sender.image = [UIImage imageNamed:@"gallery_moment"];
        sender.title = nil;
        self.title = @"Moment";
        
        self.selectFooter.hidden = YES;
    }else if ([self.title isEqualToString:@"Moment"]){
        sender.image = [UIImage imageNamed:@"gallery_album"];
        self.navigationItem.rightBarButtonItem = nil;
        self.title = @"Album";
        
        [self.containerViewController swapToViewControllerWithSigueID:SegueIdentifierAlbum];
    }else if ([self.title isEqualToString:@"Album"]){
        sender.image = [UIImage imageNamed:@"gallery_moment"];
        self.navigationItem.rightBarButtonItem = self.rightBarButtonItem;
        self.title = @"Moment";
        
        [self.containerViewController swapToViewControllerWithSigueID:SegueIdentifierMoment];
    }
}
- (void)rightBarButtonItemClick:(UIBarButtonItem *)sender{
    if ([sender.title isEqualToString:@"选择"]) {
        [sender setTitle:@"全选"];
        self.leftBarButtonItem.image = nil;
        [self.leftBarButtonItem setTitle:@"取消"];
        self.title = @"已选择0张照片";
        
        self.selectFooter.hidden = NO;
        [self.containerViewController selectBtnClick];
        __weak GalleryViewController *weakSelf = self;
        self.containerViewController.block = ^(NSInteger count){
            weakSelf.title = [NSString stringWithFormat:@"已选择%ld张照片",(long)count];
        };
    }else if ([sender.title isEqualToString:@"全选"]){
        [sender setTitle:@"取消全选"];
        
        [self.containerViewController selectAllBtnClick];
    }else if ([sender.title isEqualToString:@"取消全选"]){
        [sender setTitle:@"全选"];
        
        [self.containerViewController deselectAllBtnClick];
    }
}

#pragma mark -- Delete
- (void)deleteBtnClick{
    [self.containerViewController deleteBtnClick];
}

#pragma mark -- 删除图片
- (void)momentImageDelete:(NSNotification *)notification{
    [self leftBarButtonItemClick:_leftBarButtonItem];
}

#pragma mark -- Navgation
- (void)creatNavigation{
    self.title = @"Moment";
    self.navigationController.navigationBar.tintColor = ThemeColor;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:NavigationTitleFont], NSForegroundColorAttributeName: ThemeColor} forState:UIControlStateNormal];
    
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gallery_moment"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
    
    [self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:YES];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:YES];
}

#pragma mark --Lazy
- (SelectFooterView *)selectFooter{
    if (!_selectFooter) {
        SelectFooterView *selectFooter = [[SelectFooterView alloc] initWithFrame:CGRectMake(0, ScreenHeight - NavigationHeight - TabbarHeight, ScreenWidth, TabbarHeight)];
        _selectFooter = selectFooter;
        _selectFooter.block = ^(){
            [self deleteBtnClick];
        };
        [self.view addSubview:_selectFooter];
    }
    return _selectFooter;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"embedContainer"])
    {
        self.containerViewController = segue.destinationViewController;
    }
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
