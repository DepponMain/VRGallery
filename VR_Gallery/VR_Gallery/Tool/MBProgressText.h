//
//  MBProgressText.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/28.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface MBProgressText : NSObject

+ (void)showHUDWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(CGFloat)time;

@end
