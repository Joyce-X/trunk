//
//  SXAnimateVIew.m
//  SXFiveScoreShow
//
//  Created by dongshangxian on 15/5/26.
//  Copyright (c) 2015年 Sankuai. All rights reserved.
//

#import "SXAnimateVIew.h"

// ------假如想设置区间为3.8分到5.0分，那你就写1.2
#define baseNum 5.0

@implementation SXAnimateVIew

- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.backgroundColor = XMClearColor;
  
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    
    if (self)
    {
        //!< 设置默认渐变色
            self.startColor = XMColor(221, 163, 254);
        
            self.endColor = XMColor(96, 82, 233);
    }
    
    return self;

}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //!< 设置默认渐变色
        self.startColor = XMColor(221, 163, 254);
        
        self.endColor = XMColor(96, 82, 233);
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    
    if (self.subScore5 != 0) {
        float subScore1,subScore2,subScore3,subScore4,subScore5;
        float x1,y1,x2,y2,x3,y3,x4,y4,x5,y5;
        
        // ------之所以再做一次传值，可能是因为设置的权值并不是5.0，但是做处理又不想改到原来的值
        subScore1 = self.subScore1;
        subScore2 = self.subScore2;
        subScore3 = self.subScore3;
        subScore4 = self.subScore4;
        subScore5 = self.subScore5;
        
        // ------再做一次处理，假如分数低于2.5那就算是没分了 不显示该片段了。
        //    if (subScore1 < (5.0-baseNum)) {
        //        subScore1 = (5.0-baseNum);
        //    }
        //    if (subScore2 < (5.0-baseNum)) {
        //        subScore2 = (5.0-baseNum);
        //    }
        //    if (subScore3 < (5.0-baseNum)) {
        //        subScore3 = (5.0-baseNum);
        //    }
        //    if (subScore4 < (5.0-baseNum)) {
        //        subScore4 = (5.0-baseNum);
        //    }
        //    if (subScore5 < (5.0-baseNum)) {
        //        subScore5 = (5.0-baseNum);
        //    }
        
        // ------因为设置了权值这里需要更改下比例
        subScore1 = subScore1-(5.0-baseNum);
        subScore2 = subScore2-(5.0-baseNum);
        subScore3 = subScore3-(5.0-baseNum);
        subScore4 = subScore4-(5.0-baseNum);
        subScore5 = subScore5-(5.0-baseNum);
        
        
        
        x1 = (100.25) * self.bounds.size.width/200;
        y1 = (100 - 100 * (subScore1 / baseNum)) * self.bounds.size.width/200;
        
        x2 = (100.25 - (100.25 - 4.75) * (subScore2 / baseNum)) * self.bounds.size.width/200;
        y2 = (100 - (100-69) * (subScore2 / baseNum)) * self.bounds.size.width/200;
        
        x3 = (100.25 - (100.25 - 41.25) * (subScore3 / baseNum)) * self.bounds.size.width/200;
        y3 = (100 + (180.5 - 100) * (subScore3 / baseNum)) * self.bounds.size.width/200;
        
        x4 = (100.25 + (158.25 - 100.25) * (subScore4 / baseNum)) * self.bounds.size.width/200;
        y4 = (100 + (180.5 - 100) * (subScore4 / baseNum)) * self.bounds.size.width/200;
        
        x5 = (100.25 + (194.75 - 100.25) * (subScore5 / baseNum)) * self.bounds.size.width/200;
        y5 = (100 - (100 - 69) * (subScore5 / baseNum)) * self.bounds.size.width/200;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        if (self.isGradient)
        {
            CGMutablePathRef path = CGPathCreateMutable();
            
            CGPathMoveToPoint(path, NULL, x1, y1);
            
            CGPathAddLineToPoint(path, NULL, x2, y2);
            
            CGPathAddLineToPoint(path, NULL, x3, y3);
            CGPathAddLineToPoint(path, NULL, x4, y4);
            CGPathAddLineToPoint(path, NULL, x5, y5);
            CGPathAddLineToPoint(path, NULL, x1, y1);
            CGPathCloseSubpath(path);
            
            //绘制渐变
            [self drawRadialGradient:ctx path:path startColor:self.startColor.CGColor endColor:self.endColor.CGColor];
            
            CGPathRelease(path);//!< 释放
        }else
        {
            //-----------------------------------------画线段
                    CGContextMoveToPoint(ctx, x1, y1);
                    CGContextAddLineToPoint(ctx, x2, y2);
                    CGContextAddLineToPoint(ctx, x3, y3);
                    CGContextAddLineToPoint(ctx, x4, y4);
                    CGContextAddLineToPoint(ctx, x5, y5);
                    CGContextAddLineToPoint(ctx, x1, y1);
            
            
            
                    [self showTheFiveScoreWithContext:ctx];
        
        
        }
        
    
        
    }else if (self.subScore4 != 0){
        float subScore1,subScore2,subScore3,subScore4;
        float x1,y1,x2,y2,x3,y3,x4,y4;
        
        // ------之所以再做一次传值，可能是因为设置的权值并不是5.0，但是做处理又不想改到原来的值
        subScore1 = self.subScore1;
        subScore2 = self.subScore2;
        subScore3 = self.subScore3;
        subScore4 = self.subScore4;
        
        // ------因为设置了权值这里需要更改下比例
        subScore1 = subScore1-(5.0-baseNum);
        subScore2 = subScore2-(5.0-baseNum);
        subScore3 = subScore3-(5.0-baseNum);
        subScore4 = subScore4-(5.0-baseNum);
        
        
        x1 = (100.25) * self.bounds.size.width/200;
        y1 = (100 - 100 * (subScore1 / baseNum)) * self.bounds.size.width/200;
        
        x2 = (100.25 - (100.25 - 0) * (subScore2 / baseNum)) * self.bounds.size.width/200;
        y2 = (100) * self.bounds.size.width/200;
        
        x3 = (100.25) * self.bounds.size.width/200;
        y3 = (100 + (200 - 100) * (subScore3 / baseNum)) * self.bounds.size.width/200;
        
        x4 = (100.25 + (200 - 100.25) * (subScore4 / baseNum)) * self.bounds.size.width/200;
        y4 = (100) * self.bounds.size.width/200;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //-----------------------------------------画线段
        CGContextMoveToPoint(ctx, x1, y1);
        CGContextAddLineToPoint(ctx, x2, y2);
        CGContextAddLineToPoint(ctx, x3, y3);
        CGContextAddLineToPoint(ctx, x4, y4);
        CGContextAddLineToPoint(ctx, x1, y1);
        
        
        [self showTheFiveScoreWithContext:ctx];
        
    }else{
        float subScore1,subScore2,subScore3;
        float x1,y1,x2,y2,x3,y3;
        
        // ------之所以再做一次传值，可能是因为设置的权值并不是5.0，但是做处理又不想改到原来的值
        subScore1 = self.subScore1;
        subScore2 = self.subScore2;
        subScore3 = self.subScore3;
        
        
        // ------因为设置了权值这里需要更改下比例
        subScore1 = subScore1-(5.0-baseNum);
        subScore2 = subScore2-(5.0-baseNum);
        subScore3 = subScore3-(5.0-baseNum);
        
        
        
        x1 = (100.25) * self.bounds.size.width/200;
        y1 = (100 - 100 * (subScore1 / baseNum)) * self.bounds.size.width/200;
        
        x2 = (100.25 - (100.25 - 15) * (subScore2 / baseNum)) * self.bounds.size.width/200;
        y2 = (100 + (150 - 100) * (subScore2 / baseNum)) * self.bounds.size.width/200;
        
        x3 = (100.25 + (185 - 100.25) * (subScore3 / baseNum)) * self.bounds.size.width/200;
        y3 = (100 + (150 - 100) * (subScore3 / baseNum)) * self.bounds.size.width/200;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        
        //-----------------------------------------画线段
        CGContextMoveToPoint(ctx, x1, y1);
        CGContextAddLineToPoint(ctx, x2, y2);
        CGContextAddLineToPoint(ctx, x3, y3);
        CGContextAddLineToPoint(ctx, x1, y1);
       
        
        
        
        [self showTheFiveScoreWithContext:ctx];
        
    }
    
}

