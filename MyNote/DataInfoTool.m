//
//  DataInfoTool.m
//  MyNote
//
//  Created by xd_ on 15-4-13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "DataInfoTool.h"
#import <sqlite3.h>
#import "DataInfo.h"
#import "TotalTool.h"

#define tableName @"DataInfoTable"
#define spendingOrIncome @"spendingOrIncome"
#define catualOrBudget @"catualOrBudget"
#define ifTemplate @"ifTemplate"
#define time_db @"time"
#define year_db @"year"
#define month_db @"month"
#define day_db @"day"
#define money_db @"money"
#define remark_db @"remark"
#define categoryFather_db @"categoryFather"
#define categoryChird_db @"categoryChird"
#define actual 1
#define budget 0

#define spendingtag -1
#define incomdeTag 1
#define total 0

#define template 1
#define noTemplate 0

@implementation DataInfoTool{
    
}


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
    
    NSString *sqlCreateTable = @"CREATE TABLE IF NOT EXISTS DataInfoTable (ID INTEGER PRIMARY KEY AUTOINCREMENT, year INTEGER,month INTEGER,day INTEGER,spendingOrIncome INTEGER,categoryFather TEXT,categoryChird TEXT,money TEXT,remark TEXT)";
    
    if (sqlite3_exec(db, [sqlCreateTable UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"数据库表操作数据失败!");
    }else{
        NSLog(@"数据库表操作数据成功!");
        
    }

}

/**
 *添加数据
 */
+(BOOL)addData:(DataInfo *)dataInfo{
    char *err;
    NSLog(@"传进来的数据:%@",dataInfo);
    
    NSString *sqlAdd = [NSString stringWithFormat:@"INSERT INTO '%@' ('%@','%@','%@','%@','%@','%@','%@','%@') VALUES ('%d','%d','%d','%d','%@','%@','%@','%@')",tableName,year_db,month_db,day_db,spendingOrIncome,categoryFather_db,categoryChird_db,money_db,remark_db,[dataInfo year],[dataInfo month],[dataInfo day],[dataInfo spendingOrIncomeTag],[dataInfo categoryFatherName],[dataInfo categoryChirdName],[dataInfo money],[dataInfo remarkString]];
    
    if (sqlite3_exec(db, [sqlAdd UTF8String], NULL, NULL, &err) != SQLITE_OK) {
        NSLog(@"添加数据失败!");
        return NO;
    }else{
        NSLog(@"添加数据成功!");
        double totalMoney = [[TotalTool getData] doubleValue] + [[dataInfo money] doubleValue];
        [TotalTool editData:[NSString stringWithFormat:@"%0.2f",totalMoney]];
        return YES;
    }
    
}

#pragma mark -

