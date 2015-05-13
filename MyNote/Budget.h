//
//  Budget.h
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHomeDelegate.h"

@interface Budget : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *dataList;//tableview数据源

@property int year;
@property int month;

@property (nonatomic, assign)   id <AddHomeDelegate>  budgetHomeDeleget;


@end
