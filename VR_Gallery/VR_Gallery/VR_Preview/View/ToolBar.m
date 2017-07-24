//
//  ToolBar.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/24.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "ToolBar.h"

@implementation ToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIButton *lastBtn = [[UIButton alloc] init];
    [lastBtn setImage:[UIImage imageNamed:@"gallery_last_iamge"] forState:UIControlStateNormal];
    [lastBtn addTarget:self action:@selector(lastButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:lastBtn];
    [lastBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(0);
        make.centerY.equalTo(self);
        make.height.offset(32);
        make.width.offset(60);
    }];
    
    UIButton *nextBtn = [[UIButton alloc] init];
    [nextBtn setImage:[UIImage imageNamed:@"gallery_next_iamge"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextBtn];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(lastBtn.mas_right);
        make.centerY.equalTo(self);
        make.height.offset(32);
        make.width.offset(60);
    }];
    
    UIButton *VRBtn = [[UIButton alloc] init];
    [VRBtn setImage:[UIImage imageNamed:@"gallery_vr"] forState:UIControlStateNormal];
    [VRBtn addTarget:self action:@selector(glassButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:VRBtn];
    [VRBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(0);
        make.centerY.equalTo(self);
        make.height.offset(32);
        make.width.offset(60);
    }];
}

- (void)lastButtonClick{
    self.last();
}

- (void)nextButtonClick{
    self.next();
}

- (void)glassButtonClick{
    self.glass();
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
