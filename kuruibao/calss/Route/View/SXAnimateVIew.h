//
//  SXAnimateVIew.h
//  SXFiveScoreShow
//
//  Created by dongshangxian on 15/5/26.
//  Copyright (c) 2015年 Sankuai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SXAnimateVIew : UIView

/**
 分数一
 */
@property(nonatomic,assign)CGFloat subScore1;
/**
 分数2
 */
@property(nonatomic,assign)CGFloat subScore2;
/**
 分数3
 */
@property(nonatomic,assign)CGFloat subScore3;
/**
 分数4
 */
@property(nonatomic,assign)CGFloat subScore4;
/**
 分数5
 */
@property(nonatomic,assign)CGFloat subScore5;

/**
 绘制的类型，1是填充  2 是描边
 */
@property(nonatomic,assign)int showType;
/**
 设置描边的颜色
 */
@property(nonatomic,strong)UIColor *showColor;
/**
 线宽
 */
@property(nonatomic,assign)float showWidtn;
/**
 是否绘制渐变色
 */
@property (assign, nonatomic) BOOL isGradient;

/**
 开始渐变色
 */
@property (strong, nonatomic) UIColor *startColor;

/**
 结束渐变色
 */
@property (strong, nonatomic) UIColor *endColor;

@end
