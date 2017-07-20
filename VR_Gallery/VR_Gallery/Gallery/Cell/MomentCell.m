//
//  MomentCell.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "MomentCell.h"

@interface MomentCell ()

@property (weak, nonatomic) IBOutlet UIImageView *ThumbImage;

@property (weak, nonatomic) IBOutlet UIImageView *EditImage;

@end

@implementation MomentCell

- (void)awakeFromNib{
    [super awakeFromNib];
    self.EditImage.hidden = YES;
}
- (void)layoutSubviews{
    // fix size error - .5 pixel in iOS 7
    self.contentView.frame = self.bounds;
    [super layoutSubviews];
}

- (void)configureForImage:(UIImage *)image{
    self.ThumbImage.image = image;
}

- (void)didSelectSign{
    self.EditImage.hidden = NO;
    self.EditImage.image = [UIImage imageNamed:@"gallery_image_select"];
}
- (void)notSelectSign{
    self.EditImage.hidden = NO;
    self.EditImage.image = [UIImage imageNamed:@"icon_not_select"];
}
- (void)hideSelectSign{
    self.EditImage.hidden = YES;
}

@end
