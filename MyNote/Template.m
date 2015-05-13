//
//  Template.m
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "Template.h"
#import "TemplateCell.h"
#import "DataInfoTool.h"
#import "DataInfo.h"
#import "Tools.h"
#import "TemplateInfo.h"
#import "TemplateTool.h"
#import "TemplateEdit.h"

#define spendingTag -1
#define incomdeTag 1
#define SAVETAG 10

@interface Template (){
    NSMutableArray *arr;
    int spendingOrIncomeTag;
}

@end

@implementation Template

- (void)viewDidLoad {
    [super viewDidLoad];
    
    spendingOrIncomeTag = spendingTag;//默认是支出类型
    arr = _templateArr_spending;
    
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self initSagment];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(closeThisView)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(addTemplate)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
//    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

//初始化分段控制
-(void)initSagment{
    _spendingOrIncomdeSegment = [[UISegmentedControl alloc] initWithItems:nil];
    [_spendingOrIncomdeSegment insertSegmentWithTitle:@"支出模板" atIndex:0 animated:YES];
    [_spendingOrIncomdeSegment insertSegmentWithTitle:@"收入模板" atIndex:1 animated:YES];
    
    _spendingOrIncomdeSegment.selectedSegmentIndex = 0;
    [_spendingOrIncomdeSegment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:0];
    [_spendingOrIncomdeSegment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:1];
    
    [_spendingOrIncomdeSegment setTintColor:myRedColor];
    self.navigationItem.titleView = _spendingOrIncomdeSegment;
    
    [_spendingOrIncomdeSegment addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)controlPressed:(UISegmentedControl *)segment{
    NSInteger index = [_spendingOrIncomdeSegment selectedSegmentIndex];
    
    if (index == 0) {
        spendingOrIncomeTag = spendingTag;
    }else{
        spendingOrIncomeTag = incomdeTag;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TemplateTool opendDB];
        if (spendingOrIncomeTag == spendingTag) {
            _templateArr_spending = [TemplateTool getAllData:spendingOrIncomeTag];
            arr = _templateArr_spending ;
        }else{
            _templateArr_income = [TemplateTool getAllData:spendingOrIncomeTag];
            arr = _templateArr_income ;
        }
        [TemplateTool opendDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [Tools removeHUD];
        });
        
    });
    
    
}

//关闭模态视图
-(void)closeThisView{
    [self dismissViewControllerAnimated:YES completion:nil];
}

