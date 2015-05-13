//
//  BaseViewController.m
//  MyNote
//
//  Created by xd_ on 15-4-29.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "BaseViewController.h"
#import "CategoryTool.h"

#define incomeFlag 1
#define spendingFlag -1


@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CategoryTool *cate = [[CategoryTool alloc] init];
//    CategoryTool.buttonDelegate = self;
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

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_whichCategory == spendingFlag) {
        return 2;
    }else{
        return 1;
    }
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_whichCategory == spendingFlag) {
        if (component == 0) {
            return [_categoryFather count];
        } else {
            return [_categortChird count];
        }
    }else{
        return [_categoryArr count];
    }
    
}

-(NSString *)pickerView:(UIPickerView *)pickerView
            titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (_whichCategory == spendingFlag) {
        if (component == 0) {
            return [_categoryFather objectAtIndex:row];
        } else {
            return [_categortChird objectAtIndex:row];
        }
    }else{
        return [_categoryArr objectAtIndex:row];
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    if (_whichCategory == spendingFlag) {
        
        //        NSLog(@"chirdString:%@",chirdString);
        if (component == 0) {
            //        NSString *seletedProvince = [categoryFather objectAtIndex:row];
            _categortChird = [[[_categoryArr objectAtIndex:row] allValues]objectAtIndex:0];
            //重点！更新第二个轮子的数据
            [_mPicker reloadComponent:1];
            _fatherString = [_categoryFather objectAtIndex:row];
            _chirdString =  [_categortChird objectAtIndex:0];
            _cateString = [[NSString alloc] initWithFormat:@"%@-%@",_fatherString,_chirdString];
            
        }else{
            _chirdString =  [_categortChird objectAtIndex:row];
            _cateString = [[NSString alloc] initWithFormat:@"%@-%@",_fatherString,_chirdString];
        }
        
    }else{
        _chirdString = [[NSString alloc] initWithFormat:@"%@",[_categoryArr objectAtIndex:row]];
        _cateString = [[NSString alloc] initWithFormat:@"%@",[_categoryArr objectAtIndex:row]];
        NSLog(@"类别:%@",_cateString);
    }
    
    NSLog(@"类别:%@",_cateString);
//    self.cateNameLabel.text = cateString;
    
}


@end
