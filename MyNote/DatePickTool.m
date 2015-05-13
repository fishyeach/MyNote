//
//  Tool.m
//  MyNote
//
//  Created by xd_ on 15-4-8.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "DatePickTool.h"

#define datePickerTag 20

@implementation DatePickTool{

}

static int flag;
static NSString *timeOfPick;
static void (^callBackBlock)(NSString *);




+(void)setViewBroder:(UIView *)view{
    view.layer.borderWidth = 1;
}

+(void)showDatePicker:(UIView *)superView withFlag:(void (^)(NSString *))callBack{
    
    NSArray *views = [[NSBundle mainBundle] loadNibNamed:@"DataPicker" owner:nil options:nil];
    UIView *chirdView = [views objectAtIndex:0];
    chirdView.frame = CGRectMake(0, 0, Screen_width, Screen_height);
    [superView addSubview:chirdView];
    //[viewArray addObject:chirdView];
    
//    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, Screen_width, Screen_height - 200)];
//    maskView.backgroundColor = [UIColor clearColor];
//    [superView addSubview:maskView];
    //[viewArray addObject:maskView];
    
    
    UIView *upView = [[UIView alloc] initWithFrame:CGRectMake(0, Screen_height - 245, Screen_width, 40)];
    upView.backgroundColor = [UIColor yellowColor];
    [chirdView addSubview:upView];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(Screen_width- 70, 0, 70, 40)];
    btn.backgroundColor = myButtonBg;
    [btn setTitle:@"确定" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [upView addSubview:btn];
    
    [btn addTarget:self action:@selector(show:) forControlEvents:UIControlEventTouchUpInside];
    
    flag = 1;
   
    UIDatePicker *datePicker = (UIDatePicker *)[chirdView viewWithTag:datePickerTag];
    [datePicker setBackgroundColor:myYellowColor];
    [datePicker addTarget:self action:@selector(datePick:) forControlEvents:UIControlEventValueChanged];
    callBackBlock = callBack;
//    callBack(timeOfPick);

}

+(void)show:(UIButton *)btn{
    NSLog(@"!!!");
    flag = 0;
    [btn.superview.superview removeFromSuperview];
}


+(int)getFlag{
    return flag;
}

+(void)datePick:(UIDatePicker *)datePicker{
    
    NSDate *select  = [datePicker date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSString *date = [dateFormatter stringFromDate:select];
    
    callBackBlock(date);
}


@end