/**
 *获取某种类别的数据
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag{
    NSMutableArray *dataInfoList = [NSMutableArray array];
    DataInfo *dataInfo;
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE categoryFather = '%@' and categoryChird = '%@' and spendingOrIncome = '%d'",fatherCategory,chirdCategory,spendingOrIncomeTag];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[DataInfo alloc] init];
            int ID = sqlite3_column_int(statement, 0);
            int year = sqlite3_column_int(statement, 1);
            int month = sqlite3_column_int(statement, 2);
            int day = sqlite3_column_int(statement, 3);
   
//            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
//            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
//            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
//            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 7);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            char *remark_temp = (char*)sqlite3_column_text(statement, 8);
            NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
            
            [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:fatherCategory withChirdName:chirdCategory withMoney:money withRemark:remark];
            [dataInfoList addObject:dataInfo];
           
        }
    }
    sqlite3_finalize(statement);
    return dataInfoList;

}

/**
 *获取某种类别的数据year
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year{
    NSMutableArray *dataInfoList = [NSMutableArray array];
    DataInfo *dataInfo;
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE categoryFather = '%@' and categoryChird = '%@' and spendingOrIncome = '%d' and year = '%d'",fatherCategory,chirdCategory,spendingOrIncomeTag,year];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[DataInfo alloc] init];
            int ID = sqlite3_column_int(statement, 0);
            int year = sqlite3_column_int(statement, 1);
            int month = sqlite3_column_int(statement, 2);
            int day = sqlite3_column_int(statement, 3);
            
            //            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
            //            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
            //            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
            //            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 7);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            char *remark_temp = (char*)sqlite3_column_text(statement, 8);
            NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
            
            [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:fatherCategory withChirdName:chirdCategory withMoney:money withRemark:remark];
            [dataInfoList addObject:dataInfo];
            
        }
    }
    sqlite3_finalize(statement);
    return dataInfoList;
}

/**
 *获取某种类别的数据month
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year withMonth:(int)month{
    NSMutableArray *dataInfoList = [NSMutableArray array];
    DataInfo *dataInfo;
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE categoryFather = '%@' and categoryChird = '%@' and spendingOrIncome = '%d' and year = '%d' and month = '%d'",fatherCategory,chirdCategory,spendingOrIncomeTag,year,month];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[DataInfo alloc] init];
            int ID = sqlite3_column_int(statement, 0);
            int year = sqlite3_column_int(statement, 1);
            int month = sqlite3_column_int(statement, 2);
            int day = sqlite3_column_int(statement, 3);
            
            //            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
            //            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
            //            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
            //            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 7);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            char *remark_temp = (char*)sqlite3_column_text(statement, 8);
            NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
            
            [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:fatherCategory withChirdName:chirdCategory withMoney:money withRemark:remark];
            [dataInfoList addObject:dataInfo];
            
        }
    }
    sqlite3_finalize(statement);
    return dataInfoList;
}

/**
 *获取某种类别的数据day
 */
+(NSMutableArray *)getDataInfoWithFatherCategory:(NSString *)fatherCategory withChirdCategory:(NSString *)chirdCategory withSpendingOrIncome:(int)spendingOrIncomeTag withYear:(int)year withMonth:(int)month withDay:(int)day{
    NSMutableArray *dataInfoList = [NSMutableArray array];
    DataInfo *dataInfo;
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE categoryFather = '%@' and categoryChird = '%@' and spendingOrIncome = '%d' and year = '%d' and month = '%d' and day = '%d'",fatherCategory,chirdCategory,spendingOrIncomeTag,year,month,day];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            dataInfo = [[DataInfo alloc] init];
            int ID = sqlite3_column_int(statement, 0);
            int year = sqlite3_column_int(statement, 1);
            int month = sqlite3_column_int(statement, 2);
            int day = sqlite3_column_int(statement, 3);
            
            //            char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
            //            NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
            
            //            char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
            //            NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
            
            char *money_temp = (char*)sqlite3_column_text(statement, 7);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            
            char *remark_temp = (char*)sqlite3_column_text(statement, 8);
            NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
            
            [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:fatherCategory withChirdName:chirdCategory withMoney:money withRemark:remark];
            [dataInfoList addObject:dataInfo];
            
        }
    }
    sqlite3_finalize(statement);
    return dataInfoList;

}

#pragma mark - 获取某段时间（近几天，近几个月，近几年）的数据
/**
 *用于获取一段时间(天)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withMonth:(int)month withDay:(int)day withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum{
    NSMutableArray *dataList = [NSMutableArray array];
     sqlite3_stmt * statement;
    DataInfo *dataInfo;
    if(timeNum == 1){
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE year = '%d' and month = '%d' and day = '%d' and spendingOrIncome = '%d'",year,month,day,spendingOrIncomeTag];
        
       
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                dataInfo = [[DataInfo alloc] init];
                
                int ID = sqlite3_column_int(statement, 0);
                
                char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
                NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
                
                char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
                NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
                
                char *money_temp = (char*)sqlite3_column_text(statement, 7);
                NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
                
                char *remark_temp = (char*)sqlite3_column_text(statement, 8);
                NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
                
                [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:cateGoryFatherString withChirdName:cateGoryChirdString withMoney:money withRemark:remark];
                
                [dataList addObject:dataInfo];
            }
        }
    }
    sqlite3_finalize(statement);
    return dataList;
}
/**
 *用于获取一段时间(月)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withMonth:(int)month withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum{
    NSMutableArray *dataList = [NSMutableArray array];
    DataInfo *dataInfo;
    sqlite3_stmt * statement;
    if(timeNum == 1){
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE year = '%d' and month = '%d' and spendingOrIncome = '%d'",year,month,spendingOrIncomeTag];
        
        
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                dataInfo = [[DataInfo alloc] init];
                
                int ID = sqlite3_column_int(statement, 0);
                
                int day = sqlite3_column_int(statement, 3);
                
                char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
                NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
                
                char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
                NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
                
                char *money_temp = (char*)sqlite3_column_text(statement, 7);
                NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
                
                char *remark_temp = (char*)sqlite3_column_text(statement, 8);
                NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
                
                [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:cateGoryFatherString withChirdName:cateGoryChirdString withMoney:money withRemark:remark];
                
                [dataList addObject:dataInfo];
            }
        }
    }
    sqlite3_finalize(statement);
    return dataList;
}
/**
 *用于获取一段时间(年)的数据
 */
