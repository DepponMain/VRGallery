//
//  MomentModel.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "MomentModel.h"
#import <Photos/Photos.h>

@interface MomentModel ()

@property (nonatomic, strong) PHFetchResult *assets;

@end

@implementation MomentModel

- (NSUInteger)count{
    return self.assets.count;
}

- (id)assetObjs{
    return self.assets;
}

- (void)setAssetObjs:(id)assetObjs{
    self.assets = (PHFetchResult *)assetObjs;
}

@end
