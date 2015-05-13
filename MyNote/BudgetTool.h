//
//  BudgetTool.h
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BudgetInfo.h"

@interface BudgetTool : NSObject

/**
 *打开数据库
 */
+(void)opendDB;

/**
 *关闭数据库
 */
+(void)closeDB;

/**
 *创建数据表
 */
+(void)creatTable;

/**
 *添加数据
 */
+(BOOL)addData:(BudgetInfo *)info;

/**
 *修改数据
 */
+(BOOL)editData:(BudgetInfo *)info;

/**
 *获取数据
 */
+(NSMutableArray *)getData:(int)year withMonth:(int)month;

/**
 *删除
 */
+(BOOL)delectData:(int)ID;

+(double)getMoney:(int)year withMonth:(int)month;


@end
