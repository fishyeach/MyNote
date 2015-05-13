//
//  SeachResultTableViewController.h
//  MyNote
//
//  Created by xd_ on 15/5/13.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeachResultTableViewController : UITableViewController
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property int fromTag;//判断来自哪里
@property (strong, nonatomic) NSMutableArray *spendingList;
@property (strong, nonatomic) NSMutableArray *incomeList;
@property int spendingOrIncome;
@property (strong, nonatomic) NSString *titleStr;
@property (strong, nonatomic) NSString *categoryStr;


@end
