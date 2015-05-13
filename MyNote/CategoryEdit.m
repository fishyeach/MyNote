//
//  CategoryEdit.m
//  MyNote
//
//  Created by xd_ on 15/5/7.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "CategoryEdit.h"
#import "CategoryCell.h"
#import "AnimationsTool.h"
#import "CategoryTool.h"
#import "Tools.h"

#define spendingTag -1
#define incomeTag 1

#define upBtnCancelTag 3
#define upBtnEnter 4

#define up 1
#define down -1

#define fatherTag 0
#define chirdTag 1

#define editTag 0
#define saveTag 1

@interface CategoryEdit (){
    UIBarButtonItem *closeBtn;
    UISegmentedControl *segmentSpendingOrIncome;
    UITextField *textField;
    int keyboardHeight;
    NSString *oldText;
    NSString *fatherText;
    int editOrSave;
    NSMutableArray *datas;
}

@end

@implementation CategoryEdit

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"_spendingOrIncome:%D",_spendingOrIncome);
    [self initTitle];
   
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    //键盘处理事件
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardHide:)];
    //设置成NO表示当前控件响应后会传播到其他控件上，默认为YES。
    tapGestureRecognizer.cancelsTouchesInView = NO;
    //将触摸事件添加到当前view
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

-(void)viewDidAppear:(BOOL)animated{
//    [_view setContentSize:CGSizeMake(Screen_width, _tableView.frame.size.height)];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)initTitle{
    if (_fatherOrChird == fatherTag) {
        datas = _fatherArr;
        closeBtn = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStylePlain target:self action:@selector(close:)];
        self.navigationItem.leftBarButtonItem = closeBtn;

        
        segmentSpendingOrIncome = [[UISegmentedControl alloc] initWithItems:nil];
        [segmentSpendingOrIncome insertSegmentWithTitle:@"支出" atIndex:0 animated:YES];
        [segmentSpendingOrIncome insertSegmentWithTitle:@"收入" atIndex:1 animated:YES];
        
        [segmentSpendingOrIncome setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:0];
        [segmentSpendingOrIncome setWidth:(Screen_width - 150) / 2 forSegmentAtIndex:1];
        
        [segmentSpendingOrIncome setTintColor:myRedColor];
        self.navigationItem.titleView = segmentSpendingOrIncome;
        
        [segmentSpendingOrIncome addTarget:self action:@selector(segmentSpendingOrIncomeAction:) forControlEvents:UIControlEventValueChanged];
        
        
        if (_spendingOrIncome == spendingTag) {
            segmentSpendingOrIncome.selectedSegmentIndex = 0;
        }else{
            segmentSpendingOrIncome.selectedSegmentIndex = 1;
        }
    }else{
        datas = _chirdArr;
    }
}

//分段控制器选择
-(void)segmentSpendingOrIncomeAction:(UISegmentedControl *)sender{
    
}

