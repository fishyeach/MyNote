//
//  TotalTool.m
//  MyNote
//
//  Created by xd_ on 15-4-28.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "TotalTool.h"
#import <sqlite3.h>

#define tableName @"totalTable"
#define total @"total"


@implementation TotalTool

static sqlite3 *db;

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
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS totalTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, total TEXT)";
    
    [self opendDB];
    
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"templateTable数据库表操作数据失败!");
    }else{
        NSLog(@"templateTable数据库表操作数据成功!");
        
    }
    
    [self closeDB];
    
}
/**
 *添加数据
 */
+(BOOL)addData:(NSString *)money{
    BOOL result = NO;
    
    [self opendDB];
    
    char *err;
    
    NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@') VALUES ('%@')",tableName,total,money];
    
    if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"添加数据失败!");
        result = NO;
        
    }else{
        NSLog(@"添加数据成功!");
        result = YES;
    }

    
    [self closeDB];
    
    return result;
}

/**
 *修改数据
 */
+(BOOL)editData:(NSString *)money{
    BOOL reslut = NO;
    [self opendDB];
    
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"update totalTable set total = '%@' ", money];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result != SQLITE_OK) {
        NSLog(@"TOTAL修改数据失败");
        result = NO;
    }else
        result = YES;
    
    [self closeDB];
    
    return reslut;
}

/**
 *获取数据
 */
+(NSString *)getData{
    
     sqlite3_stmt * statement;
    NSString *money = @"";
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM totalTable"];
    
    [self opendDB];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            
            char *money_temp = (char*)sqlite3_column_text(statement, 0);
            money = [[NSString alloc]initWithUTF8String:money_temp];
            
        }
    }

    
    [self closeDB];
    
    return money;
}

@end
