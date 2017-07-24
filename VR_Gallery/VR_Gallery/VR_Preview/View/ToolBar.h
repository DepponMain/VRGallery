//
//  ToolBar.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/24.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^lastBlock)();
typedef void(^nextBlock)();
typedef void(^glassBlock)();

@interface ToolBar : UIToolbar

@property (nonatomic, copy) lastBlock last;
@property (nonatomic, copy) nextBlock next;
@property (nonatomic, copy) glassBlock glass;

@end
