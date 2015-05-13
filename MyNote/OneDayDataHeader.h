//
//  OneDayDataHeader.h
//  MyNote
//
//  Created by xd_ on 15-4-28.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OneDayDataHeader : UIView
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *titleMoney;
@property (strong, nonatomic) IBOutlet UILabel *titleCategory;

@property (strong, nonatomic) IBOutlet UIButton *selectCategoryBtn;

@end
