//
//  FirstViewController.m
//  MyNote
//
//  Created by xd_ on 15-4-2.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "FirstViewController.h"
#import "Template.h"
#import "Tools.h"
#import "TemplateInfo.h"
#import "TemplateTool.h"
#import "DataInfoTool.h"
#import "AddHome.h"
#import "FirstColectionViewCell.h"
#import "FirstCollectionViewHeard.h"
#import "EmptyCell.h"
#import "Budget.h"
#import "DataInfo.h"
#import "BudgetTool.h"
#import "OneDayData.h"


#define spendingTag -1
#define incomdeTag 1

//用于区分获取的是本日还是本月信息
#define dayFlag 0
#define monthFlag 1

#define cellMarig 2;

#define firstTag 2

@interface FirstViewController (){
    NSMutableArray *templateArr_spending;
    NSMutableArray *templateArr_income;
    AddHome *addHome;
    CGFloat width ;
    
    int monthDays;
    int headDays;//不算本月的第一周的天数
    int thisMonthDays;//本月的天数
    int today;
    
    int year;
    int month;
    
    NSArray *monthSpendingList;
    NSArray *monthIncomeList;
//    NSString *monthSpendingTotal;
//    NSString *monthIncomeTotal;
    NSString *budgetTotal;//预算金额
    NSString *canUseBudget;//预算余额
    NSString *canUseActual;//月结余
    NSString *spendingMonth;
    NSString *incomeMonth;

    IBOutlet UILabel *todayLabel;
}

@end

@implementation FirstViewController

static NSString *identifer = @"FirstCell";
static NSString *identifer2 = @"EmptyCollectionCell";

- (void)viewDidLoad {
    [super viewDidLoad];
        // Do any additional setup after loading the view, typically from a nib.
    [self initCalendarData];
    [self initDataInfo];
    [self initBudget];
    [self initAllView];
    [self initDateView];
    
    self.view.backgroundColor = myYellowColor;

}

-(void)viewDidAppear:(BOOL)animated{
    [_scrollView setContentSize:CGSizeMake(Screen_width, 300 + 30 + _collectionView.frame.size.height + 40)];
}

-(void)initCalendarData{
    NSArray *yearMonthDay = [Tools getTimeArrFromDataPicker:[Tools getNowTime]];
    today = [[yearMonthDay objectAtIndex:2] intValue];
    year = [[yearMonthDay objectAtIndex:0] intValue];
    month = [[yearMonthDay objectAtIndex:1] intValue];
    thisMonthDays = [Tools getDaysOfMonth:year withMonth:month];
    headDays = [Tools getWeekOfFirstDayOfMonth];
    monthDays = headDays + thisMonthDays;
    
    todayLabel.text = [NSString stringWithFormat:@"%D/%D",year,month];
}

/**
 *给页面赋值
 */
-(void)initAllView{
    
    _spendingLabel.text = spendingMonth;
    _incomeLabel.text = incomeMonth;
    _BudgetBalance.text = canUseBudget;
    _monthBudgetLabel.text = budgetTotal;
    _monthBalance.text = canUseActual;
}

-(void)initBudget{
    [BudgetTool opendDB];
    budgetTotal = [Tools stringDisposeWithFloat:[BudgetTool getMoney:year withMonth:month]];
    canUseBudget = [Tools stringDisposeWithFloat:[BudgetTool getMoney:year withMonth:month] - [_spendingLabel.text doubleValue]];
    [BudgetTool closeDB];
}

-(void)initDataInfo{

    spendingMonth = [self getMoney:monthFlag withTag:spendingTag];
    incomeMonth = [self getMoney:monthFlag withTag:incomdeTag];
    canUseActual = [Tools stringDisposeWithFloat:[[self getMoney:monthFlag withTag:incomdeTag] doubleValue] - [[self getMoney:monthFlag withTag:spendingTag] doubleValue]];
}

