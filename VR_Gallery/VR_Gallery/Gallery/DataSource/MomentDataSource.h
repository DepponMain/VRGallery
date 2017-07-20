//
//  MomentDataSource.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "BaseDataSource.h"

@interface MomentDataSource : BaseDataSource

@property (nonatomic, copy) NSString *headerIdentifier;

- (id)initWithCellIdentifier:(NSString *)cellID headerIdentifier:(NSString *)headerID configureCellBlock:(CellConfigureBlock)block;

@end
