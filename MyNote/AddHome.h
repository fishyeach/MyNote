//
//  AddHome.h
//  MyNote
//
//  Created by xd_ on 15-4-3.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataInfo.h"
#import "AddHomeDelegate.h"
#import "Reload.h"

@interface AddHome : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate,Reload>


@property (nonatomic, assign)   id <AddHomeDelegate>  addDelegate;

//@property NSString *str;
@property int flag;
@property int witchTag;//区别来自哪里
@property int yearOneday;
@property int monthOneday;
@property int dayOneday;
@property NSString *fatherStr ;
@property NSString *chirdStr ;
@property NSString *moneyStr;
@property NSString *remarkStr;
@property NSString *timeStr;
@property int ID;

//单选按钮
@property (strong, nonatomic) IBOutlet UIButton *spendingBtn;
@property (strong, nonatomic) IBOutlet UIButton *incomeBtn;

@property (strong, nonatomic) IBOutlet UILabel *spendingRadio;
@property (strong, nonatomic) IBOutlet UILabel *incomeRadio;
//底部按钮
@property (strong, nonatomic) IBOutlet UIButton *canleBtn;
@property (strong, nonatomic) IBOutlet UIButton *enterBtn;
//日期
@property (strong, nonatomic) IBOutlet UILabel *dateLable;
//类别
@property (strong, nonatomic) IBOutlet UILabel *cateNameLabel;
//金额
@property (strong, nonatomic) IBOutlet UITextField *moneyLabel;
//备注
@property (strong, nonatomic) IBOutlet UITextView *remarkTextView;
//数据对象
@property (strong, nonatomic) DataInfo *dataInfo;
@property(nonatomic,assign) id <Reload> onedayReload;

//文本开始编辑
- (IBAction)moneyBeginEdit:(id)sender;
//结束编辑
- (IBAction)moneyEndEdit:(id)sender;

- (IBAction)SpendingAction:(UIButton *)sender;
- (IBAction)IncomeAction:(UIButton *)sender;

- (IBAction)selectData:(id)sender;
- (IBAction)selectCategory:(id)sender;
- (IBAction)canleAction:(id)sender;
- (IBAction)enterAction:(id)sender;

@end



