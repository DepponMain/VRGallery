//
//  MomentViewController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "MomentViewController.h"
#import <Photos/Photos.h>
#import "MomentCell.h"
#import "MomentModel.h"
#import "VRMomentModel.h"
#import "MomentDataSource.h"
#import "MomentFlowLayout.h"

@interface MomentViewController ()<UICollisionBehaviorDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *momentView;
@property (nonatomic, strong) MomentDataSource *dataSource;

@property (nonatomic, strong) NSMutableDictionary *selectedDict;// Picture selected
@property (nonatomic, strong) NSMutableDictionary *selectAssetDict;// Asset selected
@property (nonatomic, strong) NSMutableArray *localAssetArray;// All VR picture resource

@property (nonatomic, assign) BOOL isEdit;// Edit status
@property (nonatomic, assign) BOOL browseEnable;// Can not browse until the picture resource is loaded

@end

@implementation MomentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.momentView.allowsMultipleSelection = NO;
    self.isEdit = NO;
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                [self loadMomentElements];
            }
        }];
    }
    [self loadMomentView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectSection:) name:@"sectionDidSelected" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deselectSection:) name:@"sectionDidDeselected" object:nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[ImageDataAPI sharedInstance] haveAccessToPhotos]){
        [self loadMomentElements];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideIndicatorView];
            self.browseEnable = YES;
        });
    }
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- load momentView
- (void)loadMomentView{
    MomentFlowLayout *layout = (MomentFlowLayout *)[self.momentView collectionViewLayout];
    [layout setItemSize:PHOTO_LIST_SIZE];
    layout.minimumLineSpacing = 17.0 * Pt;
    layout.minimumInteritemSpacing = 17.0 * Pt;
    layout.sectionHeadersPinToVisibleBounds = YES;
    [layout setHeaderReferenceSize:CGSizeMake(ScreenWidth, 105.0 * Pt)];
    
    CellConfigureBlock configureCell = ^(MomentCell *cell, id asset, NSIndexPath *indexPath){
        [[ImageDataAPI sharedInstance] getThumbnailForAssetObj:asset withSize:PHOTO_LIST_SIZE completion:^(BOOL ret, UIImage *image) {
            [cell configureForImage:image];
        }];
        
        if (_isEdit) {
            NSString *state = [self.selectedDict objectForKey:indexPath];
            if ([state isEqualToString:@"isSelected"]) {
                [cell didSelectSign];
            }else{
                [cell notSelectSign];
            }
        }else{
            [cell hideSelectSign];
        }
    };
    
    MomentDataSource *pDataSource = [[MomentDataSource alloc] initWithCellIdentifier:@"MomentCell" headerIdentifier:@"MomentHeader" configureCellBlock:configureCell];
    self.momentView.dataSource = pDataSource;
    self.momentView.bounces = YES;
    self.momentView.backgroundColor = [UIColor colorWithHex:0xeeeeee];
    self.momentView.contentInset = UIEdgeInsetsMake(0, 17.0 * Pt, 0, 17.0 * Pt);
    [self setDataSource:pDataSource];
}

#pragma mark -- load momentSource and screen VR picture
- (void)loadMomentElements{
    [self showIndicatorView];
    self.browseEnable = NO;
    
    dispatch_async(serialPGQueue, ^{
        [[ImageDataAPI sharedInstance] getMomentsWithBatchReturn:YES ascending:NO completion:^(BOOL done, id obj) {
            
            NSMutableArray *dArr = (NSMutableArray *)obj;
            NSMutableArray *resultArr = [[NSMutableArray alloc] init];
            __block int tag = 0; __block BOOL isFind = NO;
            [self.localAssetArray removeAllObjects];
            
            for (int i = 0; i < dArr.count; i++) {
                MomentModel *group = dArr[i]; VRMomentModel *vr_group = [VRMomentModel new];
                NSMutableArray *assetArr = [NSMutableArray array];
                
                for (int j = 0; j < group.count; j++) {
                    PHAsset *asset = group.assetObjs[j];
                    [[ImageDataAPI sharedInstance] getImageForPhotoObj:asset withSize:CGSizeZero completion:^(BOOL ret, UIImage *image) {
                        if (image.size.width == 2 * image.size.height) {
                            isFind = YES; [assetArr addObject:asset]; [self.localAssetArray addObject:asset];
                            if (tag != i) {
                                vr_group.month = group.month; vr_group.year = group.year; vr_group.day = group.day;
                                tag = i;
                            }
                        }
                    }];
                }
                if (isFind) {
                    vr_group.assetObjs = assetArr; [resultArr addObject:vr_group]; isFind = NO;
                }
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (done) {[self hideIndicatorView];self.browseEnable = YES;}
                [self reloadWithData:resultArr];
            });
        }];
    });
}

#pragma mark -- reload momentView
- (void)reloadWithData:(NSMutableArray *)data{
    [self.dataSource.items removeAllObjects];
    [self.dataSource.items addObjectsFromArray:data];
    [self.momentView reloadData];
}