-(void)initDateView{
//    addHome.addDelegate = self;
   
    
    // 初始化layout
    UICollectionViewFlowLayout * flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    width = floorf((Screen_width - 20 - (2 * 8) )/ 7);
    
    if (monthDays <= 35) {
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 230, Screen_width - 20, (2 * 5) + (width * 5) + 30 ) collectionViewLayout:flowLayout];
    }else{
         _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 230, Screen_width - 20, (2 * 5) + (width * 6) + 30 ) collectionViewLayout:flowLayout];
    }
   
    //    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 22, Screen_width - 20, 300)];
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FirstColectionViewCell" bundle:nil] forCellWithReuseIdentifier:identifer];
    [_collectionView registerNib:[UINib nibWithNibName:@"EmptyCell" bundle:nil] forCellWithReuseIdentifier:identifer2];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    flowLayout.headerReferenceSize = CGSizeMake(self.collectionView.bounds.size.width, 30);
    // other setup
    [self.collectionView setCollectionViewLayout:flowLayout];
    [_collectionView registerNib:[UINib nibWithNibName:@"FirstCollectionViewHeard" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FirstHeard"];
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"HomeTip" owner:nil options:nil];
    UIView *tip = [views objectAtIndex:0];
    tip.frame = CGRectMake(0, _collectionView.frame.size.height + _collectionView.frame.origin.y + 10, Screen_width, 30);
    [self.view addSubview:tip];
    
}

/**
 *获取金额
 *flag:区分本日还是本月信息
 *tag:区分收入支出
 */
-(NSString *)getMoney:(int)flag withTag:(int)tag{
    double money;
    NSArray *timeArr = [Tools getTimeArrFromDataPicker:[Tools getNowTime]];
    
    [DataInfoTool opendDB];
    
    if (flag == dayFlag) {
        money = [DataInfoTool getMoneyWithYear:year withMonth:month withDay:[[timeArr objectAtIndex:2] intValue] withSpendingOrIncome:tag];
    }else
        money = [DataInfoTool getMoneyWithYear:year withMonth:month withSpendingOrIncome:tag];
    
    [DataInfoTool closeDB];
    
    return [Tools stringDisposeWithFloat:money];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)gotoTemplate:(UIButton *)sender {
    [self gotoTemplateStart:^{
        Template *template = [[Template alloc] init];
        template.templateArr_spending = templateArr_spending;
        template.templateArr_income = templateArr_income;
        NSLog(@"templateArr:%@",templateArr_spending);
        UINavigationController *templateNa = [[UINavigationController alloc] initWithRootViewController:template];
        template.addDelegate = self;
        [self presentViewController:templateNa animated:YES completion:nil];
    }];
}

-(void)gotoTemplateStart:(void(^)())callback{
    [Tools showHUD:NSLocalizedString(@"Loading", @"")];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TemplateTool opendDB];
        templateArr_spending = [TemplateTool getAllData:spendingTag];
        templateArr_income = [TemplateTool getAllData:incomdeTag];
        [TemplateTool closeDB];
        
        NSLog(@"数据----------:%@",templateArr_spending);
        dispatch_async(dispatch_get_main_queue(), ^{
            [Tools removeHUD];
            callback();
        });
        
    });
}

#pragma mark - 自定义的代理
-(void)reCreate{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self initCalendarData];
        [self initDataInfo];
        [self initBudget];
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView removeFromSuperview];
            _collectionView = nil;
            
            [self initAllView];
            [self initDateView];
            
        });
        
    });
}

//预算代理
-(void)recreatFromBudget{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self initBudget];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initAllView];
        });
        
    });
    
}

-(void)reCreateFromOneDay{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //        [self initCalendarData];
        [self initDataInfo];
        [self initBudget];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView removeFromSuperview];
            _collectionView = nil;
            
            [self initAllView];
            [self initDateView];
            
        });
        
    });

}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"gotoAddHome"])
    {
        
        UINavigationController *nav = [segue destinationViewController];
        addHome =  [[nav childViewControllers] objectAtIndex:0];
        addHome.addDelegate = self;
        addHome.witchTag = firstTag;
    }
}

