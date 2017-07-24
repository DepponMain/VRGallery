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
#import "MWPhotoBrowser.h"

@interface GalleryViewController ()<MWPhotoBrowserDelegate>

@property (nonatomic, weak) ContainerViewController *containerViewController;

@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;
@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, weak) SelectFooterView *selectFooter;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation GalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    [self.containerViewController swapToViewControllerWithSigueID:SegueIdentifierMoment];
    
    [self creatNavigation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveImagePicker:) name:@"ImageDidSelectNotification" object:nil];
    
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

#pragma mark -- DeleteBtn Click
- (void)deleteBtnClick{
    [self.containerViewController deleteBtnClick];
}

#pragma mark -- Notification Action
- (void)momentImageDelete:(NSNotification *)notification{
    [self leftBarButtonItemClick:_leftBarButtonItem];
}
- (void)didReceiveImagePicker:(NSNotification *)notification{
    NSDictionary *messageDic = [notification object];
    NSMutableArray * array = messageDic[@"array"];
    NSString *indexStr = messageDic[@"index"];
    int index = [indexStr intValue];
    NSMutableArray *photos = [[NSMutableArray alloc] init];
    NSMutableArray *thumbs = [[NSMutableArray alloc] init];
    
    @synchronized(array) {
        NSMutableArray *copy = [array copy];
        if (NSClassFromString(@"PHAsset")) {
            // Photos library
            UIScreen *screen = [UIScreen mainScreen];
            CGFloat scale = screen.scale;
            // Sizing is very rough... more thought required in a real implementation
            CGFloat imageSize = MAX(screen.bounds.size.width, screen.bounds.size.height) * 1.5;
            CGSize imageTargetSize = CGSizeMake(imageSize * scale, imageSize * scale);
            CGSize thumbTargetSize = CGSizeMake(imageSize / 3.0 * scale, imageSize / 3.0 * scale);
            for (PHAsset *asset in copy) {
                [photos addObject:[MWPhoto photoWithAsset:asset targetSize:imageTargetSize]];
                [thumbs addObject:[MWPhoto photoWithAsset:asset targetSize:thumbTargetSize]];
            }
        }
    }
    
    self.photos = photos;
    self.thumbs = thumbs;
    
    // Create browser
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.zoomPhotosToFill = YES;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    browser.dataSource = self.photos;
    browser.imageDateDict = [self imageDateWithObj:self.photos];
    [self.navigationController pushViewController:browser animated:YES];
    double delayInSeconds = 3;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
    });
}
#pragma mark -- title of time
- (NSMutableDictionary *)imageDateWithObj:(NSMutableArray *)obj{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    for (int i = 0; i < obj.count; i++) {
        MWPhoto *photos = obj[i];
        PHAsset *asset = photos.asset;
        NSDate *date = asset.creationDate;
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy年MM月dd日HH:mm"];
        NSString *dateStr = [dateFormatter stringFromDate:date];
        [dict setValue:dateStr forKey:[NSString stringWithFormat:@"%@",asset.localIdentifier]];
    }
    return dict;
}

#pragma mark - MWPhotoBrowserDelegate
- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}
- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

#pragma mark -- Navgation
- (void)creatNavigation{
    self.title = @"Moment";
    self.navigationController.navigationBar.tintColor = ThemeColor;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:NavigationTitleFont], NSForegroundColorAttributeName: ThemeColor} forState:UIControlStateNormal];
    
    self.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"gallery_moment"] style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonItemClick:)];
    
    [self.navigationItem setLeftBarButtonItem:self.leftBarButtonItem animated:YES];
    
    self.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonItemClick:)];
    
    [self.navigationItem setRightBarButtonItem:self.rightBarButtonItem animated:YES];
}

#pragma mark --Lazy
- (SelectFooterView *)selectFooter{
    if (!_selectFooter) {
        SelectFooterView *selectFooter = [[SelectFooterView alloc] initWithFrame:CGRectMake(0, ScreenHeight -ToolbarHeight, ScreenWidth, ToolbarHeight)];
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

@end
