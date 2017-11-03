//
//  XMLogBtn_us.m
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMLogBtn_us.h"

@implementation XMLogBtn_us

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected)
    {
        self.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        
    }else
    {
        self.titleLabel.font = [UIFont systemFontOfSize:20];
    
    }


}

@end