#pragma mark - uicollectionview 数据源
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return monthDays;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    FirstColectionViewCell *cell;
    if (indexPath.row < headDays) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer2 forIndexPath:indexPath];
    }else{
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifer forIndexPath:indexPath];
        cell.dayLabel.text = [[NSString alloc] initWithFormat:@"%d",indexPath.row - headDays + 1];
        
        if (today == indexPath.row - headDays + 1) {
            cell.backgroundColor = [UIColor colorWithWhite:20 alpha:0.4];
            NSLog(@"year------%d",year);
            NSLog(@"month------%d",month);
            NSLog(@"today------%d",today);
        }
        
        [DataInfoTool opendDB];
        double spendingMoney = [DataInfoTool getMoneyWithYear:year withMonth:month withDay:(int)indexPath.row - headDays + 1 withSpendingOrIncome:spendingTag];
        double incomeMoney = [DataInfoTool getMoneyWithYear:year withMonth:month withDay:(int)indexPath.row - headDays + 1 withSpendingOrIncome:incomdeTag];
        NSString *spendingDay = [Tools stringDisposeWithFloat:spendingMoney];
        NSString *incomeDay = [Tools stringDisposeWithFloat:incomeMoney];
        [DataInfoTool closeDB];
        if (spendingMoney != 0 ) {
            cell.spendingLabel.text = spendingDay;
        }
        if (incomeMoney != 0) {
             cell.incomeLabel.text = incomeDay;
        }
        NSInteger len = spendingDay.length > incomeDay.length ? spendingDay.length : incomeDay.length;
         NSInteger fontSize = 13;
        if(is4Inch){
            if (len <= 5)
                fontSize = 11;
            else
                fontSize = 11 - (len - 5);
            
        }else if(is3_5Inch){
            if (len <= 5)
                fontSize = 11;
            else
                fontSize = 11 - (len - 7);
        }else{
            if (len <= 6)
                fontSize = 12;
            else
                fontSize = 12 - (len - 5);
        }
        if (fontSize < 9 ) {
            fontSize = 9;
        }
        
        cell.spendingLabel.font = [UIFont systemFontOfSize:fontSize];
        cell.incomeLabel.font = [UIFont systemFontOfSize:fontSize];
    }
    
    
//    cell.spendingLabel.frame = CGRectMake(0, cell.spendingLabel.frame.origin.y, width, cell.spendingLabel.frame.size.height);
    return cell;
}

// cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(width, width);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return cellMarig;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return cellMarig;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if (kind == UICollectionElementKindSectionHeader) {
        FirstCollectionViewHeard *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"FirstHeard" forIndexPath:indexPath];
//        [headerView addTitle];
        return headerView;
    }

    return nil;
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"点击了%ld号",indexPath.row - headDays + 1);
    OneDayData *oneDayData = [[OneDayData alloc] init];
    oneDayData.onedayDelegate = self;
    oneDayData.title = [NSString stringWithFormat:@"%d年%d月%ld日数据",year,month,indexPath.row - headDays + 1 ];
    oneDayData.year = year;
    oneDayData.month = month;
    oneDayData.day = (int)indexPath.row - headDays + 1;
//    oneDayData.categoryNameSpending = @"全部";
//    oneDayData.categoryNameIncome = @"全部";
    UINavigationController *NV = [[UINavigationController alloc] initWithRootViewController:oneDayData];
    [self presentViewController:NV animated:YES completion:nil];
}

//预算设置按钮事件
- (IBAction)BuduetAdd:(UIButton *)sender {
    Budget *budget = [[Budget alloc] init];
    budget.budgetHomeDeleget = self;
    budget.title = [NSString stringWithFormat:@"%d年%d月预算",year,month];
    budget.year = year;
    budget.month = month;
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:budget];
    [self presentViewController:nv animated:YES completion:nil];

}



@end
