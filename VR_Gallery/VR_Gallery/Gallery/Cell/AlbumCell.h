//
//  AlbumCell.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AlbumModel.h"

@interface AlbumCell : UITableViewCell

- (void)configureWithAlbumObj:(AlbumModel *)obj;

@end
