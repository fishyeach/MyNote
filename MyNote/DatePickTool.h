//
//  Tool.h
//  MyNote
//
//  Created by xd_ on 15-4-8.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface DatePickTool : NSObject


/**
 *给view添加边框
 */
+(void)setViewBroder:(UIView *)view;

/**
 *加载datapicker
 */
//+(void)showDataPicker:(UIView *)superView withFlag:(void (^)(int flag))callBack;
//+(void)showDataPicker:(UIView *)superView;
+(void)showDatePicker:(UIView *)superView withFlag:(void (^)(NSString *))callBack;

+(int)getFlag;



@end
