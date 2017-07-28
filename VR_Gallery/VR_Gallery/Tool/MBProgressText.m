//
//  MBProgressText.m
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/28.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import "MBProgressText.h"

@implementation MBProgressText

+ (void)showHUDWithText:(NSString *)text inView:(UIView *)view hideAfterDelay:(CGFloat)time{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = text;
    [hud hideAnimated:YES afterDelay:time];
}

@end
