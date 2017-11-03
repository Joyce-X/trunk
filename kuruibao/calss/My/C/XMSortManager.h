//
//  XMSortManager.h
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMCar.h"

/***********************************************************************************************
 
 排序专用
 
 ************************************************************************************************/

@interface XMSortManager : NSObject



/**
 对车辆列表进行排序

 @param cars 车辆列表
 @return 返回排序后的数组
 */
+ (NSMutableArray *)sortCar:(NSMutableArray <XMCar *> *)cars;

@end
