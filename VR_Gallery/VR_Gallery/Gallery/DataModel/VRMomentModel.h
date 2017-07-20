//
//  VRMomentModel.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VRMomentModel : NSObject

@property (nonatomic, readwrite) NSUInteger month;
@property (nonatomic, readwrite) NSUInteger year;
@property (nonatomic, readwrite) NSUInteger day;

@property (nonatomic, strong) id assetObjs;

@property (nonatomic, assign) NSUInteger count;

@end
