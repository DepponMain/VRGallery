//
//  SelectFooterView.h
//  VR_Gallery
//
//  Created by 马海江 on 2017/7/20.
//  Copyright © 2017年 haiJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^deleteBlock)();

@interface SelectFooterView : UIView

@property(nonatomic,copy)deleteBlock block;

@end
