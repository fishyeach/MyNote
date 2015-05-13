//
//  DataBaseTool.h
//  MyNote
//
//  Created by xd_ on 15-4-9.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataBaseTool : NSObject

/**
 *打开数据库
 */
+(void)opendDB;

/**
 *关闭数据库
 */
+(void)closeDB;

@end
