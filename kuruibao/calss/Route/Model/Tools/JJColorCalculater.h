//
//  JJColorCalculater.h
//  kuruibao
//
//  Created by x on 17/7/24.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 轨迹回放的时候，计算两点之间的颜色值
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>
#define minR 116
#define minG 23
#define minB 0
#define maxR 231
#define maxG 76
#define maxB 60

@interface JJColorCalculater : NSObject

+ (UIColor *)calculateColorWithFirstSpeed:(NSInteger)fSpeed secondSpeed:(NSInteger)sSpeed;


@end
