//
//  AlbumModel.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "AlbumModel.h"
#import <Photos/Photos.h>

@interface AlbumModel ()

@property (nonatomic, strong) PHFetchResult *fetRes;

@end

@implementation AlbumModel

- (id)collection{
    return self.fetRes;
}

- (void)setCollection:(id)collection{
    self.fetRes = (PHFetchResult *)collection;
}

@end