#pragma mark -- CollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (!_isEdit && !_browseEnable) {
        return;
    }
    if (_isEdit) {
        [self.selectedDict setObject:@"isSelected" forKey:indexPath];
        VRMomentModel *group = self.dataSource.items[indexPath.section];
        [self.selectAssetDict setObject:group.assetObjs[indexPath.item] forKey:indexPath];
        self.block(self.selectedDict.count);
        
        for (int i = 0; i < group.count; i++) {
            if (![collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:indexPath.section]].isSelected) {
                break;
            }
            if (i == group.count - 1) {
                [self.dataSource.selectSections setValue:@"isSelected" forKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
            }
        }
        
        [self.momentView reloadData];
        NSArray *seleArr = [self.selectedDict allKeys];
        for (int i = 0; i < seleArr.count; i++) {
            [self.momentView selectItemAtIndexPath:seleArr[i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }else{
        NSInteger index = 0;
        for (int i = 0; i < self.dataSource.items.count; i++) {
            VRMomentModel *group  = [self.dataSource.items objectAtIndex:i];
            if (i < indexPath.section) {
                index += group.count;
            }else if (indexPath.section == i){
                index += indexPath.item;
            }
        }
        
        NSDictionary *messageDic = @{@"array":_localAssetArray,@"index":[NSString stringWithFormat:@"%ld",(long)index]};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ImageDidSelectNotification" object:messageDic];
    }
}
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_isEdit) {
        [self.selectedDict removeObjectForKey:indexPath];
        [self.selectAssetDict removeObjectForKey:indexPath];
        self.block(self.selectedDict.count);
        [self.dataSource.selectSections removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]];
        
        [self.momentView reloadData];
        NSArray *seleArr = [self.selectedDict allKeys];
        for (int i = 0; i < seleArr.count; i++) {
            [self.momentView selectItemAtIndexPath:seleArr[i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
}

#pragma mark -- Action
- (void)selectBtnClick{
    self.dataSource.isEdit = YES; self.isEdit = YES; self.momentView.allowsMultipleSelection = YES; [self.momentView reloadData];
}
- (void)cancleBtnClick{
    self.dataSource.isEdit = NO; self.isEdit = NO; [self.selectedDict removeAllObjects]; [self.selectAssetDict removeAllObjects]; [self.dataSource.selectSections removeAllObjects]; [self.momentView reloadData];
}
- (void)selectAllBtnClick{
    [self.selectedDict removeAllObjects]; [self.selectAssetDict removeAllObjects];
    for (int i = 0; i < _dataSource.items.count; i++) {
        VRMomentModel *group = self.dataSource.items[i];
        [self.dataSource.selectSections setValue:@"isSelected" forKey:[NSString stringWithFormat:@"%d",i]];
        for (int j = 0; j < group.count; j++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:i];
            [self.selectedDict setObject:@"isSelected" forKey:indexPath];
            PHAsset *asset = group.assetObjs[j];
            [self.selectAssetDict setObject:asset forKey:indexPath];
        }
    }
    self.block(self.selectedDict.count);
    [self.momentView reloadData];
    NSArray *seleArr = [self.selectedDict allKeys];
    for (int i = 0; i < seleArr.count; i++) {
        [self.momentView selectItemAtIndexPath:seleArr[i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}
- (void)deselectAllBtnClick{
    self.block(0); [self.selectedDict removeAllObjects]; [self.selectAssetDict removeAllObjects]; [self.dataSource.selectSections removeAllObjects]; [self.momentView reloadData];
}
- (void)deleteBtnClick{
    NSArray *selectArr = [self.selectAssetDict allValues];
    if (selectArr.count < 1) {
//        MBProgressHUD *hud=[(AppDelegate *)[UIApplication sharedApplication].delegate responseWithString:@"没有可删除的选项"];
//        [hud hide:YES afterDelay:0.5];
        return;
    }else{
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            [PHAssetChangeRequest deleteAssets:selectArr];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if (success) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.selectedDict removeAllObjects]; [self.selectAssetDict removeAllObjects]; [self loadMomentElements];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"momentImageDeleteNotification" object:nil];
                });
            }
        }];
    }
}

#pragma mark -- Notification Action
- (void)selectSection:(NSNotification *)section{
    NSInteger Section = [section.object integerValue];
    [self.dataSource.selectSections setValue:@"isSelected" forKey:[NSString stringWithFormat:@"%ld",(long)Section]];
    
    VRMomentModel *group = self.dataSource.items[Section];
    for (int j = 0; j < group.count; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:Section];
        [self.selectedDict setObject:@"isSelected" forKey:indexPath];
        [self.selectAssetDict setObject:group.assetObjs[j] forKey:indexPath];
    }
    self.block(self.selectedDict.count);
    [self.momentView reloadData];
    
    NSArray *seleArr = [self.selectedDict allKeys];
    for (int i = 0; i < seleArr.count; i++) {
        [self.momentView selectItemAtIndexPath:seleArr[i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}
- (void)deselectSection:(NSNotification *)section{
    NSInteger Section = [section.object integerValue];
    [self.dataSource.selectSections removeObjectForKey:[NSString stringWithFormat:@"%ld",(long)Section]];
    
    VRMomentModel *group = self.dataSource.items[Section];
    for (int j = 0; j < group.count; j++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:j inSection:Section];
        [self.selectedDict removeObjectForKey:indexPath];
        [self.selectAssetDict removeObjectForKey:indexPath];
    }
    self.block(self.selectedDict.count);
    [self.momentView reloadData];
    
    NSArray *seleArr = [self.selectedDict allKeys];
    for (int i = 0; i < seleArr.count; i++) {
        [self.momentView selectItemAtIndexPath:seleArr[i] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    }
}

#pragma mark -- Lazy
- (NSMutableDictionary *)selectedDict{
    if (!_selectedDict) {
        _selectedDict = [NSMutableDictionary dictionary];
    }
    return _selectedDict;
}
- (NSMutableDictionary *)selectAssetDict{
    if (!_selectAssetDict) {
        _selectAssetDict = [NSMutableDictionary dictionary];
    }
    return _selectAssetDict;
}
- (NSMutableArray *)localAssetArray{
    if (!_localAssetArray) {
        _localAssetArray = [NSMutableArray array];
    }
    return _localAssetArray;
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
