//
//  PathView.h
//  CircleGradientLayer
//
//  Created by Dinotech on 16/1/6.
//  Copyright © 2016年 Dinotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <SystemConfiguration/SystemConfiguration.h>
#define degressToRadius(ang) (M_PI*(ang)/180.0f) //把角度转换成PI的方式
#define PROGRESS_WIDTH 80 // 圆直径
#define PROGRESS_LINE_WIDTH 12 //弧线的宽度
@interface PathView : UIView
{
    CAShapeLayer * _trackLayer;
    CAShapeLayer * _progressLayer;
    
}

/**
 动画时间
 */
@property (assign, nonatomic) float animationTime;


/**
 渐变开始绘制颜色
 */
@property (strong, nonatomic) UIColor *beginColor;


/**
 渐变结束颜色
 */
@property (strong, nonatomic) UIColor *endColor;

/**
 test method
 */
- (void)animate;

/**
 调用动画

 @param animationTime 动画时间
 @param percent 圆弧占圆的比例
 */
- (void)animateWithDuration:(float)animationTime percent:(float)percent;

@end
