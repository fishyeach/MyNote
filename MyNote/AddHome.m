//
//  AddHome.m
//  MyNote
//
//  Created by xd_ on 15-4-3.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "AddHome.h"
#import "DatePickTool.h"
#import "CategoryTool.h"
#import "DataBaseTool.h"
#import "LocaInfoTool.h"
#import "AnimationsTool.h"
#import "Tools.h"
#import "DataInfoTool.h"
#import "TemplateTool.h"
#import "TotalTool.h"
#import "CategoryEdit.h"

#define fatherTag 0

#define template 1
#define actual 0

#define moneyTag 3
#define remarkTag 4

#define upBtnCancelTag 7
#define upBtnEnter 8

#define incomeFlag 1
#define spendingFlag -1

#define rightButtonAlterTag 40
#define saveButtonAlterTag 41

#define firstTag 2
#define onedayTag 3
#define onedayAddTag 4

@interface AddHome (){
    NSArray *nib;
    int flag;
    int spendingOrIncom;
    UIDatePicker *datePicker;
    UIPickerView *m_pickerView;
    
    NSMutableArray *categoryArr;
    NSMutableArray *categoryFather;
    NSArray *categortChird;
    
    //判断是哪个键盘
    int whichKeyBroad;
    //判断是哪个类别
    int whichCategory;
    NSString *fatherString ;
    NSString *chirdString ;
    
    UIButton *cateBtn;
}

@end

@implementation AddHome

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.title = _str;

    NSLog(@"flag----:%d",_flag);
     NSLog(@"_remarkStr----:%@",_remarkStr);
NSLog(@"_fatherString----:%@",_fatherStr);
    NSLog(@"_chirdString----:%@",_chirdStr);
    NSLog(@"_moneyStr----:%@",_moneyStr);
    NSLog(@"_id:%d",_ID);
    

    
    if (_witchTag == firstTag || _witchTag == onedayAddTag) {
        whichKeyBroad = remarkTag;
        whichCategory = spendingFlag;
        spendingOrIncom = spendingFlag;
    }else if(_flag == spendingFlag && _witchTag == onedayTag){
        whichCategory = spendingFlag;
        spendingOrIncom = spendingFlag;
    }else{
        whichCategory = incomeFlag;
        spendingOrIncom = incomeFlag;
    }
    
    [self initializeView];
    [self initDataView];
    
   
    //键盘处理事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
    
    //添加按钮
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"存为模板" style:UIBarButtonItemStylePlain target:self action:@selector(saveFortemplate)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
}

-(void)viewWillAppear:(BOOL)animated{
//     [self.scrollView setContentOffset:CGPointMake(0, 50) animated:YES];
    [self.canleBtn setBackgroundImage:[UIImage imageNamed:@"download"] forState:UIControlStateHighlighted];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self addBtn];
}

#pragma mark - 保存为模板
-(void)saveFortemplate{
  /*  NSArray *timeArr = [Tools getTimeArrFromDataPicker:self.dateLable.text];
    [DataInfoTool opendDB];
    
    NSMutableArray *arry = [DataInfoTool getDataInfoWithYear:[[timeArr objectAtIndex:0] intValue] withMonth:[[timeArr objectAtIndex:1] intValue] withDay:[[timeArr objectAtIndex:2] intValue] withSpendingOrIncome:spendingOrIncom withTime:1];
    
    [DataInfoTool closeDB];
    
    DataInfo *info = [arry objectAtIndex:[arry count] - 1];
    
    NSLog(@"数据:%d",[info ID]);
    NSLog(@"数据:%d",[info year]);
    NSLog(@"数据:%d",[info month]);
    NSLog(@"数据:%d",[info day]);
    NSLog(@"数据:%d",[info spendingOrIncomeTag]);
    NSLog(@"数据:%@",[info categoryFatherName]);
    NSLog(@"数据:%@",[info categoryChirdName]);
    NSLog(@"数据:%f",[info money]);*/
   
    if ([self isCanSave]) {
        TemplateInfo *info = [[TemplateInfo alloc] init];
        NSArray *cateArr = [Tools getCategoryArr:self.cateNameLabel.text];
        [info setInfo:spendingOrIncom withFathercategory:[cateArr objectAtIndex:0] withChirdCategor:[cateArr objectAtIndex:1] withMoney:self.moneyLabel.text withRemark:self.remarkTextView.text];
        [TemplateTool opendDB];
        if (_witchTag == onedayTag) {
            [TemplateTool addData:info];
        }else{
            TemplateInfo *oldInfo = [[TemplateInfo alloc] init];
            [oldInfo setInfo:_flag withFathercategory:_fatherStr withChirdCategor:_chirdStr withMoney:_moneyStr withRemark:_remarkStr];
            [TemplateTool updataData:oldInfo withNewData:info];
        }
        
        [TemplateTool closeDB];
         [self.addDelegate reCreate];
        UIAlertView *rightButtonAlter;
        if (_flag == 0) {
            rightButtonAlter  = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"再记一笔", nil];
        }else{
            rightButtonAlter  = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        }
       
        [rightButtonAlter setTag:rightButtonAlterTag];
        [rightButtonAlter show];
    }
    
}

