//
//  XMFooterView.m
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMFooterView.h"

@implementation XMFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.backgroundColor = XMClearColor;
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"add icon"]];
        
        [self addSubview:iv];
        
        UILabel *label = [UILabel new];
        
        label.textColor = XMWhiteColor;
        
        label.text = JJLocalizedString(@"添加车辆", nil) ;
        
        label.font = [UIFont systemFontOfSize:14];
        
        label.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:label];
        
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.size.equalTo(CGSizeMake(20, 20));
            
            make.centerX.equalTo(self);
            
            make.top.equalTo(self).offset(20);
            
        }];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(CGSizeMake(200, 20));
            
            make.centerX.equalTo(self);
            
            make.top.equalTo(iv.mas_bottom).offset(10);
            
        }];
        
        
        UIButton *btn = [UIButton new];
        
        [self addSubview:btn];
        
        [btn addTarget:self action:@selector(tapTrigger:) forControlEvents:UIControlEventTouchUpInside];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self);
        }];
        
    }

    return self;
}




- (void)tapTrigger:(UIButton *)tap
{
    XMLOG(@"---------tapTrigger---------");
    
    [self.delegate footerAddButtonClick];
    
}


@end
