//
//  AlbumViewController.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumViewController.h"
#import "AlbumCell.h"
#import "AlbumDataSource.h"
#import "AlbumPhotoController.h"

@interface AlbumViewController ()<UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *albumView;

@property (nonatomic, strong) AlbumDataSource *dataSource;

@property (nonatomic, retain) NSMutableArray *albumDataArray;

@end

@implementation AlbumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.albumView.separatorStyle = UITableViewCellSeparatorStyleNone;
    CellConfigureBlock configCell = ^(AlbumCell *cell, AlbumModel *group, NSIndexPath *indexPath){
        if (group.posterImage == nil) {
            NSInteger cTag = cell.tag; // to determin if cell is reused
            [[ImageDataAPI sharedInstance] getPosterImageForAlbumObj:group completion:^(BOOL ret, id obj){
                group.posterImage = (UIImage *)obj;
                if (cell.tag == cTag) [cell configureWithAlbumObj:group];
            }];
        }else{
            [cell configureWithAlbumObj:group];
        }
    };
    
    AlbumDataSource *dataSource = [[AlbumDataSource alloc] initWithCellIdentifier:@"AlbumCell" configureCellBlock:configCell];
    self.albumView.dataSource = dataSource;
    [self setDataSource:dataSource];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[ImageDataAPI sharedInstance] haveAccessToPhotos]){
        [self loadAlbums];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self hideIndicatorView];
        });
    }
}

- (void)loadAlbums{
    [self showIndicatorView];
    dispatch_async(serialPGQueue, ^{
        [[ImageDataAPI sharedInstance] getAlbumsWithCompletion:^(BOOL ret, id obj){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.dataSource.items removeAllObjects];
                self.dataSource.items = (NSMutableArray *)obj;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self hideIndicatorView];
                    if (ret) [self.albumView reloadData];
                });
            });
        }];
    });
}

#pragma mark -- TableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 82;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    AlbumPhotoController *photo = [[AlbumPhotoController alloc] init];
    photo.albumObj = [_dataSource itemAtIndexPath:indexPath];
    [self.navigationController pushViewController:photo animated:YES];
}

#pragma mark -- Lazy
- (NSMutableArray *)albumDataArray{
    if (!_albumDataArray) {
        _albumDataArray = [NSMutableArray array];
    }
    return _albumDataArray;
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
