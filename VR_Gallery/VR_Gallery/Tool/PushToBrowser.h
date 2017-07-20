//
//  PushToBrowser.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PushToBrowser : NSObject

+ (void)pushToBrowserWith:(NSInteger)index assetArray:(NSMutableArray *)array byWhichNavigation:(UINavigationController *)navigation;

@end
