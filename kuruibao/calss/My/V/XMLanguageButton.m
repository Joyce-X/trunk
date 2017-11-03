//
//  XMLanguageButton.m
//  kuruibao
//
//  Created by x on 17/10/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMLanguageButton.h"

@implementation XMLanguageButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        
    
       
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.imageView removeFromSuperview];
    
    self.clipsToBounds = YES;
    
    self.layer.cornerRadius = 10;
    
    self.layer.borderColor = XMWhiteColor.CGColor;
    
    self.layer.borderWidth = 1;


}

- (void)setSelected:(BOOL)selected
{

    [super setSelected:selected];
    
    self.backgroundColor = selected ? XMGreenColor : XMClearColor;

}
@end
