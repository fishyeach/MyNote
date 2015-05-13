//
//  CategoryEdit.h
//  MyNote
//
//  Created by xd_ on 15/5/7.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reload.h"

@interface CategoryEdit : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property int spendingOrIncome;
@property int fatherOrChird;
@property (strong, nonatomic) NSString *oldFather;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic)  NSMutableArray *fatherArr;
@property (strong, nonatomic)  NSMutableArray *chirdArr;

@property (nonatomic, assign) id<Reload> reloadDelegate;

@end
