//
//  BudgetInfo.m
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "BudgetInfo.h"

@implementation BudgetInfo

-(void)setData:(int)year withMonth:(int)month withFather:(NSString *)fartherCategory withChird:(NSString *)chirdCategory withMoney:(NSString *)money{
    _year = year;
    _money = money;
    _month = month;
    _fartherCategory = fartherCategory;
    _chirdCategory = chirdCategory;
}

@end