//添加模板
-(void)addTemplate{
    TemplateEdit *templateEdite = [[TemplateEdit alloc] init];
    [self.navigationController pushViewController:templateEdite animated:YES];
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableviewdataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [arr count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"TemplateCell";
    TemplateCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"TemplateCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if (spendingOrIncomeTag == spendingTag) {
         cell.categoryName.text = [[NSString alloc] initWithFormat:@"%@-%@",[[arr objectAtIndex:indexPath.row] fatherCategoryName],[[arr objectAtIndex:indexPath.row] chirdCategoryName]];
    }else{
          cell.categoryName.text = [[NSString alloc] initWithFormat:@"%@%@",[[arr objectAtIndex:indexPath.row] fatherCategoryName],[[arr objectAtIndex:indexPath.row] chirdCategoryName]];
    }
   
    cell.moneyLabel.text = [[NSString alloc] initWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] money]];
    cell.remarkLabel.text = [[NSString alloc] initWithFormat:@"%@",[[arr objectAtIndex:indexPath.row] remark]];
    
    [cell.cellEditBtn setTag:indexPath.row];
    [cell.cellEditBtn addTarget:self action:@selector(edit:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
    //    count -= 1;
    //    [_tableView reloadData];
  /*
    [DataInfoTool opendDB];
    [Tools showHUD:NSLocalizedString(@"saving", @"")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [TemplateTool delectData:[arr objectAtIndex:indexPath.row]];
        NSString *log = [[NSString alloc] initWithFormat:@"%@",arr];
        NSLog(@"删除的数据是:%@",log);
        [DataInfoTool closeDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            [arr removeObjectAtIndex:indexPath.row];
            [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
            
            UIAlertView *saveAlter = [[UIAlertView alloc] initWithTitle:@"删除成功" message:nil delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
            [saveAlter setTag:SAVETAG];
            [saveAlter show];
            
        });
    });*/
    [TemplateTool opendDB];
    [TemplateTool delectData:[arr objectAtIndex:indexPath.row]];
    [TemplateTool closeDB];
    [arr removeObjectAtIndex:indexPath.row];
    [_tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    UIAlertView *saveAlter = [[UIAlertView alloc] initWithTitle:@"删除成功" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
    [saveAlter show];

    
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

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *timeArr = [Tools getTimeArrFromDataPicker:[Tools getNowTime]];
    
    DataInfo *dataInfo = [[DataInfo alloc] init];
    NSLog(@"info:%d",[[arr objectAtIndex:indexPath.row] spendingOrIncomeTag]);
     NSLog(@"info:%@",[[arr objectAtIndex:indexPath.row] fatherCategoryName]);
     NSLog(@"info:%@",[[arr objectAtIndex:indexPath.row] chirdCategoryName]);
     NSLog(@"info:%@",[[arr objectAtIndex:indexPath.row] money]);
     NSLog(@"info:%@",[[arr objectAtIndex:indexPath.row] remark]);

    [dataInfo setData:[[timeArr objectAtIndex:0] intValue] withMonth:[[timeArr objectAtIndex:1] intValue] withDay:[[timeArr objectAtIndex:2] intValue] withSpendingOrIncomeTag:[[arr objectAtIndex:indexPath.row] spendingOrIncomeTag] withFatherName:[[arr objectAtIndex:indexPath.row] fatherCategoryName] withChirdName:[[arr objectAtIndex:indexPath.row] chirdCategoryName] withMoney:[[arr objectAtIndex:indexPath.row] money] withRemark:[[arr objectAtIndex:indexPath.row] remark]];
    
    NSLog(@"dataInfo:%@",dataInfo);
    NSString *str ;
    if ([[arr objectAtIndex:indexPath.row] spendingOrIncomeTag] == -1) {
        str = [[NSString alloc] initWithFormat:@"%@  %d-%d-%d\t%@-%@\t%@元",@"支出:",[[timeArr objectAtIndex:0] intValue],[[timeArr objectAtIndex:1] intValue] ,[[timeArr objectAtIndex:2] intValue],[[arr objectAtIndex:indexPath.row] fatherCategoryName],[[arr objectAtIndex:indexPath.row] chirdCategoryName],[[arr objectAtIndex:indexPath.row] money]];
    }else
        str = [[NSString alloc] initWithFormat:@"%@  %d-%d-%d\t%@ %@\t%@元",@"收入:",[[timeArr objectAtIndex:0] intValue],[[timeArr objectAtIndex:1] intValue] ,[[timeArr objectAtIndex:2] intValue],@"  ",[[arr objectAtIndex:indexPath.row] chirdCategoryName],[[arr objectAtIndex:indexPath.row] money]];
   
    
    [DataInfoTool opendDB];
    [Tools showHUD:NSLocalizedString(@"saving", @"")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL isFlag = [DataInfoTool addData:dataInfo];
        [DataInfoTool closeDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            if(isFlag){
                [self.addDelegate reCreate];
                UIAlertView *saveAlter = [[UIAlertView alloc] initWithTitle:@"保存成功" message:str delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
//                [saveAlter setTag:SAVETAG];
                [saveAlter show];
            }
        });
    });
}

/*
#pragma mark - uialterview 的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//关闭按钮
        
    }else if(buttonIndex == 1){//再记一笔按钮
//        [_tableView]
    }
}
*/
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"删除";
//}


/**
 *cell 里的按钮事件
 */
-(void)edit:(UIButton *)btn{
    
//    int index = btn.tag;
//    NSLog(@"显示money：%@",[[arr objectAtIndex:index] money]);
    
    TemplateEdit *templateEdit = [[TemplateEdit alloc] init];
    [self.navigationController pushViewController:templateEdit animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
     [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TemplateTool opendDB];
        if (spendingOrIncomeTag == spendingTag) {
            _templateArr_spending = [TemplateTool getAllData:spendingOrIncomeTag];
            arr = _templateArr_spending ;
        }else{
            _templateArr_income = [TemplateTool getAllData:spendingOrIncomeTag];
            arr = _templateArr_income ;
        }
        [TemplateTool opendDB];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_tableView reloadData];
            [Tools removeHUD];
        });
        
    });
   
    NSLog(@"viewWillAppear");
}
@end
