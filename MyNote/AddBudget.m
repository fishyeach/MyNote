//
//  AddBudget.m
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "AddBudget.h"
#import "CategoryTool.h"
#import "Tools.h"
#import "BudgetTool.h"
#import "BudgetInfo.h"

#define remarkTag 4
#define spendingFlag -1

#define upBtnCancelTag 7
#define upBtnEnter 8


@interface AddBudget (){
    UIPickerView *m_pickerView;
    NSMutableArray *categoryArr;
    NSMutableArray *categoryFather;
    NSArray *categortChird;
    NSString *fatherString ;
    NSString *chirdString ;
    
    int dayTotal;

}

@end

@implementation AddBudget

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _moneyLabel.delegate = self;
    dayTotal = 1;
    _categoryLabel.text = @"请选择类别";
    [self initTextFieldUpBtn];
    
    //键盘处理事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self keyBoardHide];
}

-(void)keyBoardHide{
    [self.moneyLabel resignFirstResponder];
    [self.dayCount resignFirstResponder];
}

/**
 *给键盘点击按钮
 */
-(void)initTextFieldUpBtn{
    [Tools addBtnForKeyBoard:_moneyLabel withCallback:^(int tag){
        if (tag == upBtnEnter) {
            [self saveAction];
        }else{
            [self canleBtnAction];
        }
    }];
    
    [Tools addBtnForKeyBoard:_dayCount withCallback:^(int tag){
        if (tag == upBtnEnter) {
            [self saveAction];
        }else{
            [self canleBtnAction];
        }
    }];
}

#pragma mark - 键盘上方按钮事件
//取消事件
-(void)canleBtnAction{
    [self keyBoardHide];
}

-(void)saveAction{
    [self keyBoardHide];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCategory:(UIButton *)sender {
    [CategoryTool opendDB];
    [CategoryTool showCategory:self.view withFlag:remarkTag withWichFalg:0 withCallBack:^(UIButton *btn1,UIButton *btn2,UIButton *btn3,UIPickerView *MpickerView){
        
        m_pickerView = MpickerView;
        m_pickerView.dataSource = self;
        m_pickerView.delegate = self;
        
        categoryArr = [CategoryTool getCategoryFromDB:spendingFlag];
        
       
            categoryFather = [NSMutableArray array];
            categortChird = [NSMutableArray array];
            for (id dic in categoryArr) {
                [categoryFather addObject:[[dic allKeys] objectAtIndex:0]];
                
            }
            
            [CategoryTool closeDB];
            
            [m_pickerView selectRow:4 inComponent:0 animated:YES];
            categortChird = [[[categoryArr objectAtIndex:4] allValues]objectAtIndex:0];
            fatherString = [categoryFather objectAtIndex:4];
            self.categoryLabel.text = [[NSString alloc] initWithFormat:@"%@-%@",[categoryFather objectAtIndex:4],[[[[categoryArr objectAtIndex:4] allValues]objectAtIndex:0] objectAtIndex:0]];
            
        
    }];
}

- (IBAction)dayLabelValueChange:(UITextField *)sender {
    NSMutableString *str = [NSMutableString stringWithString:_dayCount.text];
    
    NSUInteger lengthOfString = _dayCount.text.length;
    for (NSInteger loopIndex = 0; loopIndex < lengthOfString; loopIndex++) {//只允许数字输入
        unichar character = [_dayCount.text characterAtIndex:loopIndex];
        
        if (character < 48)
            [str deleteCharactersInRange:NSMakeRange(loopIndex, 1)];
        if (character > 57)
            [str deleteCharactersInRange:NSMakeRange(loopIndex, 1)]; // 57 unichar for 9
    }
    
    _dayCount.text = str;
    dayTotal = [_dayCount.text intValue];
}

- (IBAction)enterAction:(UIButton *)sender {
    if ([self checkCanSave]) {
        BudgetInfo *info = [[BudgetInfo alloc] init];
        
        [info setYear:_year];
        [info setMonth:_month];
        [info setFartherCategory:[[_categoryLabel.text componentsSeparatedByString:@"-"] objectAtIndex:0]];
        [info setChirdCategory:[[_categoryLabel.text componentsSeparatedByString:@"-"] objectAtIndex:1]];
        double money = [_moneyLabel.text doubleValue] * dayTotal;
        [info setMoney:[Tools stringDisposeWithFloat:money]];
        
        [BudgetTool opendDB];
        [BudgetTool addData:info];
        [BudgetTool closeDB];
    }
   
}

//检测是否符合保存要求
-(BOOL)checkCanSave{
    BOOL canSave = YES;
    
    NSString *tipStr = [NSString stringWithFormat:@"类别:%@\t金额:%0.2f",_categoryLabel.text,[_moneyLabel.text doubleValue] * dayTotal];
    NSString *tipTitle = @"保存成功";
    
    if ([_moneyLabel.text isEqualToString:@""] || [_moneyLabel.text isEqualToString:@"0"]) {
        tipStr = @"金额不能为空或者0";
        tipTitle = @"保存失败";
        canSave = NO;
    }
    if ([_categoryLabel.text isEqualToString:@"请选择类别"]) {
        tipStr = @"类别不能为空";
         tipTitle = @"保存失败";
        canSave = NO;
    }
    
    UIAlertView *alter = [[UIAlertView alloc] initWithTitle:tipTitle message:tipStr delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alter show];
    
    return canSave;
}


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 2;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
        if (component == 0) {
            return [categoryFather count];
        } else {
            return [categortChird count];
        }
   
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
        if (component == 0) {
            return [categoryFather objectAtIndex:row];
        } else {
            return [categortChird objectAtIndex:row];
        }
    
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *cateString ;
    
        //        NSLog(@"chirdString:%@",chirdString);
        if (component == 0) {
            //        NSString *seletedProvince = [categoryFather objectAtIndex:row];
            categortChird = [[[categoryArr objectAtIndex:row] allValues]objectAtIndex:0];
            //重点！更新第二个轮子的数据
            [m_pickerView reloadComponent:1];
            fatherString = [categoryFather objectAtIndex:row];
            chirdString =  [categortChird objectAtIndex:0];
            cateString = [[NSString alloc] initWithFormat:@"%@-%@",fatherString,chirdString];
            
        }else{
            chirdString =  [categortChird objectAtIndex:row];
            cateString = [[NSString alloc] initWithFormat:@"%@-%@",fatherString,chirdString];
        }
    self.categoryLabel.text = cateString;
    
    if ([cateString rangeOfString:@"饮食"].location == NSNotFound) {
        [_dayCountView setHidden:YES];
    }else
        [_dayCountView setHidden:NO];
    
}
- (IBAction)textFieldChanged:(UITextField *)sender {
    sender.text = [Tools textFiledEdit:sender.text];
}

@end
