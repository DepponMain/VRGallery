//
//  AlbumPhotoController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumPhotoController.h"
#import "AlbumPhotoCell.h"
#import <Photos/Photos.h>
#import "MWPhotoBrowser.h"

@interface AlbumPhotoController ()<UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, assign) CGFloat margin;
@property (nonatomic, assign) CGFloat size;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation AlbumPhotoController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.margin = 17.0 * Pt;
    self.size = (ScreenWidth - 5 * _margin - 0.5) / 4;
    
    self.title = _albumObj.name;
    [self crateCollectionView];
}

#pragma mark -- Push to browser
- (void)pushWithIndex:(NSInteger)index{
    NSMutableArray *array = _albumObj.collection;
    
    NSMutableArray *photos = [NSMutableArray array];
    NSMutableArray *thumbs = [NSMutableArray array];
    
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

#pragma mark -- CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    [self pushWithIndex:indexPath.item];
    
//    NSMutableArray *array = _albumObj.collection;
//    PushToBrowser *push = [PushToBrowser new];
//    [push pushToBrowserWith:indexPath.item assetArray:array byWhichNavigation:self.navigationController delegeteController:self];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *assetArr = self.albumObj.collection;
    return assetArr.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AlbumPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"albumPhotoCell" forIndexPath:indexPath];
    PHAsset *asset = self.albumObj.collection[indexPath.item];
    [[ImageDataAPI sharedInstance] getThumbnailForAssetObj:asset withSize:CGSizeMake(_size, _size) completion:^(BOOL ret, UIImage *image){
        [cell configureForImage:image];
    }];
    return cell;
}

#pragma mark -- CollectionView
- (void)crateCollectionView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = _margin;
    layout.minimumInteritemSpacing = _margin;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.itemSize = CGSizeMake(_size, _size);
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    self.collectionView = collectionView;
    collectionView.contentInset = UIEdgeInsetsMake(_margin, _margin, _margin, _margin);
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [collectionView registerClass:[AlbumPhotoCell class] forCellWithReuseIdentifier:@"albumPhotoCell"];
    collectionView.showsVerticalScrollIndicator = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    [self.view addSubview:collectionView];
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
