//
//  DataInfo.h
//  MyNote
//
//  Created by xd_ on 15-4-13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataInfo : NSObject

@property int ID;
@property int year;
@property int month;
@property int day;
@property int spendingOrIncomeTag;
@property NSString *categoryFatherName;
@property NSString *categoryChirdName;
@property NSString *money;
@property NSString *remarkString;

-(void)setData:(int)ID withYear:(int)year_info withMonth:(int)month_info withDay:(int)day_info withSpendingOrIncomeTag:(int)tag withFatherName:(NSString *)fatherName withChirdName:(NSString *)chirdName withMoney:(NSString *)money_info withRemark:(NSString *)remark_info;

-(void)setData:(int)year_info withMonth:(int)month_info withDay:(int)day_info withSpendingOrIncomeTag:(int)tag withFatherName:(NSString *)fatherName withChirdName:(NSString *)chirdName withMoney:(NSString *)money_info withRemark:(NSString *)remark_info;

@end