//关闭模态视图
-(void)close:(id)sender{
    [self.reloadDelegate reloadPicker];
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uitableview数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [datas count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cateforyCell";
    
    CategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        UINib *nib = [UINib nibWithNibName:@"CategoryCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:identifier];
        cell = [[nib instantiateWithOwner:nil options:nil] objectAtIndex:0];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.textField.text = [datas objectAtIndex:indexPath.row];
    [cell.textField setTag:indexPath.row];
    [cell.textField addTarget:self action:@selector(textFieldEditingDidBegin:) forControlEvents:UIControlEventEditingDidBegin];
    [cell.textField addTarget:self action:@selector(textFieldEditingDidEndOnExit:) forControlEvents:UIControlEventEditingDidEnd];
    
    [cell.rightBtn addTarget:self action:@selector(gotoChird:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
#pragma mark - uitableview 代理


//uitextfield的事件
-(void)textFieldEditingDidBegin:(UITextField *)sender{
    textField = sender;
    oldText = textField.text;
//    NSLog(@"textField.tag:%D",textField.tag);
//    [self addBtnForKeyboard:textField];
//    NSLog(@"textField.superview.superview.frame.origin.y:%f",textField.superview.superview.frame.origin.y);
//    NSLog(@"self.view.frame.size.height - keyboardHeight:%f",self.view.frame.size.height - keyboardHeight);
}

-(void)textFieldEditingDidEndOnExit:(UITextField *)sender{
    [self edit];
    NSLog(@"textFieldEditingDidEndOnExit-----:%D",textField.tag);
    
}

-(void)addBtnForKeyboard:(UITextField *)sender{
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"AddDateBtn" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, 40);
    chirdView.backgroundColor = [UIColor yellowColor];
    sender.inputAccessoryView = chirdView;
//    NSIndexPath *index = [_tableView indexPathForCell:(UITableViewCell *)sender.superview.superview];
    
    UIButton *cancelBtn = (UIButton *)[chirdView viewWithTag:upBtnCancelTag];
   
    UIButton *enterBtn = (UIButton *)[chirdView viewWithTag:upBtnEnter];
   
    [cancelBtn addTarget:self action:@selector(upCancel) forControlEvents:UIControlEventTouchUpInside];
    [enterBtn addTarget:self action:@selector(upEnter) forControlEvents:UIControlEventTouchUpInside];
}

//键盘上方的按钮
-(void)upCancel{
    NSLog(@"textField.tag:%D",textField.tag);
    [textField resignFirstResponder];
}
-(void)upEnter{
    
}

-(void)keyboardHide:(UITapGestureRecognizer*)tap{
    [self keyBoardHide];
}

-(void)keyBoardHide{
    [textField resignFirstResponder];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
     keyboardHeight = keyboardRect.size.height;
    [self change:up];//up
}

- (void)keyboardWillHide:(NSNotification *)aNotification
{
     [self change:down];
}

- (void)change:(int)upOrDown{
//    _tableView
    CGRect mFrame ;
    if (upOrDown == up) {
        if (textField.superview.superview.frame.origin.y > self.view.frame.size.height - keyboardHeight - 100) {
            mFrame = CGRectMake(0, 0 - ( keyboardHeight ), Screen_width, Screen_height);
            [AnimationsTool MoveView:self.view To:mFrame During:0.4f];
            
            CGRect mRect = CGRectMake(0, -self.navigationController.navigationBar.frame.size.height + 20, Screen_width, self.navigationController.navigationBar.frame.size.height);
            [AnimationsTool MoveView:self.navigationController.navigationBar To:mRect During:0.2f];
            
            [self.navigationItem.titleView setHidden:YES];
            self.navigationItem.leftBarButtonItem = nil;
            
        }
    }else{
        mFrame = CGRectMake(0, 0, Screen_width, Screen_height);
        [AnimationsTool MoveView:self.view To:mFrame During:0.2f];
        
        CGRect mRect = CGRectMake(0, self.navigationController.navigationBar.frame.size.height - 24, Screen_width, self.navigationController.navigationBar.frame.size.height);
        [AnimationsTool MoveView:self.navigationController.navigationBar To:mRect During:0.4f];
        self.view.frame = CGRectMake(0, 0, Screen_width, Screen_height);
        
        [self.navigationItem.titleView setHidden:NO];
        self.navigationItem.leftBarButtonItem = closeBtn;
    }
    
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

/**
 *新增
 */
-(void)add{
    
}

/**
 *编辑
 */
-(void)edit{
    BOOL canSave = YES;
    if (_spendingOrIncome == spendingTag) {
        if (_fatherOrChird == fatherTag) {
            for (NSString *str in _fatherArr) {
                if ([str isEqualToString:textField.text]) {
                    canSave = NO;
                }
            }
            [CategoryTool opendDB];
            [CategoryTool editCate:oldText withNew:textField.text];
            [CategoryTool closeDB];
        }else if(_fatherOrChird == chirdTag){
            for (NSString *str in _chirdArr) {
                if ([str isEqualToString:textField.text]) {
                   canSave = NO;
                }
            }
            [CategoryTool opendDB];
            [CategoryTool editCate:_oldFather withOldChird:oldText withNew:_oldFather withNewChird:textField.text];
            [CategoryTool closeDB];
        }
    }else if(_spendingOrIncome == incomeTag){
        for (NSString *str in _chirdArr) {
            if ([str isEqualToString:textField.text]) {
               canSave = NO;
            }
        }
        [CategoryTool opendDB];
        [CategoryTool editCate:@"" withOldChird:oldText withNew:@"" withNewChird:textField.text];
        [CategoryTool closeDB];

    }
    
}

-(void)gotoChird:(UIButton *)btn{
    
    CategoryCell *cell = (CategoryCell *)btn.superview.superview;
    fatherText = cell.textField.text;
    
    CategoryEdit *chird = [[CategoryEdit alloc] init];
    chird.spendingOrIncome = _spendingOrIncome;
    chird.fatherOrChird = chirdTag;
    
    [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [CategoryTool opendDB];
        chird.chirdArr = [CategoryTool getChirdCate:fatherText withFlag:spendingTag];
        [CategoryTool closeDB];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            chird.title = fatherText;
            [self.navigationController pushViewController:chird animated:YES];
        });
        
    });
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
