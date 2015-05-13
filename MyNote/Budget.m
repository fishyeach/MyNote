//
//  Budget.m
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "Budget.h"
#import "AddBudget.h"
#import "BudgetCell.h"
#import "BudgetTool.h"
#import "BudgetInfo.h"
#import "Tools.h"

@interface Budget ()

@end

@implementation Budget

-(void)viewDidLayoutSubviews{
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsZero];
        
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"新增预算" style:UIBarButtonItemStylePlain target:self action:@selector(addbudget)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeThis)];
    self.navigationItem.leftBarButtonItem = backButton;

}

-(void)closeThis{
    [self.budgetHomeDeleget recreatFromBudget];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addbudget{
    AddBudget *addBudget = [AddBudget new];
    addBudget.year = _year;
    addBudget.month = _month;
    [self.navigationController pushViewController:addBudget animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - addhomedelegate
-(void)reCreate{
    
}

#pragma mark -  tableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"budgetcell";
    BudgetCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"BudgetCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//无选中效果
    
    cell.categoryLabel.text = [NSString stringWithFormat:@"%@-%@",[[_dataList objectAtIndex:indexPath.row] fartherCategory],[[_dataList objectAtIndex:indexPath.row] chirdCategory]];
    cell.moneyLabel.text = [[_dataList objectAtIndex:indexPath.row] money];
    
    return cell;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [BudgetTool opendDB];
        _dataList = [BudgetTool getData:_year withMonth:_month];
        [BudgetTool closeDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            [_tableView reloadData];
        });
        
    });

}

//设置单元格可编辑
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

//删除样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{

    [BudgetTool opendDB];
    [BudgetTool delectData:[[_dataList objectAtIndex:indexPath.row] ID]];
    [BudgetTool closeDB];
    
    [_dataList removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    UIAlertView *saveAlter = [[UIAlertView alloc] initWithTitle:@"删除成功" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
    [saveAlter show];
}

//设置cell高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 103;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

@end
