//
//  DataBaseTool.m
//  MyNote
//
//  Created by xd_ on 15-4-9.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "DataBaseTool.h"
#import <sqlite3.h>

@implementation DataBaseTool

static sqlite3 *db;


+(void)opendDB{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documents = [paths objectAtIndex:0];
    NSString *database_path = [documents stringByAppendingPathComponent:dataBaseName];
    
    if (sqlite3_open([database_path UTF8String], &db) != SQLITE_OK) {
        NSLog(@"数据库打开失败");
    }else{
        NSLog(@"数据库打开成功");
    }
}

+(void)closeDB{
    sqlite3_close(db);
}

@end
