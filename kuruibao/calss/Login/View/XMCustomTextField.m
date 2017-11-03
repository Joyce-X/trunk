//
//  XMCustomTextField.m
//  kuruibao
//
//  Created by x on 17/8/24.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCustomTextField.h"

@implementation XMCustomTextField

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
        [self setup];
    }
    return self;
}


-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self setup];
    }
    
    return self;

}

- (void)setup
{
 
    UIButton *clear = [self valueForKey:@"_clearButton"];
    
    [clear setImage:[UIImage imageNamed:@"delete_fill"] forState:UIControlStateNormal];
    
    [clear setImage:[UIImage imageNamed:@"delete_fill"] forState:UIControlStateHighlighted];
    
    [self setValue:XMGrayColor forKeyPath:@"_placeholderLabel.textColor"];
    
    
    
//    [self.phoneTF setValue:XMGrayColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.verifyCodeTF setValue:XMGrayColor forKeyPath:@"_placeholderLabel.textColor"];
//    [self.pwdTF setValue:XMGrayColor forKeyPath:@"_placeholderLabel.textColor"];

}

@end
