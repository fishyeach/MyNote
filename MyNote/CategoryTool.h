//
//  CategoryTool.h
//  MyNote
//
//  Created by xd_ on 15-4-9.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CategoryTool : NSObject

/**
 *打开数据库
 */
+(void)opendDB;

/**
 *关闭数据库
 */
+(void)closeDB;

+(void)firstAdd;
/**
 *显示类别选择器
 *withWichFalg:(int)withcFlag区分是否要显示全部按钮 --1表示显示 0表示不显示
 */
+(void)showCategory:(UIView *)superView withFlag:(int)flag withWichFalg:(int)withcFlag withCallBack:(void (^)(UIButton *,UIButton *,UIButton *,UIPickerView *))callBack;

/**
 *创建数据表
 */
+(void)creatCategoryTable;

/**
 *从数据库中获取类别
 */
+(NSMutableArray *)getCategoryFromDB:(int)flag;

+(NSMutableArray *)getFatherCate:(int)flag;
+(NSMutableArray *)getChirdCate:(NSString *) fatherString withFlag:(int)flag;

/**
 *编辑
 */
+(void)editCate:(NSString *)oldFather withOldChird:(NSString *)oldChird withNew:(NSString *)newFather withNewChird:(NSString *)newChird;
+(void)editCate:(NSString *)oldFather withNew:(NSString *)str;

/**
 *增
 */
+(void)addCate:(NSString *)fatherString withChird:(NSString *)chirdString;

/**
 *删除
 */
+(void)delect:(NSString *)fatherString withChird:(NSString *)chirdString;
@end
