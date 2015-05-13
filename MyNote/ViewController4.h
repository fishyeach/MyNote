//
//  ViewController4.h
//  MyNote
//
//  Created by xd_ on 15-4-29.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "demo.h"

@interface ViewController4 : UIViewController<demo>
- (IBAction)last:(id)sender;

@property (strong, nonatomic) id<demo> demo;

@end
