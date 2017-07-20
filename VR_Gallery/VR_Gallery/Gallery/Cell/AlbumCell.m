//
//  AlbumCell.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumCell.h"

@interface AlbumCell ()

@property (weak, nonatomic) IBOutlet UIImageView *posterView;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UILabel *count;

@end

@implementation AlbumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.posterView.layer.cornerRadius = 2;
    self.posterView.layer.masksToBounds = YES;
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 81.3, ScreenWidth, 0.7)];
    line.backgroundColor = [UIColor colorWithHex:0xdfdfdf];
    [self.contentView addSubview:line];
}

- (void)configureWithAlbumObj:(AlbumModel *)obj{
    self.posterView.image = obj.posterImage;
    self.name.text        = obj.name;
    self.count.text       = [NSString stringWithFormat:@"%ld",(long)obj.count];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
