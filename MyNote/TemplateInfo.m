//
//  TemplateInfo.m
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "TemplateInfo.h"

@implementation TemplateInfo

-(void)setInfo:(int)spendingOrIncome withFathercategory:(NSString *)fatherCategory withChirdCategor:(NSString *)chirdCategory withMoney:(NSString *)money withRemark:(NSString *)remarkString{
    _spendingOrIncomeTag = spendingOrIncome;
    _fatherCategoryName = fatherCategory;
    _chirdCategoryName = chirdCategory;
    _money = money;
    _remark = remarkString;
}

@end
