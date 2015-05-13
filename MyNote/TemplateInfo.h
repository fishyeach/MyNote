//
//  TemplateInfo.h
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemplateInfo : NSObject

@property int spendingOrIncomeTag;
@property NSString *fatherCategoryName;
@property NSString *chirdCategoryName;
@property NSString *money;
@property NSString *remark;

-(void)setInfo:(int)spendingOrIncome withFathercategory:(NSString *)fatherCategory withChirdCategor:(NSString *)chirdCategory withMoney:(NSString *)money withRemark:(NSString *)remarkString;

@end
