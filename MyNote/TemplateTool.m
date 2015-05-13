//
//  TemplateTool.m
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "TemplateTool.h"
#import <sqlite3.h>

#define tableName @"templateTable"
#define spendingOrIncome @"spendingOrIncome"
#define money_db @"money"
#define remark_db @"remark"
#define categoryFather_db @"categoryFather"
#define categoryChird_db @"categoryChird"

@implementation TemplateTool


static sqlite3 *db;
static void (^categoryBlock)(NSString *,NSString *,UIPickerView *);


+(void)opendDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:dataBaseName];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
    }else{
        NSLog(@"数据库打开成功");
        //        [self creatTable];
    }
}

+(void)closeDB{
    NSLog(@"数据库关闭");
    sqlite3_close(db);
}

+(void)creatTable{
    char *err;
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS templateTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, spendingOrIncome INTEGER,categoryFather TEXT,categoryChird TEXT,money TEXT,remark TEXT)";
    
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"templateTable数据库表操作数据失败!");
    }else{
        NSLog(@"templateTable数据库表操作数据成功!");
        
    }
    
}

+(void)addData:(TemplateInfo *)info{
    BOOL isTrue = NO;
    for (id item in [self getAllData:-1]) {
        if ([item isEqual:info]) {
            isTrue = YES;
            break;
        }
    }
    for (id item in [self getAllData:1]) {
        if ([item isEqual:info]) {
            isTrue = YES;
            break;
        }
    }
    if (isTrue == NO || [self getAllData:-1] == nil || [self getAllData:1] == nil ) {
        
        
        char *err;
        NSLog(@"传进来的数据:%d",[info spendingOrIncomeTag]);
        NSLog(@"传进来的数据:%@",[info fatherCategoryName]);
        NSLog(@"传进来的数据:%@",[info chirdCategoryName]);
        NSLog(@"传进来的数据:%@",[info money]);
        NSLog(@"传进来的数据:%@",[info remark]);
        
        
        NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@') VALUES ('%d','%@','%@','%@','%@')",tableName,spendingOrIncome,categoryFather_db,categoryChird_db,money_db,remark_db,[info spendingOrIncomeTag],[info fatherCategoryName],[info chirdCategoryName],[info money],[info remark]];
        
        if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
            NSLog(@"添加数据失败!");
           
        }else{
            NSLog(@"添加数据成功!");
        }
    }
}
/**
 *删
 */
+(void)delectData:(TemplateInfo *)info{
//    sqlite3_stmt * statement;
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"delete from templateTable where spendingOrIncome = '%d' and categoryFather = '%@' and categoryChird = '%@' and money = '%@' and remark = '%@' " , [info spendingOrIncomeTag],[info fatherCategoryName],[info chirdCategoryName],[info money],[info remark]];
    
    NSLog(@"[info spendingOrIncomeTag]:%d",[info spendingOrIncomeTag]);
    
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"成功删除");
    }else{
        NSLog(@"删除失败");
    }
//    sqlite3_finalize(statement);
}

/**
 *改
 */
+(void)updataData:(TemplateInfo *)infoDB withNewData:(TemplateInfo *)infoNew{
     char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"update templateTable set spendingOrIncome = '%d' and categoryFather = '%@' and categoryChird = '%@' and money = '%@' and remark = '%@' where spendingOrIncome = '%d' and categoryFather = '%@' and categoryChird = '%@' and money = '%@' and remark = '%@' ", [infoNew spendingOrIncomeTag],[infoNew fatherCategoryName],[infoNew chirdCategoryName],[infoNew money],[infoNew remark], [infoDB spendingOrIncomeTag],[infoDB fatherCategoryName],[infoDB chirdCategoryName],[infoDB money],[infoDB remark]];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result != SQLITE_OK) {
        NSLog(@"修改数据失败");
    }
    
}

/**
 *查
 */
+(NSMutableArray *)getAllData:(int) spendingOrIncomeTag{
    NSMutableArray *dataList = [NSMutableArray array];
    sqlite3_stmt * statement;
    TemplateInfo *dataInfo;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM templateTable where spendingOrIncome = '%d'",spendingOrIncomeTag];  
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[TemplateInfo alloc] init];
            
            int spendingOrIncomeTag = sqlite3_column_int(statement, 1);
            
            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 2);
            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 3);
            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 4);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            char *remark_temp = (char*)sqlite3_column_text(statement, 5);
            NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
            
            [dataInfo setInfo:spendingOrIncomeTag withFathercategory:cateGoryFatherString withChirdCategor:cateGoryChirdString withMoney:money withRemark:remark];
            
            [dataList addObject:dataInfo];
        }
    }
    
    sqlite3_finalize(statement);
    return dataList;
    
}

@end
