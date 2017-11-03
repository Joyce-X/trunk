//
//  JJColorCalculater.m
//  kuruibao
//
//  Created by x on 17/7/24.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "JJColorCalculater.h"
#import <UIKit/UIKit.h>


@implementation JJColorCalculater

+ (UIColor *)calculateColorWithFirstSpeed:(NSInteger)fSpeed secondSpeed:(NSInteger)sSpeed
{
    
    
    //!< 平均速度
    float averageSpeed = (fSpeed + sSpeed) / 2.0;
    
   
    
    float scale = averageSpeed / 80;//!< 速度对应的比例
    
//    float R = 170 - (170 - 64) * scale;
//    
//    float G = 171 - (171 - 44) *scale;
    
    if (scale > 1)
    {
        scale = 1;
    }
    
    //!< 在最小值的基础上，加上颜色区间占的比例，得到对应的颜色值，注意只适应月RGB线性递增的情况
    float R = minR + (maxR - minR) * scale;
    
    float G = minG + (maxG - minG) * scale;
    
    float B = minB + (maxB - minB) * scale;
    
     XMLOG(@"---------速度:%.2f---颜色（%.2f,%.2f,%.2f）------",averageSpeed,R,G,B);
     
    
    return [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:1];
   
}

@end
