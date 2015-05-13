//
//  CategoryCell.m
//  MyNote
//
//  Created by xd_ on 15/5/7.
//  Copyright (c) 2015年 ly. All rights reserved.
//

#import "CategoryCell.h"

@implementation CategoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)closeKeyboard:(UITextField *)sender {
    [sender resignFirstResponder];
}

- (IBAction)touchOutside:(UITextField *)sender {
    [sender resignFirstResponder];

}
@end
