//
//  ButtonAction.h
//  MyNote
//
//  Created by xd_ on 15-4-29.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ButtonAction <NSObject>

@optional
-(void)selectAllAction;
-(void)cancelAction;
-(void)enterAction;

@end
