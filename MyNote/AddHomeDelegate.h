//
//  AddHomeDelegate.h
//  MyNote
//
//  Created by xd_ on 15-4-22.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AddHomeDelegate <NSObject>
@optional
-(void)reCreate;
-(void)recreatFromBudget;
-(void)reCreateFromOneDay;
@end
