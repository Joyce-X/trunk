//
//  CoordinateConverter.h
//  kuruibao
//
//  Created by x on 17/7/17.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 坐标转换工具
 
 ************************************************************************************************/

#import <Foundation/Foundation.h>

#import <CoreLocation/CoreLocation.h>

@interface CoordinateConverter : NSObject


/**
 GPS坐标转换为GCJ-02坐标系

 @param models GPS坐标模型
 @return GCJ坐标模型
 */
+ (NSArray *)converGPSToGCJ_02:(NSArray *)models;

@end
