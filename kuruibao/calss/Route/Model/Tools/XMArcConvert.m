//
//  XMArcConvert.m
//  kuruibao
//
//  Created by X on 2017/9/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMArcConvert.h"

@implementation XMArcConvert

/**
 计算两点之间与X轴之间的夹角
 
 @param Pa 第一个点
 @param Pb 第二个点
 @return 角度值)
 */
+ (float)convertArcWithPointA:(CLLocationCoordinate2D)Pa Pb:(CLLocationCoordinate2D)Pb
{

    CGPoint A = CGPointMake(Pa.longitude, Pa.latitude);
    
    CGPoint B = CGPointMake(Pb.longitude, Pb.latitude);
    
    //处理在同一条轴上的情况
    if (B.x == A.x)
    {
        //-- 在一条y轴上
        if(B.y > A.y)
        {
            return 270;
        }else
        {
            return 90;
        
        }
        
    }
    
    if (B.y == A.y)
    {
        //-- 在同一条x轴上，
        if (B.x > A.x)
        {
            return 0;
        }else
        {
            return 180;
        }
    }
    
    
    
    //以A点为原点坐标，判断B点在第几象限，在不同的象限，进行不同的处理,
     int res = 0;//象限
    
    if (B.x > A.x)
    {
        if (B.y > A.y)
        {
            //-- 在第一象限
            res = 1;
        }else
        {
            //-- 第四象限
            res = 4;
        
        }
        
        
    }else if(B.x < A.x)
    {
        if (B.y > A.y)
        {
            //-- 在第2象限
            res = 2;
        }else
        {
            //-- 第3象限
            res = 3;
            
        }
    
    }
    
    float arc = 0,tan = 0;//弧度,正切值
    
    //-- 计算
    switch (res)
    {
        case 1:
            
            tan = (B.y - A.y) / (B.x - A.x);
            
            arc = M_PI * 2 - atan(tan);
            
            break;
            
        case 2:
            
            tan = (B.y - A.y) / (A.x - B.x);
            
            arc =  M_PI + atan(tan);
            
            break;
            
            
            
        case 3:
            
            tan = (A.y - B.y) / (A.x - B.x);
            
            arc =  M_PI - atan(tan);
            
            break;
            
        case 4:
            
            tan = (A.y - B.y) / (B.x - A.x);
            
            arc =  atan(tan);
            
            break;
            
        default:
            break;
    }
    
    
    //弧度转角度
    float dig = (arc * 360) / (2 * M_PI);

    return dig;
 

}


















@end
