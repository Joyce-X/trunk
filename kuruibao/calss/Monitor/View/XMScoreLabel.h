//
//  XMScoreLabel.h
//  kuruibao
//
//  Created by x on 17/7/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//
/***********************************************************************************************
 
 监控界面自定义的用来显示分数的label
 
 ************************************************************************************************/
#import <UIKit/UIKit.h>

@interface XMScoreLabel : UILabel


/**
 分数
 */
@property (assign, nonatomic) NSInteger score;

/**
 用于动画界面设置分数
 */
@property (assign, nonatomic) NSInteger animateScore;


/**
 字体大小
 */
@property (assign, nonatomic) int fontSize;


/**
 在一定时间内，动画到目标分数

 @param score 目标分数
 @param duration 动画时间
 */
- (void)animateToScore:(NSInteger)score duration:(float)duration;

@end
