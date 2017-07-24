//
//  VRPreviewController.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/24.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VRPreviewController : UIViewController

@property (nonatomic, strong) NSMutableArray *dataSource;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, copy) NSString *imageName;

@end
