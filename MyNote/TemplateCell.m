//
//  TemplateCell.m
//  MyNote
//
//  Created by xd_ on 15-4-15.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "TemplateCell.h"
#import "Tools.h"

@implementation TemplateCell

- (void)awakeFromNib {
    // Initialization code
//    [_cellEditBtn setBackgroundImage:[Tools getImageFromColor:[UIColor blueColor] withView:_cellEditBtn] forState:UIControlStateHighlighted];
    [_cellEditBtn setHidden:YES];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
