//
//  OneDayData.m
//  MyNote
//
//  Created by xd_ on 15-4-28.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "OneDayData.h"
#import "OneDayDataCell.h"
#import "OneDayDataHeader.h"
#import "Tools.h"
#import "DataInfo.h"
#import "DataInfoTool.h"
#import "AddHome.h"
#import "BaseViewController.h"
#import "CategoryTool.h"


#define spendingtag -1
#define incomdeTag 1

#define firstTag 2
#define onedayTag 3
#define onedayAddTag 4

#define btn1tag 5
#define btn2tag 6
#define btn3tag 7

@interface OneDayData (){
    int spendingOrIncome;
    double incomeTotal,spendingTotal;
    NSString *cateSpending,*cateOncome;
    
}

@end

@implementation OneDayData


-(void)viewWillAppear:(BOOL)animated{
//    NSLog(@"viewDidAppear");
     [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DataInfoTool opendDB];
        _spedingList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:spendingtag withTime:1];
        _incomeList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:incomdeTag withTime:1];
        [DataInfoTool closeDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
            [Tools removeHUD];
        });
        
    });
   
}

-(void)viewDidLayoutSubviews{
//     NSLog(@"viewDidLayoutSubviews");
    if ([_tableview respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableview setSeparatorInset:UIEdgeInsetsZero];
        
    }
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([_tableview respondsToSelector:@selector(setLayoutMargins:)]) {
        [_tableview setLayoutMargins:UIEdgeInsetsZero];
    }
#endif
}

- (void)viewDidLoad {
//    NSLog(@"viewDidLoad");
    [super viewDidLoad];
    _categoryNameIncome = @"全部";
    _categoryNameSpending = @"全部";
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(closeThis)];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self initView];
    
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addData)];
    self.navigationItem.rightBarButtonItem = addButton;
}

-(void)addData{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddHome* addHome = [myStoryboard instantiateViewControllerWithIdentifier:@"addhome"];
    addHome.witchTag = onedayAddTag;
    addHome.timeStr = [NSString stringWithFormat:@"%D年%D月%d日",_year,_month,_day];
    addHome.onedayReload = self;
    addHome.yearOneday = _year;
    addHome.monthOneday = _month;
    addHome.dayOneday = _day;
    [self.navigationController pushViewController:addHome animated:YES];
}

