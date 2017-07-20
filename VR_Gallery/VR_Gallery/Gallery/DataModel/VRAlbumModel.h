//
//  VRAlbumModel.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRAlbumModel : NSObject

@property (nonatomic, strong) NSString  *name;
@property (nonatomic, strong) UIImage   *posterImage;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) id collection;

@end
