//
//  ViewController3.m
//  MyNote
//
//  Created by xd_ on 15-4-29.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "ViewController3.h"
#import "ViewController4.h"
#import "ViewController.h"

@interface ViewController3 ()

@end

@implementation ViewController3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)next:(UIButton *)sender {
    self.btn = nil;
    ViewController4 *v4 = [ViewController4 new];
    UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:v4];
    v4.demo = self;
    [self presentViewController:nv animated:YES completion:nil];
}
@end
