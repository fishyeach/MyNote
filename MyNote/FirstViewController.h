//
//  FirstViewController.h
//  MyNote
//
//  Created by xd_ on 15-4-2.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddHomeDelegate.h"

@interface FirstViewController : UIViewController<AddHomeDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

- (IBAction)gotoTemplate:(UIButton *)sender;
@property (strong, nonatomic) IBOutlet UILabel *spendingLabel;
@property (strong, nonatomic) IBOutlet UILabel *incomeLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIView *monthView;

@property (strong, nonatomic) IBOutlet UILabel *monthBudgetLabel;
@property (strong, nonatomic) IBOutlet UILabel *BudgetBalance;
@property (strong, nonatomic) IBOutlet UILabel *monthBalance;
- (IBAction)BuduetAdd:(UIButton *)sender;

@end

