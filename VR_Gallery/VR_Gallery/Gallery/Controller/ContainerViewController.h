//
//  ContainerViewController.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^selectImagesCount)(NSInteger count);

#define SegueIdentifierMoment @"embedMoment"
#define SegueIdentifierAlbum  @"embedAlbum"

@interface ContainerViewController : UIViewController

- (BOOL)swapToViewControllerWithSigueID:(NSString *)ID;

@property (nonatomic, copy)selectImagesCount block;

- (void)selectBtnClick;

- (void)cancleBtnClick;

- (void)selectAllBtnClick;

- (void)deselectAllBtnClick;

- (void)deleteBtnClick;

@end
