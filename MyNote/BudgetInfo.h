//
//  BudgetInfo.h
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BudgetInfo : NSObject

@property int ID;
@property int year;
@property int month;
@property NSString *fartherCategory;
@property NSString *chirdCategory;
@property NSString *money;

-(void)setData:(int)year withMonth:(int)month withFather:(NSString *)fartherCategory withChird:(NSString *)chirdCategory withMoney:(NSString *)money;

@end
