//
//  BaseViewController.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageDataAPI.h"

#define PHOTO_LIST_SIZE CGSizeMake((ScreenWidth - 5 * 6.0 * Pt) / 4, (ScreenWidth - 5 * 6.0 * Pt) / 4)

@interface BaseViewController : UIViewController
{
    dispatch_queue_t serialPGQueue;
}

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *idView;

- (void)showIndicatorView;
- (void)hideIndicatorView;

@end
