//
//  DataInfo.m
//  MyNote
//
//  Created by xd_ on 15-4-13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "DataInfo.h"

@implementation DataInfo

-(void)setData:(int)ID withYear:(int)year_info withMonth:(int)month_info withDay:(int)day_info withSpendingOrIncomeTag:(int)tag withFatherName:(NSString *)fatherName withChirdName:(NSString *)chirdName withMoney:(NSString *)money_info withRemark:(NSString *)remark_info{
    _ID = ID;
    _year = year_info;
    _month = month_info;
    _day = day_info;
    _spendingOrIncomeTag = tag;
    _categoryFatherName = fatherName;
    _categoryChirdName = chirdName;
    _money = money_info;
    _remarkString = remark_info;
}

-(void)setData:(int)year_info withMonth:(int)month_info withDay:(int)day_info withSpendingOrIncomeTag:(int)tag withFatherName:(NSString *)fatherName withChirdName:(NSString *)chirdName withMoney:(NSString *)money_info withRemark:(NSString *)remark_info{
    _year = year_info;
    _month = month_info;
    _day = day_info;
    _spendingOrIncomeTag = tag;
    _categoryFatherName = fatherName;
    _categoryChirdName = chirdName;
    _money = money_info;
    _remarkString = remark_info;
}

@end