//初始化view
-(void)initializeView{
//    self.spendingRadio.text = @"√";
    [DatePickTool setViewBroder:self.spendingRadio];
    [DatePickTool setViewBroder:self.incomeRadio];
    [DatePickTool setViewBroder:self.remarkTextView];
//    [DatePickTool setViewBroder:self.moneyLabel];
//    [DatePickTool setViewBroder:self.cateNameLabel];
//    [DatePickTool setViewBroder:self.dateLable];
    
}

-(void)initDataView{
    self.cateNameLabel.text = @"请选择类别";
    self.moneyLabel.text = @"";
    
    _dateLable.text = [Tools getNowTime];
    if (_witchTag == firstTag) {
        
        self.incomeRadio.text = @"";
        self.spendingRadio.text = @"√";
//        NSLog(@"actualSpendingAction");
        whichCategory = spendingFlag;
        spendingOrIncom = spendingFlag;
        
        
    }else if(_witchTag == onedayAddTag){
        
        self.incomeRadio.text = @"";
        self.spendingRadio.text = @"√";
//        NSLog(@"actualSpendingAction");
        whichCategory = spendingFlag;
        spendingOrIncom = spendingFlag;
        
        _dateLable.text = _timeStr;
    }else{
        if (_flag == spendingFlag) {
            self.incomeRadio.text = @"";
            self.spendingRadio.text = @"√";
            whichCategory = spendingFlag;
            spendingOrIncom = spendingFlag;
            _cateNameLabel.text = [NSString stringWithFormat:@"%@-%@",_fatherStr,_chirdStr];
            if (_fatherStr == nil) {
                _cateNameLabel.text = @"请选择类别";
            }

        }else{
            self.incomeRadio.text = @"√";
            self.spendingRadio.text = @"";
            whichCategory = incomeFlag;
            spendingOrIncom = incomeFlag;
            _cateNameLabel.text = [NSString stringWithFormat:@"%@%@",_fatherStr,_chirdStr];
        }
        _dateLable.text = _timeStr;
        _moneyLabel.text = _moneyStr;
        _remarkTextView.text = _remarkStr;
    }
   
}

/*
//分段控制器来旋转实际的或者模板的
-(void)setContentView{
    
    switch (self.mSegment.selectedSegmentIndex) {
        case 0:
            spendingOrIncom = actual;
            break;
        default:
            spendingOrIncom = template;
            break;
    }
    
}
*/

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 处理键盘事件

//给键盘添加按钮
-(void)addBtn{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddDateBtn" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, 40);
    chirdView.backgroundColor = [UIColor yellowColor];
    self.moneyLabel.inputAccessoryView = chirdView;
    self.remarkTextView.inputAccessoryView = chirdView;
    
    UIButton *cancelBtn = (UIButton *)[chirdView viewWithTag:upBtnCancelTag];
    UIButton *enterBtn = (UIButton *)[chirdView viewWithTag:upBtnEnter];
    
    [cancelBtn addTarget:self action:@selector(upCancel) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn addTarget:self action:@selector(upEnter) forControlEvents:UIControlEventTouchUpInside];
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self keyBoardHide];
}

-(void)keyBoardHide{
    [self.moneyLabel resignFirstResponder];
    [self.remarkTextView resignFirstResponder];
}

#pragma mark - textfield事件
- (IBAction)moneyBeginEdit:(id)sender {
    whichKeyBroad = moneyTag;
}

- (IBAction)moneyEndEdit:(id)sender {
    whichKeyBroad = remarkTag;
}
- (IBAction)textFieldChanged:(UITextField *)sender {
    sender.text = [Tools textFiledEdit:sender.text];
}

