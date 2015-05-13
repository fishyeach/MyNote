//
//  AnimationsTool.m
//  MyNote
//
//  Created by xd_ on 15-4-10.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "AnimationsTool.h"

@implementation AnimationsTool
/**
 *动画效果
 */
+(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time{
    // 动画开始
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    // 动画时间
    [UIView setAnimationDuration:time];
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    [UIView commitAnimations];
}

@end
