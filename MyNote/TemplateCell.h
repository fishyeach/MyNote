//
//  TemplateCell.h
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemplateCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIButton *cellEditBtn;
@property (strong, nonatomic) IBOutlet UILabel *categoryName;
@property (strong, nonatomic) IBOutlet UILabel *moneyLabel;
@property (strong, nonatomic) IBOutlet UILabel *remarkLabel;

@end