//键盘上弹
- (void)change{

    if (whichKeyBroad == moneyTag) {
         CGRect mRect = CGRectMake(0, -160, Screen_width, Screen_height);
        [AnimationsTool MoveView:self.view To:mRect During:0.2f];
        
    }else{
         CGRect mRect = CGRectMake(0, -220, Screen_width, Screen_height);
        [AnimationsTool MoveView:self.view To:mRect During:0.2f];
    }
    
    CGRect mRect = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height, Screen_width, self.navigationController.navigationBar.frame.size.height);
    [AnimationsTool MoveView:self.navigationController.navigationBar To:mRect During:0.2f];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    [self change];
//    [self.navigationController.navigationBar setHidden:YES];
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
//    [self.navigationController.navigationBar setHidden:NO];
    CGRect mRect = CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 24, Screen_width, self.navigationController.navigationBar.frame.size.height);
    [AnimationsTool MoveView:self.navigationController.navigationBar To:mRect During:0.4f];
    self.view.frame = CGRectMake(0, 0, Screen_width, Screen_height);

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma  mark - 按钮事件

- (IBAction)SpendingAction:(UIButton *)sender{
    self.incomeRadio.text = @"";
    self.spendingRadio.text = @"√";
    NSLog(@"actualSpendingAction");
    whichCategory = spendingFlag;
    spendingOrIncom = spendingFlag;
    self.cateNameLabel.text = @"请选择类别";
}
- (IBAction)IncomeAction:(UIButton *)sender{
    self.incomeRadio.text = @"√";
    self.spendingRadio.text = @"";
    NSLog(@"actualIncomeAction");
    whichCategory = incomeFlag;
    spendingOrIncom = incomeFlag;
     self.cateNameLabel.text = @"请选择类别";
}

//选择日期
- (IBAction)selectData:(id)sender {
    if (0 == [DatePickTool getFlag]) {
/*        [Tool showDatePicker:self.view withFlag:^(UIDatePicker *pick) {
            datePicker = pick;
            datePicker.datePickerMode = UIDatePickerModeDateAndTime;
            [datePicker addTarget:self action:@selector(datePick:) forControlEvents:UIControlEventValueChanged];
        }];*/
        
        [DatePickTool showDatePicker:self.view withFlag:^(NSString *timeOfPick){
            self.dateLable.text = timeOfPick;
        }];
 
    }
}

//选择类别
- (IBAction)selectCategory:(id)sender {
    [self opendCate];
}

//取消
- (IBAction)canleAction:(id)sender {
    if (_flag == 0) {
         [self dismissViewControllerAnimated:YES completion:nil];
    }else
         [self.navigationController popToRootViewControllerAnimated:YES];
    
}

//保存
- (IBAction)enterAction:(id)sender {
    [self save];
}

//键盘上方的按钮
-(void)upCancel{
    [self keyBoardHide];
}

-(void)upEnter{
    [self save];
}

//编辑类别
-(void)editCateBtn:(id)btn{
    CategoryEdit *categoryEdit = [[CategoryEdit alloc] init];
    categoryEdit.spendingOrIncome = spendingOrIncom;
    categoryEdit.fatherOrChird = 0;
    
    [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CategoryTool opendDB];
        if (spendingOrIncom == spendingFlag) {
            categoryEdit.fatherArr = [CategoryTool getFatherCate:spendingFlag];
        }else
            categoryEdit.fatherArr = [CategoryTool getChirdCate:@"" withFlag:incomeFlag];
        
        [CategoryTool closeDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            
        });
        
    });
    categoryEdit.reloadDelegate = self;
    UINavigationController *NV = [[UINavigationController alloc] initWithRootViewController:categoryEdit];
    [self presentViewController:NV animated:YES completion:nil];
}

