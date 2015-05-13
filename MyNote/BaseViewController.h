//
//  BaseViewController.h
//  MyNote
//
//  Created by xd_ on 15-4-29.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ButtonAction.h"
#import "Reload.h"

@interface BaseViewController : UIViewController<UIPickerViewDataSource,UIPickerViewDelegate,ButtonAction>

@property (strong, nonatomic) UIPickerView *mPicker;
@property int whichCategory;
@property NSMutableArray *categoryArr;
@property NSMutableArray *categoryFather;
@property NSArray *categortChird;
@property NSString *fatherString ;
@property NSString *chirdString ;
@property NSString *cateString ;

@property (nonatomic, assign) id <Reload> reloadDelegaet;

@end
