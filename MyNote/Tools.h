//
//  Tools.h
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tools : NSObject

/**
 *获取现在的日期
 */
+(NSString *)getNowTime;
/**
 *把datapicker的时间转化成年月日（int）
 */
+(NSArray *)getTimeArrFromDataPicker:(NSString *)datapicker_time;

/**
 *获取类别的数组
 */
+(NSArray *)getCategoryArr:(NSString *)cateString;

//加载器
+ (void)showHUD:(NSString *)msg;
+ (void)removeHUD;

/**
 *颜色生成图片
 */
+(UIImage *)getImageFromColor:(UIColor *)color withView:(UIView *)btn;

/**
 *给键盘添加按钮
 */
+(void)addBtnForKeyBoard:(UITextField *)textField withCallback:(void (^)(int tag))callback;

+(int)getWeekOfFirstDayOfMonth;
+(int)getDaysOfMonth:(int)year withMonth:(int)month;

+(NSString *)stringDisposeWithFloat:(double)floatValue;

/**
 *加边框
 */
+(void)addBorder:(UIView *)view;

/**
 *显示类别选择器
 */
+(void)showCategoryPicker:(UIViewController *)viewController withWhichPicker:(int)whichCategory withCallBack:(void(^)(UIButton *,UIButton *,UIButton *,UIPickerView *))callBack;

/**
 *编辑输入框的数字，只能有一个小数点
 */
+(NSMutableString *)textFiledEdit:(NSString *)text;
@end