+(NSMutableArray *)getDataInfoWithYear:(int)year withSpendingOrIncome:(int)spendingOrIncomeTag withTime:(int)timeNum{
    NSMutableArray *dataList = [NSMutableArray array];
    DataInfo *dataInfo;
    sqlite3_stmt * statement;

    if(timeNum == 1){
        NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT * FROM DataInfoTable WHERE year = '%d' and spendingOrIncome = '%d'",year,spendingOrIncomeTag];
        
        
        if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                dataInfo = [[DataInfo alloc] init];
                
                int ID = sqlite3_column_int(statement, 0);
                
                int month = sqlite3_column_int(statement, 2);
                
                int day = sqlite3_column_int(statement, 3);
                
                char *cateGoryFather_temp = (char*)sqlite3_column_text(statement, 5);
                NSString *cateGoryFatherString = [[NSString alloc]initWithUTF8String:cateGoryFather_temp];
                
                char *cateGoryChird_temp = (char*)sqlite3_column_text(statement, 6);
                NSString *cateGoryChirdString = [[NSString alloc]initWithUTF8String:cateGoryChird_temp];
                
                char *money_temp = (char*)sqlite3_column_text(statement, 7);
                NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
                
                char *remark_temp = (char*)sqlite3_column_text(statement, 8);
                NSString *remark = [[NSString alloc]initWithUTF8String:remark_temp];
                
                [dataInfo setData:ID withYear:year withMonth:month withDay:day withSpendingOrIncomeTag:spendingOrIncomeTag withFatherName:cateGoryFatherString withChirdName:cateGoryChirdString withMoney:money withRemark:remark];
                
                [dataList addObject:dataInfo];
            }
        }
    }
    sqlite3_finalize(statement);
    return dataList;
}

/**
 *获取总金额
 */
+(double)getTotal:(int)spendingOrIncomeTag{
    double money_total;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM DataInfoTable WHERE spendingOrIncome = '%d'",0];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
             money_total = sqlite3_column_double(statement, 0);
        }
    }
    sqlite3_finalize(statement);
    return money_total;
}

+(void)updataTotal:(double)money{
    double money_total;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM DataInfoTable WHERE spendingOrIncome = '%d'",0];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            money_total = sqlite3_column_double(statement, 0);
        }
    }
    money_total = money_total + money;
    
    NSString *updataString = [NSString stringWithFormat:@"update DataInfoTable set money = '%f' where spendingOrIncome = %d", money_total, 0];
    
    if (sqlite3_prepare_v2(db, [updataString UTF8String], -1, &statement, NULL) == SQLITE_OK){
        if (sqlite3_step(statement) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(statement) == SQLITE_DONE) {
                sqlite3_finalize(statement);
                
            }else{
//                [self closeDB];
            }
        }
    }
    sqlite3_finalize(statement);
}

/**
 *
 */
