//
//  BaseDataSource.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^CellConfigureBlock)(id cell, id item, NSIndexPath *indexPath);

@interface BaseDataSource : NSObject <UITableViewDataSource, UICollectionViewDataSource>

@property (nonatomic, assign) BOOL isEdit;// 编辑状态
@property (nonatomic, strong) NSMutableDictionary *selectSections;// 选中组

@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy)   NSString *cellIdentifier;
@property (nonatomic, copy)   CellConfigureBlock block;

- (id)initWithCellIdentifier:(NSString *)cellID configureCellBlock:(CellConfigureBlock)block;

- (id)itemAtIndexPath:(NSIndexPath *)indexPath;

@end
