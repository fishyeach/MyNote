//
//  OneDayData.h
//  MyNote
//
//  Created by xd_ on 15-4-28.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHomeDelegate.h"
#import "BaseViewController.h"
#import "Reload.h"

@interface OneDayData : BaseViewController<UITableViewDataSource,UITableViewDelegate,Reload>
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@property NSMutableArray *spedingList;
@property NSMutableArray *incomeList;
@property NSString *categoryNameSpending;
@property NSString *categoryNameIncome;
@property int year;
@property int month;
@property int day;

@property(nonatomic,assign) id <AddHomeDelegate> onedayDelegate;

@end
