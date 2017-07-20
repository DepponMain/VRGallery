//
//  AlbumDataSource.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumDataSource.h"

@implementation AlbumDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier forIndexPath:indexPath];
    
    cell.tag = indexPath.section * 100 + indexPath.row;
    
    id item = [self itemAtIndexPath:indexPath];
    
    self.block(cell, item, indexPath);
    
    return cell;
}

@end
