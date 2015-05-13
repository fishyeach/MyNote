//
//  TemplateEdit.h
//  MyNote
//
//  Created by xd_ on 15-4-22.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateEdit : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,UIAlertViewDelegate>

@property int speingdOrIncome;

@property (strong, nonatomic) IBOutlet UILabel *categoryLabel;
- (IBAction)selectCategory:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UITextField *moeyTextField;
- (IBAction)editingChanged:(UITextField *)sender;
- (IBAction)saveBtnAction:(UIButton *)sender;


@end
