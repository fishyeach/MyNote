//
//  AnimationsTool.h
//  MyNote
//
//  Created by xd_ on 15-4-10.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnimationsTool : NSObject

/**
 *动画效果
 */
+(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time;

@end
