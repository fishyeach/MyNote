//
//  TemplateEdit.m
//  MyNote
//
//  Created by xd_ on 15-4-22.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "TemplateEdit.h"
#import "CategoryTool.h"
#import "AnimationsTool.h"
#import "TemplateInfo.h"
#import "TemplateTool.h"
#import "Tools.h"

#define moneyTag 3

#define incomeFlag 1
#define spendingFlag -1

#define upBtnCancelTag 7
#define upBtnEnter 8

@interface TemplateEdit (){
    UIPickerView *m_pickerView;
    NSMutableArray *categoryArr;
    NSMutableArray *categoryFather;
    NSArray *categortChird;
    NSString *fatherString ;
    NSString *chirdString ;
    UISegmentedControl *titleSegment;

}

@end

@implementation TemplateEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initSegment];
    _speingdOrIncome = spendingFlag;
    _categoryLabel.text = @"请选择类别";
}

-(void)initSegment{
    titleSegment = [[UISegmentedControl alloc] initWithItems:nil];
    [titleSegment insertSegmentWithTitle:@"支出模板" atIndex:0 animated:nil];
    [titleSegment insertSegmentWithTitle:@"收入模板" atIndex:1 animated:nil];
    
    titleSegment.selectedSegmentIndex = 0;
    [titleSegment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:0];
    [titleSegment setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:1];
    
    [titleSegment setTintColor:[UIColor colorWithRed:190.0f/255.0 green:41.0f/255.0f blue:0.0f/255.0f alpha:1]];
    self.navigationItem.titleView = titleSegment;
    
    [titleSegment addTarget:self action:@selector(controlPressed:) forControlEvents:UIControlEventValueChanged];
    
}

-(void)controlPressed:(UISegmentedControl *)segment{
    NSInteger index = [titleSegment selectedSegmentIndex];
    if (index == 0) {
        _speingdOrIncome = spendingFlag;
        _categoryLabel.text = @"请选择类别";

    }else{
        _speingdOrIncome = incomeFlag;
        _categoryLabel.text = @"请选择类别";

    }
    
}

-(void)viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    //键盘处理事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    [self addBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)selectCategory:(UIButton *)sender {
    [CategoryTool opendDB];
    [CategoryTool showCategory:self.view withFlag:moneyTag withWichFalg:0 withCallBack:^(UIButton *btn1,UIButton *btn2,UIButton *btn3,UIPickerView *MpickerView){
        
        m_pickerView = MpickerView;
        m_pickerView.dataSource = self;
        m_pickerView.delegate = self;
        
        categoryArr = [CategoryTool getCategoryFromDB:_speingdOrIncome];
        
        if (_speingdOrIncome == spendingFlag) {
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
        }else{
            [m_pickerView selectRow:0 inComponent:0 animated:YES];
            self.categoryLabel.text = [categoryArr objectAtIndex:0];
        }
        
        
    }];

    
}
- (IBAction)editingChanged:(UITextField *)sender {
   _moeyTextField.text = [Tools textFiledEdit:sender.text];
}

- (IBAction)saveBtnAction:(UIButton *)sender {
    
    TemplateInfo *templateInfo = [[TemplateInfo alloc] init];
    NSArray *cateArr = [Tools getCategoryArr:_categoryLabel.text];
    [templateInfo setInfo:_speingdOrIncome withFathercategory:[cateArr objectAtIndex:0] withChirdCategor:[cateArr objectAtIndex:1] withMoney:_moeyTextField.text withRemark:@""];
    
    BOOL canSave = YES;
    NSString *tipTitle = @"保存成功";
    NSString *tipStr = [NSString stringWithFormat:@"类别:%@\t金额%@",_categoryLabel.text,_moeyTextField.text];
    if ([_categoryLabel.text isEqualToString:@"请选择类别"]) {
        tipTitle = @"保存失败";
        tipStr = @"类别不能为空";
        canSave = NO;
    }
    if ([_moeyTextField.text isEqualToString:@""] ||[_moeyTextField.text isEqualToString:@"0"]) {
        tipTitle = @"保存失败";
        tipStr = @"金额不能为空或者0";
        canSave = NO;
    }
    [TemplateTool opendDB];
    NSArray *arr = [TemplateTool getAllData:_speingdOrIncome];
    [TemplateTool closeDB];
   
    for (TemplateInfo *info in arr){
        if ([[info fatherCategoryName] isEqualToString:[templateInfo fatherCategoryName]] && [[info chirdCategoryName] isEqualToString:[templateInfo chirdCategoryName]] && [[info money] isEqualToString:[templateInfo money]]) {
            tipTitle = @"保存失败";
            tipStr = @"该模板已存在";
            canSave = NO;
        }
    }
    if (canSave) {
        
        [TemplateTool opendDB];
        [TemplateTool addData:templateInfo];
        [TemplateTool closeDB];
    }
    
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:tipTitle message:tipStr delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
    [alter show];
    _categoryLabel.text = @"请选择类别";
    _moeyTextField.text = @"0";
    
}

#pragma mark - UIPickView 代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_speingdOrIncome == spendingFlag) {
        return 2;
    }else{
        return 1;
    }
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_speingdOrIncome == spendingFlag) {
        if (component == 0) {
            return [categoryFather count];
        } else {
            return [categortChird count];
        }
    }else{
        return [categoryArr count];
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_speingdOrIncome == spendingFlag) {
        if (component == 0) {
            return [categoryFather objectAtIndex:row];
        } else {
            return [categortChird objectAtIndex:row];
        }
    }else{
        return [categoryArr objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSString *cateString ;
    if (_speingdOrIncome == spendingFlag) {
        
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
        
    }else{
        chirdString = [[NSString alloc] initWithFormat:@"%@",[categoryArr objectAtIndex:row]];
        cateString = [[NSString alloc] initWithFormat:@"%@",[categoryArr objectAtIndex:row]];
        NSLog(@"类别:%@",cateString);
    }
    
    self.categoryLabel.text = cateString;
    
}

-(void)addBtn{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddDateBtn" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, 30);
    self.moeyTextField.inputAccessoryView = chirdView;
    
    UIButton *cancelBtn = (UIButton *)[chirdView viewWithTag:upBtnCancelTag];
    UIButton *enterBtn = (UIButton *)[chirdView viewWithTag:upBtnEnter];
    
    [cancelBtn addTarget:self action:@selector(upCancel) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn addTarget:self action:@selector(upEnter) forControlEvents:UIControlEventTouchUpInside];
}

//键盘上方的按钮
-(void)upCancel{
    [self keyBoardHide];
}
-(void)upEnter{
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self keyBoardHide];
}

-(void)keyBoardHide{
    [self.moeyTextField resignFirstResponder];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
 self.view.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{

}


@end