//保存数据的方法
-(void)save{
    if ([self isCanSave]) {
        _dataInfo = [[DataInfo alloc] init];
        NSArray *timeArr ;
         if (_witchTag == firstTag) {
            timeArr = [Tools getTimeArrFromDataPicker:self.dateLable.text];
         }
        NSArray *cateArr = [Tools getCategoryArr:self.cateNameLabel.text];
        
        NSLog(@"cateArr:%@",cateArr);
        
        if (_witchTag == firstTag) {
             [_dataInfo setData:[[timeArr objectAtIndex:0] intValue] withMonth:[[timeArr objectAtIndex:1] intValue] withDay:[[timeArr objectAtIndex:2] intValue]withSpendingOrIncomeTag:spendingOrIncom withFatherName:[cateArr objectAtIndex:0] withChirdName:[cateArr objectAtIndex:1] withMoney:self.moneyLabel.text withRemark:self.remarkTextView.text];
        }else if(_witchTag == onedayAddTag)
            [_dataInfo setData:_yearOneday withMonth:_monthOneday withDay:_dayOneday withSpendingOrIncomeTag:spendingOrIncom withFatherName:[cateArr objectAtIndex:0] withChirdName:[cateArr objectAtIndex:1] withMoney:_moneyLabel.text withRemark:_remarkTextView.text];
       
        [DataInfoTool opendDB];
        if (_witchTag == firstTag || _witchTag == onedayAddTag) {
            [DataInfoTool addData:_dataInfo];
        }else{
            [DataInfoTool updataDataInfo:_ID withMoney:_moneyStr withDataInfo:_dataInfo];
        }
        
        
        [DataInfoTool closeDB];
        [self.addDelegate reCreate];
        UIAlertView *saveAlter;
        if (_flag == 0) {
            saveAlter   = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"再记一笔",nil];
        }else{
            saveAlter = [[UIAlertView alloc] initWithTitle:@"保存成功" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil,nil];
        }
        
        [saveAlter setTag:saveButtonAlterTag];
        [saveAlter show];
        //        [self initDataView];
    }
}

#pragma mark - UIPickView 代理

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (whichCategory == spendingFlag) {
        return 2;
    }else{
        return 1;
    }
    
}
//打开类别选择器
-(void)opendCate{
    [CategoryTool opendDB];
    [CategoryTool showCategory:self.view withFlag:whichKeyBroad withWichFalg:0 withCallBack:^(UIButton *btn1,UIButton *btn2,UIButton *btn3,UIPickerView *MpickerView){
        
        cateBtn = btn3;
        [btn3 addTarget:self action:@selector(editCateBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        m_pickerView = MpickerView;
        m_pickerView.dataSource = self;
        m_pickerView.delegate = self;
        
        categoryArr = [CategoryTool getCategoryFromDB:whichCategory];
        
        if (whichCategory == spendingFlag) {
            categoryFather = [NSMutableArray array];
            categortChird = [NSMutableArray array];
            for (id dic in categoryArr) {
                [categoryFather addObject:[[dic allKeys] objectAtIndex:0]];
                
            }
            
            [CategoryTool closeDB];
            
            [m_pickerView selectRow:4 inComponent:0 animated:YES];
            categortChird = [[[categoryArr objectAtIndex:4] allValues]objectAtIndex:0];
            fatherString = [categoryFather objectAtIndex:4];
            self.cateNameLabel.text = [[NSString alloc] initWithFormat:@"%@-%@",[categoryFather objectAtIndex:4],[[[[categoryArr objectAtIndex:4] allValues]objectAtIndex:0] objectAtIndex:0]];
        }else{
            [m_pickerView selectRow:0 inComponent:0 animated:YES];
            self.cateNameLabel.text = [categoryArr objectAtIndex:0];
        }
        
        
    }];

}
// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (whichCategory == spendingFlag) {
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
    if (whichCategory == spendingFlag) {
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
    if (whichCategory == spendingFlag) {

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
    
    self.cateNameLabel.text = cateString;
    
}

#pragma mark - 逻辑判断：是否满足保存要求
-(BOOL)isCanSave{
    if ([self.cateNameLabel.text isEqual:@"请选择类别"]) {
        NSLog(@"类别不能为空");
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"类别不能为空" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alter show];
        
        return NO;
    }else if([self.moneyLabel.text isEqual:@""] || [self.moneyLabel.text isEqual:@"0"]){
        NSLog(@"Money不能为空或者0");
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"金额不能为空或者0" message:nil delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alter show];
        
        return NO;
    }else{
        
        return YES;
    }
    
    
}

#pragma mark - uialterview 的代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {//关闭按钮
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }else if(buttonIndex == 1){//再记一笔按钮
        [self initDataView];
    }
}

-(void)reloadPicker{
    [cateBtn.superview.superview removeFromSuperview];
    [self opendCate];
}
@end
