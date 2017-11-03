//
//  XMSortManager.m
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMSortManager.h"

@implementation XMSortManager


/**
 对车辆列表进行排序
 
 @param cars 车辆列表
 @return 返回排序后的数组
 */
+ (NSMutableArray *)sortCar:(NSMutableArray <XMCar *> *)cars
{
    
    if(cars.count == 1)
        return cars;
    
    if(cars.count == 0)
        return nil;
    
    XMCar *car_def = nil;
    
    for (XMCar *car in cars)
    {
        if (car.isfirst)
        {
            //!< 默认车辆
            car_def = car;
        }
        
    }
    
    [cars removeObject:car_def];//!< 删除默认车辆
    
    [cars insertObject:car_def atIndex:0];//!< 插入默认车辆



    return cars;
}
@end