- (void)showTheFiveScoreWithContext:(CGContextRef)ctx
{
    CGContextSetLineWidth(ctx, self.showWidtn);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    
    if (self.showType == 1) {
        CGContextSetFillColorWithColor(ctx, self.showColor.CGColor);
        //    CGContextSetRGBFillColor(ctx, 0.97, 0.5, 0.09, 0.5);
        CGContextFillPath(ctx);
    }else if (self.showType == 2){
        CGContextSetStrokeColorWithColor(ctx, self.showColor.CGColor);
        //    CGContextSetRGBFillColor(ctx, 0.97, 0.5, 0.09, 0.5);
        CGContextStrokePath(ctx);
    }
}

- (void)drawRadialGradient:(CGContextRef)context
                      path:(CGPathRef)path
                startColor:(CGColorRef)startColor
                  endColor:(CGColorRef)endColor
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    
    
    CGRect pathRect = CGPathGetBoundingBox(path);
    CGPoint center = CGPointMake(CGRectGetMidX(pathRect), CGRectGetMidY(pathRect));
    CGFloat radius = MAX(pathRect.size.width / 2.0, pathRect.size.height / 2.0) * sqrt(2);
    
    CGContextSaveGState(context);
    CGContextAddPath(context, path);
    CGContextEOClip(context);
    
    CGContextDrawRadialGradient(context, gradient, center, 0, center, radius, 0);
    
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
}


@end