+(double)getMoneyWithYear:(int)year withMonth:(int)month withDay:(int)day withSpendingOrIncome:(int)spendingOrIncomeTag{
    double money_total = 0;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM DataInfoTable WHERE spendingOrIncome = '%d' and year = '%d' and month = '%d' and day = '%d'",spendingOrIncomeTag,year,month,day];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *money_temp = (char*)sqlite3_column_text(statement, 0);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            money_total = money_total + [money doubleValue];
        }
    }
    
    if (spendingOrIncomeTag == spendingtag) {
//        money_total = money_total * (-1);
    }else if(spendingOrIncomeTag == incomdeTag){
       
    }
   
    sqlite3_finalize(statement);
    return money_total;
}
+(double)getMoneyWithYear:(int)year withMonth:(int)month withSpendingOrIncome:(int)spendingOrIncomeTag{
    double money_total = 0;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM DataInfoTable WHERE spendingOrIncome = '%d' and year = '%d' and month = '%d' ",spendingOrIncomeTag,year,month];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *money_temp = (char*)sqlite3_column_text(statement, 0);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            money_total = money_total + [money doubleValue];
        }
    }
    
    sqlite3_finalize(statement);
    return money_total;
}
+(double)getMoneyWithYear:(int)year withSpendingOrIncome:(int)spendingOrIncomeTag{
    double money_total = 0;
    
    NSString *sqlQuery = [[NSString alloc] initWithFormat:@"SELECT money FROM DataInfoTable WHERE spendingOrIncome = '%d' and year = '%d'",spendingOrIncomeTag,year];
    
    sqlite3_stmt * statement;
    
    if (sqlite3_prepare_v2(db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *money_temp = (char*)sqlite3_column_text(statement, 0);
            NSString *money = [[NSString alloc]initWithUTF8String:money_temp];
            money_total = money_total + [money doubleValue];
        }
    }
    
    if (spendingOrIncomeTag == spendingtag) {
        
    }else if(spendingOrIncomeTag == incomdeTag){
//        money_total = money_total * (-1);
    }
    
    sqlite3_finalize(statement);
    return money_total;
}

+(void)delectData:(int)ID wihtMoney:(NSString *)money{
    char *err;
    NSString *sqlStr = [NSString stringWithFormat:@"delete from DataInfoTable where ID = %d " , ID];
    int result = sqlite3_exec(db, [sqlStr UTF8String], NULL, NULL, &err);
    if (result == SQLITE_OK) {
        NSLog(@"成功删除");
        double totalMoney = [[TotalTool getData] doubleValue] - [money doubleValue];
        [TotalTool editData:[NSString stringWithFormat:@"%0.2f",totalMoney]];
    }
}

+(void)updataDataInfo:(int)ID withMoney:(NSString *)oldMoney withDataInfo:(DataInfo *)dataInfo{
    
    NSLog(@"数据:%d",ID);
    NSLog(@"数据:%d",[dataInfo year]);
    NSLog(@"数据:%d",[dataInfo month]);
    NSLog(@"数据:%d",[dataInfo day]);
    NSLog(@"数据:%d",[dataInfo spendingOrIncomeTag]);
    NSLog(@"数据:%@",[dataInfo categoryFatherName]);
    NSLog(@"数据:%@",[dataInfo categoryChirdName]);
    NSLog(@"数据:%@",[dataInfo money]);
    NSLog(@"数据:%@",[dataInfo remarkString]);
    
    
    sqlite3_stmt *stmt = nil;
    NSString *sqlStr = [NSString stringWithFormat:@"update DataInfoTable set year = '%d',month = '%d',day = '%d', spendingOrIncome = '%d',categoryFather = '%@',categoryChird = '%@',money = '%@',remark = '%@'where id = %d", [dataInfo year],[dataInfo month],[dataInfo day],[dataInfo spendingOrIncomeTag],[dataInfo categoryFatherName],[dataInfo categoryChirdName],[dataInfo money],[dataInfo remarkString],ID];
    int result = sqlite3_prepare_v2(db, [sqlStr UTF8String], -1, &stmt, NULL);
    if (result == SQLITE_OK) {
        if (sqlite3_step(stmt) == SQLITE_ROW) {//觉的应加一个判断, 若有这一行则修改
            if (sqlite3_step(stmt) == SQLITE_DONE) {
                double totalMoney = [[TotalTool getData] doubleValue] - [oldMoney doubleValue] + [[dataInfo money] doubleValue];
                [TotalTool editData:[NSString stringWithFormat:@"%0.2f",totalMoney]];
            }
        }
    }
    sqlite3_finalize(stmt);
    
   
}

@end
