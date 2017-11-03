//
//  XMMapCeeInsertView.m
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMapCeeInsertView.h"

@implementation XMMapCeeInsertView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //!< 设置字体自适应
    self.distanceLabel.adjustsFontSizeToFitWidth = YES;
    

}

@end
