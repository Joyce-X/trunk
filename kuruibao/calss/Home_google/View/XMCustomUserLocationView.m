//
//  XMCustomUserLocationView.m
//  kuruibao
//
//  Created by x on 17/6/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCustomUserLocationView.h"

@implementation XMCustomUserLocationView

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
    
    if (self)
    {
        self.image = [UIImage imageNamed:@"google_location"];
//        self.image = [UIImage imageNamed:@"temUserlocation"];
        
        
        
        [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionAutoreverse | UIViewAnimationOptionRepeat animations:^{
            
            self.transform = CGAffineTransformMakeScale(1.5, 1.5);
            
        } completion:nil];
      
        
    }
    
    return self;
    
}

@end
