//
//  DataInfoTool.h
//  MyNote
//
//  Created by xd_ on 15-4-13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DataInfo;

@interface DataInfoTool : NSObject

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
+(BOOL)addData:(DataInfo *)dataInfo;

#pragma mark -

/**
 *获取某种类别的数据all
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag;
/**
 *获取某种类别的数据year
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year;

/**
 *获取某种类别的数据month
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year withMonth:(int)month;

/**
 *获取某种类别的数据day
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year withMonth:(int)month withDay:(int)day;

#pragma mark - 获取某段时间（近几天，近几个月，近几年）的数据
/**
 *用于获取一段时间(天)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withMonth:(int)month withDay:(int)day withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum;
/**
 *用于获取一段时间(月)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withMonth:(int)month withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum;
/**
 *用于获取一段时间(年)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum;

/**
 *获取总金额
 */
+(double)getTotal:(int)spendingOrIncomeTag;
/**
 *修改总金额
 */
+(void)updataTotal:(double)money;

/**
 *
 */
+(double)getMoneyWithYear:(int)year withMonth:(int)month withDay:(int)day withSpendingOrIncome:(int)spendingOrIncomeTag;
+(double)getMoneyWithYear:(int)year withMonth:(int)month withSpendingOrIncome:(int)spendingOrIncomeTag;
+(double)getMoneyWithYear:(int)year withSpendingOrIncome:(int)spendingOrIncomeTag;

/**
 * 删除记录
 */
+(void)delectData:(int)ID wihtMoney:(NSString *)money;

+(void)updataDataInfo:(int)ID withMoney:(NSString *)oldMoney withDataInfo:(DataInfo *)dataInfo;

+(void)editData:(DataInfo *)oldInfo withData:(DataInfo *)newInfo;
@end
