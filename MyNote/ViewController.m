//
//  ViewController.m
//  MyNote
//
//  Created by xd_ on 15-4-8.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "ViewController.h"
#import "DatePickTool.h"
#import "Template.h"
#import "Budget.h"

@interface ViewController (){
    int flag;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    flag = 0;
    
//    NSString *a = [NSString stringWithFormat:@"%@",@"1.5"];
    NSString *a = @"1.5";
    NSString *b = @"0.8";
    double aa = [a doubleValue];
    double bb = [b doubleValue];
    NSLog(@"a + b = %f",aa + bb);

    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)appviewbtnClick:(UIButton *)btn{
    NSLog(@"!!!!!");
    UINavigationController *NV = [[UINavigationController alloc] initWithRootViewController:[[Template alloc] init]];
    [self presentViewController:NV animated:YES completion:nil];
//    [self.myView removeFromSuperview];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)actionDemo:(id)sender {

  
        Budget *budget = [Budget new];
        UINavigationController *nv = [[UINavigationController alloc] initWithRootViewController:budget];
        [self presentViewController:nv animated:YES completion:nil];
        
    

}
- (IBAction)actionPicker:(id)sender {
    NSLog(@"!!!");
//    [self.mview.layer addAnimation:[self moveX:100.0f X:[NSNumber numberWithFloat:200.0f]] forKey:nil];

   }

-(CABasicAnimation *)moveX:(float)time X:(NSNumber *)x
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];///.y的话就向下移动。
    animation.toValue = x;
    animation.duration = time;
    animation.removedOnCompletion = NO;//yes的话，又返回原位置了。
    animation.repeatCount = MAXFLOAT;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}

-(void)MoveView:(UIView *)view To:(CGRect)frame During:(float)time{
    
    // 动画开始
    
    [UIView beginAnimations:nil context:nil];
    
    // 动画时间曲线 EaseInOut效果
    
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    // 动画时间
    
    [UIView setAnimationDuration:time];
    
    view.frame = frame;
    
    // 动画结束（或者用提交也不错）
    
    [UIView commitAnimations];
    
}

-(void)show{
    NSLog(@"SHOW");
}

@end
