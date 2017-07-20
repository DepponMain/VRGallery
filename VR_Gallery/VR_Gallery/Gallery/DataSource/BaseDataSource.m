//
//  BaseDataSource.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "BaseDataSource.h"

@implementation BaseDataSource

- (id)initWithCellIdentifier:(NSString *)cellID configureCellBlock:(CellConfigureBlock)block{
    self = [super init];
    if (self){
        self.cellIdentifier = cellID;
        
        self.block = [block copy];
        self.items = [[NSMutableArray alloc] init];
        self.selectSections = [NSMutableDictionary dictionary];
    }
    return self;
}

- (id)itemAtIndexPath:(NSIndexPath *)indexPath{
    return self.items[(NSUInteger)indexPath.row];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return nil;
}

@end
