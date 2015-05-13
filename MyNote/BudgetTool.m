//
//  BudgetTool.m
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "BudgetTool.h"
#import <sqlite3.h>

#define tableName @"budgetTable"
#define year_db @"year"
#define month_db @"month"
#define fartherCategory_db @"fartherCategory"
#define chirdCategory_db @"chirdCategory"
#define money_db @"money"

@implementation BudgetTool

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

    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS budgetTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER,month INTEGER,fartherCategory TEXT,chirdCategory TEXT,money TEXT)";
    
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"Budget数据库表操作数据失败!");
    }else{
        NSLog(@"Budget数据库表操作数据成功!");
        
    }
    
}

+(BOOL)addData:(BudgetInfo *)info{
    NSLog(@"INFO:%D",info.year);
     NSLog(@"INFO:%D",info.month);
     NSLog(@"INFO:%@",@"SS");
     NSLog(@"INFO:%@",@"SS");
     NSLog(@"INFO:%@",info.money);
    char *err;
    
     NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@') VALUES ('%d','%d','%@','%@','%@')",tableName,year_db,month_db,fartherCategory_db,chirdCategory_db,money_db,[info year],[info month],[info fartherCategory],[info chirdCategory],[info money]];
    
    if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"添加数据失败!");
        return NO;
        
    }else{
        NSLog(@"添加数据成功!");
        return YES;
    }

}

+(BOOL)editData:(BudgetInfo *)info{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"update budgetTable set year = '%d' and month = '%d' and fartherCategory = '%@' and chirdCategory = '%@' and money = '%@' where ID = '%d' ", [info year],[info month],[info fartherCategory],[info chirdCategory],[info money], [info ID]];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result != SQLITE_OK) {
        NSLog(@"修改数据失败");
        return NO;
    }else{
         NSLog(@"修改数据成功");
        return YES;
    }
}

+(NSMutableArray *)getData:(int)year withMonth:(int)month{
    NSMutableArray *arr = [NSMutableArray array];
    sqlite3_stmt * statement;
    BudgetInfo *dataInfo;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM budgetTable where year = '%d'",year];
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[BudgetInfo alloc] init];
            
            int ID = sqlite3_column_int(statement, 0);
//             int year_tem = sqlite3_column_int(statement, 1);
//             int month_tem = sqlite3_column_int(statement, 2);
            
            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 3);
            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 4);
            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 5);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            
            [dataInfo setData:year withMonth:month withFather:cateGoryFatherString withChird:cateGoryChirdString withMoney:money];
            [dataInfo setID:ID];
            
            [arr addObject:dataInfo];
        }
    }
    
    sqlite3_finalize(statement);
    return arr;
}

+(BOOL)delectData:(int)ID{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"delete from budgetTable where ID = '%d'" , ID];
    
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"成功删除");
        return YES;
    }else{
        NSLog(@"删除失败");
        return NO;
    }
    
}

+(double)getMoney:(int)year withMonth:(int)month{
    double money = 0;
    sqlite3_stmt * statement;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM budgetTable where year = '%d' and month = '%d'",year,month];
    
    
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
        
            char *money_temp = (char*)sqlite3_column_text(statement, 0);
            NSString *mon = [[NSString alloc]initWithUTF8String:money_temp];
            
            money += money + [mon doubleValue];
          
        }
    }
    
    sqlite3_finalize(statement);
    return money;

}

@end
