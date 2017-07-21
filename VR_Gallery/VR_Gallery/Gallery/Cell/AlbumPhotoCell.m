//
//  AlbumPhotoCell.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/21.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumPhotoCell.h"

@interface AlbumPhotoCell ()

@property (nonatomic, weak) UIImageView *thumbImage;

@end

@implementation AlbumPhotoCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *thumbImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        self.thumbImage = thumbImage;
        thumbImage.contentMode = UIViewContentModeScaleAspectFill;
        thumbImage.layer.masksToBounds = YES;
        [self addSubview:thumbImage];
    }
    return self;
}

- (void)configureForImage:(UIImage *)image{
    self.thumbImage.image = image;
}

@end 
