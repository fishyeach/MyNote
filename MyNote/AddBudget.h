//
//  AddBudget.h
//  MyNote
//
//  Created by xd_ on 15-4-23.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHomeDelegate.h"

@interface AddBudget : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITextField *dayCount;
@property (strong, nonatomic) IBOutlet UIView *dayCountView;
@property (strong, nonatomic) IBOutlet UITextField *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
- (IBAction)selectCategory:(UIButton *)sender;

- (IBAction)dayLabelValueChange:(UITextField *)sender;
- (IBAction)enterAction:(UIButton *)sender;

@property int year;
@property int month;

@end
