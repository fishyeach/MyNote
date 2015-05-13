//
//  CategoryCell.h
//  MyNote
//
//  Created by xd_ on 15/5/7.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CategoryCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIButton *rightBtn;
- (IBAction)closeKeyboard:(UITextField *)sender;
- (IBAction)touchOutside:(UITextField *)sender;

@end
