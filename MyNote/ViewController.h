//
//  ViewController.h
//  MyNote
//
//  Created by xd_ on 15-4-8.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "demo.h"

@interface ViewController : UIViewController<demo>


@property (strong,nonatomic) UIView *myView;
@property (strong,nonatomic) UIButton *btn;
- (IBAction)actionDemo:(id)sender;
@property (strong, nonatomic) IBOutlet UIDatePicker *datepicker;
- (IBAction)actionPicker:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *mview;

-(void)some;

@end
