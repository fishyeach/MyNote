//
//  Template.h
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHomeDelegate.h"

@interface Template : UIViewController<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>

@property (nonatomic, assign)   id <AddHomeDelegate>  addDelegate;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//数据
@property (strong, nonatomic) NSMutableArray *templateArr_spending;
@property (strong, nonatomic) NSMutableArray *templateArr_income;
@property (strong, nonatomic) UISegmentedControl *spendingOrIncomdeSegment;
- (IBAction)getSpendingOrIncomeTag:(id)sender;

@end
