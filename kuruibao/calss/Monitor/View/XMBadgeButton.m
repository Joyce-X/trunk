//
//  XMBadgeButton.m
//  kuruibao
//
//  Created by x on 17/8/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMBadgeButton.h"

@interface XMBadgeButton ()

@property (strong, nonatomic) UILabel *badgeLabel;//!< 显示角标

@end


@implementation XMBadgeButton


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
         [self setupInit];
    }
    
    return self;

}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        [self setupInit];
    }
    return self;
}


- (void)setupInit
{
    
    UILabel *badgeLabel = [UILabel new];
    
    badgeLabel.backgroundColor = [UIColor redColor];
    
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    
    badgeLabel.textColor = XMWhiteColor;
    
    badgeLabel.font = [UIFont systemFontOfSize:10];
    
    badgeLabel.clipsToBounds = YES;
    
    badgeLabel.layer.cornerRadius = 7.5;
    
    badgeLabel.adjustsFontSizeToFitWidth = YES;
    
    badgeLabel.hidden = YES;
    
    [self addSubview:badgeLabel];
    
    [badgeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(self.mas_right).offset(-5);
        
        make.centerY.equalTo(self.mas_top).offset(8);
        
        make.size.equalTo(CGSizeMake(15, 15));
        
        
    }];
    
    
    self.badgeLabel = badgeLabel;
    
}

- (void)setBadgeNumber:(NSInteger)badgeNumber
{
    _badgeNumber = badgeNumber;
    
    if (badgeNumber == 0)
    {
        self.badgeLabel.hidden = YES;
        
    }else
    {
        self.badgeLabel.hidden = NO;
        
        if(badgeNumber > 99)
        {
            
            self.badgeLabel.text = JJLocalizedString(@"99+", nil);
            
        }else
        {
            
            self.badgeLabel.text = [NSString stringWithFormat:@"%ld",badgeNumber];
            
        }
        
     
    }


}

@end














