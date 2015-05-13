//
//  SecondViewController.m
//  MyNote
//
//  Created by xd_ on 15-4-2.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "SecondViewController.h"
#import "Tools.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [Tools addBorder:_buttonsView];
    [Tools addBorder:_seachView1];
    [Tools addBorder:_seachView2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
