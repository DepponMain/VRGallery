//
//  MomentCell.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MomentCell : UICollectionViewCell

- (void)configureForImage:(UIImage *)image;

- (void)didSelectSign;

- (void)notSelectSign;

- (void)hideSelectSign;

@end