-(void)closeThis{
    [_onedayDelegate reCreateFromOneDay];
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)initView{
    _tableview.dataSource = self;
    _tableview.delegate = self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - tableview数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return [_spedingList count];
    }else
        return [_incomeList count];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifer = @"onedaydatacell";
    OneDayDataCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"OneDayDataCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifer];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];//无选中效果
    
    if (indexPath.section == 0) {
        cell.categoryLabel.text = [NSString stringWithFormat:@"%@-%@",[[_spedingList objectAtIndex:indexPath.row] categoryFatherName],[[_spedingList objectAtIndex:indexPath.row] categoryChirdName]];
        cell.moneyLabel.text = [[_spedingList objectAtIndex:indexPath.row] money];
        cell.remarkLabel.text = [[_spedingList objectAtIndex:indexPath.row] remarkString];
    }else{
        cell.categoryLabel.text = [[_incomeList objectAtIndex:indexPath.row] categoryChirdName];
        cell.moneyLabel.text = [[_incomeList objectAtIndex:indexPath.row] money];
        cell.remarkLabel.text = [[_incomeList objectAtIndex:indexPath.row] remarkString];
    }
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    spendingTotal = 0;
    incomeTotal = 0;
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"OneDayDataHeader" owner:nil options:nil];
    OneDayDataHeader *header = [views objectAtIndex:0];
    header.frame = CGRectMake(0, 0, Screen_width, 63);
    if (section == 0) {
        header.title.text = @"支出:";
       
        for (DataInfo *info in _spedingList){
            spendingTotal = spendingTotal + [[info money] doubleValue];
        }
//        NSLog(@"--------:%F",spendingTotal);
        header.titleMoney.text = [Tools stringDisposeWithFloat:spendingTotal];
        header.titleCategory.text = _categoryNameSpending;
    }else{
        header.title.text = @"收入:";
        
        for (DataInfo *info in _incomeList){
            incomeTotal = incomeTotal + [[info money] doubleValue];
        }
        header.titleMoney.text = [Tools stringDisposeWithFloat:incomeTotal];
        header.titleCategory.text = _categoryNameIncome;
        
    }
    [header.selectCategoryBtn setTag:section];
    [header.selectCategoryBtn addTarget:self action:@selector(headerBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 56;
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
    [DataInfoTool opendDB];
    if (indexPath.section == 0) {
        [DataInfoTool delectData:[[_spedingList objectAtIndex:indexPath.row] ID] wihtMoney:[[_spedingList objectAtIndex:indexPath.row] money]];
        [_spedingList removeObjectAtIndex:indexPath.row];
        
    }else{
         [DataInfoTool delectData:[[_incomeList objectAtIndex:indexPath.row] ID] wihtMoney:[[_incomeList objectAtIndex:indexPath.row] money]];
        [_incomeList removeObjectAtIndex:indexPath.row];
       

    }
    [DataInfoTool closeDB];

    [_tableview deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    UIAlertView *saveAlter = [[UIAlertView alloc] initWithTitle:@"删除成功" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
    [saveAlter show];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *myStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AddHome* addHome = [myStoryboard instantiateViewControllerWithIdentifier:@"addhome"];  //test2为viewcontroller的StoryboardId
//   addHome.str = @"我来自查询";
    if (indexPath.section == 0) {
        addHome.witchTag = onedayTag;
        addHome.flag = spendingtag;
        addHome.fatherStr = [[_spedingList objectAtIndex:indexPath.row] categoryFatherName];
        addHome.chirdStr = [[_spedingList objectAtIndex:indexPath.row] categoryChirdName];
        addHome.moneyStr = [[_spedingList objectAtIndex:indexPath.row] money];
        addHome.remarkStr = [[_spedingList objectAtIndex:indexPath.row] remarkString];
        addHome.timeStr = [NSString stringWithFormat:@"%D年%D月%d日",_year,_month,_day];
        addHome.ID = [[_spedingList objectAtIndex:indexPath.row] ID];
    }else{
        addHome.witchTag = onedayTag;
        addHome.flag = incomdeTag;
        addHome.fatherStr = [[_incomeList objectAtIndex:indexPath.row] categoryFatherName];
        addHome.chirdStr = [[_incomeList objectAtIndex:indexPath.row] categoryChirdName];
        addHome.moneyStr = [[_incomeList objectAtIndex:indexPath.row] money];
        addHome.remarkStr = [[_incomeList objectAtIndex:indexPath.row] remarkString];
        addHome.timeStr = [NSString stringWithFormat:@"%D年%D月%d日",_year,_month,_day];
        addHome.ID = [[_incomeList objectAtIndex:indexPath.row] ID];
    }
    addHome.onedayReload = self;
    [self.navigationController pushViewController:addHome animated:YES];
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

-(void)headerBtnAction:(UIButton *)btn{

    if (btn.tag == 0) {
        spendingOrIncome = spendingtag;
    }else
        spendingOrIncome = incomdeTag;
    
    [Tools showCategoryPicker:self withWhichPicker:spendingOrIncome withCallBack:^(UIButton *btn1,UIButton *btn2,UIButton *btn3,UIPickerView *picker){
        self.mPicker = picker;
        self.mPicker.dataSource = self;
        self.mPicker.delegate = self;
        self.whichCategory = spendingOrIncome;
        
        self.categoryArr = [CategoryTool getCategoryFromDB:self.whichCategory];
        
        if (spendingOrIncome == spendingtag) {
            self.categoryFather = [NSMutableArray array];
            self.categortChird = [NSMutableArray array];
            for (id dic in self.categoryArr) {
                [self.categoryFather addObject:[[dic allKeys] objectAtIndex:0]];
                
            }
            
            [CategoryTool closeDB];
            
            [self.mPicker selectRow:4 inComponent:0 animated:YES];
            self.categortChird = [[[self.categoryArr objectAtIndex:4] allValues]objectAtIndex:0];
            self.fatherString = [self.categoryFather objectAtIndex:4];
            self.chirdString = [[[[self.categoryArr objectAtIndex:4] allValues] objectAtIndex:0] objectAtIndex:0];
            self.cateString = [[NSString alloc] initWithFormat:@"%@-%@",[self.categoryFather objectAtIndex:4],[[[[self.categoryArr objectAtIndex:4] allValues]objectAtIndex:0] objectAtIndex:0]];
        }else{
            [self.mPicker selectRow:0 inComponent:0 animated:YES];
            self.cateString = [self.categoryArr objectAtIndex:0];
        }
        
        [btn1 setTag:btn1tag];
        [btn2 setTag:btn2tag];
        [btn3 setTag:btn3tag];
        [btn1 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn2 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn3 addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];

    }];
    
}

-(void)btnAction:(UIButton *)btn{
    NSInteger btnTag = btn.tag;
    switch (btnTag) {
        case btn1tag:
            [DataInfoTool opendDB];
            if (spendingOrIncome == spendingtag) {
                if ([_categoryNameSpending isEqualToString:@"全部"]) {
                    [DataInfoTool closeDB];
                    break;
                }
                _categoryNameSpending = @"全部";
                _spedingList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:spendingtag withTime:1];
            }else{
                if ([_categoryNameIncome isEqualToString:@"全部"]) {
                    [DataInfoTool closeDB];
                    break;
                }
                _categoryNameIncome = @"全部";
                _incomeList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:incomdeTag withTime:1];
            }
            [DataInfoTool closeDB];
            [_tableview reloadData];
            [btn.superview.superview removeFromSuperview];
            break;
        case btn2tag:
            [btn.superview.superview removeFromSuperview];
            break;
        case btn3tag:
            if (spendingOrIncome == spendingtag) {
                _categoryNameSpending = self.cateString;
                [DataInfoTool opendDB];
                _spedingList = [DataInfoTool getDataInfoWithFatherCategory:self.fatherString withChirdCategory:self.chirdString withSpendingOrIncome:spendingtag withYear:_year withMonth:_month withDay:_day];
                [DataInfoTool closeDB];
            }else{
                _categoryNameIncome = self.cateString;
                [DataInfoTool opendDB];
                _incomeList = [DataInfoTool getDataInfoWithFatherCategory:@"" withChirdCategory:_categoryNameIncome withSpendingOrIncome:incomdeTag withYear:_year withMonth:_month withDay:_day];
                [DataInfoTool closeDB];
            }
            [_tableview reloadData];
            [btn.superview.superview removeFromSuperview];
            break;
            
        default:
            break;
    }
    
}

-(void)viewWillLayoutSubviews{
//    NSLog(@"viewWillLayoutSubviews");
}
-(void)viewDidDisappear:(BOOL)animated{
//    NSLog(@"viewDidDisappear");
}
-(void)viewDidAppear:(BOOL)animated{
   
}

#pragma mark - reload代理
-(void)reloadView{
    
    [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [DataInfoTool opendDB];
        _spedingList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:spendingtag withTime:1];
        _incomeList = [DataInfoTool getDataInfoWithYear:_year withMonth:_month withDay:_day withSpendingOrIncome:incomdeTag withTime:1];
        [DataInfoTool closeDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableview reloadData];
            [Tools removeHUD];
        });
        
    });
}

@end
