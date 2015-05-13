//
//  TotalTool.h
//  MyNote
//
//  Created by xd_ on 15-4-28.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TotalTool : NSObject

+(void)creatTable;
/**
 *添加数据
 */
+(BOOL)addData:(NSString *)money;

/**
 *修改数据
 */
+(BOOL)editData:(NSString *)money;

/**
 *获取数据
 */
+(NSString *)getData;

@end
