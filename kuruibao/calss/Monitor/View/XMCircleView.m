//
//  XMCircleView.m
//  kuruibao
//
//  Created by x on 17/7/26.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCircleView.h"

@implementation XMCircleView

- (void)drawRect:(CGRect)rect {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    CGPoint center = CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0);
    
    float radius = MIN(center.x, center.y)-20;
    
    [path addArcWithCenter:center radius:radius startAngle:M_PI * 3/2 endAngle:M_PI * 2 * 0.32 clockwise:YES];
    
    [XMGreenColor setStroke];
    
    path.lineWidth = 28;
    
    [path stroke];
    
}

@end
