//
//  TemplateTool.h
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TemplateInfo.h"

@interface TemplateTool : NSObject

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
 *增
 */
+(void)addData:(TemplateInfo *)info;

/**
 *删
 */
+(void)delectData:(TemplateInfo *)info;

/**
 *改
 */
+(void)updataData:(TemplateInfo *)infoDB withNewData:(TemplateInfo *)infoNew;

/**
 *查
 */
+(NSMutableArray *)getAllData:(int) spendingOrIncomeTag;

@end
