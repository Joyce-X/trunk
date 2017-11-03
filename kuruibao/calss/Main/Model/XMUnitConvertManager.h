//
//  XMUnitConvertManager.h
//  kuruibao
//
//  Created by x on 17/8/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMUnitConvertManager : NSObject

#pragma mark ------- 转换结果带单位
/**
 将原始的用km计量的数据，转换为用mile计量的数据，并且带“mile”单位，外部不必重复处理

 @param sourceDistance 需要转换的公里数
 @return mile数量 并且带单位
 */
+ (NSString *)convertKmToMile:(float)sourceDistance;


/**
 将用升计量的数据，转换成为用Gallon计量的数据，并且带“gallon”单位，外部不用重复处理

 @param sourceLitre 用升计量的原始数据，注意：不是公升
 @return gallon数量 并且带单位
 */
+ (NSString *)convertLitreToGallon:(float)sourceLitre;

#pragma mark ------- 转换结果不带单位

/**
 将原始的用km计量的数据，转换为用mile计量的数据，不带“mile”单位，
 
 @param sourceDistance 需要转换的公里数
 @return mile数量 不会带单位
 */
+ (NSString *)convertKmToMileWithoutUnit:(float)sourceDistance;


/**
 将用升计量的数据，转换成为用Gallon计量的数据，不附带“gallon”单位
 
 @param sourceLitre 用升计量的原始数据，注意：不是公升
 @return gallon数量  不附带单位
 */
+ (NSString *)convertLitreToGallonWithoutUnit:(float)sourceLitre;

#pragma mark ------- 油耗换算

/**
 将argL/100km 换算成为 xGallon/100mile 并且带单位（gal/100mile）返回

 @param arg 百公里油耗 单位：L/100km
 @return 百公里油耗 单位：gal/100mile
 */
+ (NSString *)litrePer100KMToGallonPer100Mile:(CGFloat)arg;


#pragma mark ------- 时间转换

/**
 将秒数转换为标准的时间格式

 @param time 用秒表示的时间
 @return eg:  12:09:23
 */
+ (NSString *)convertTimeToStandardFormat:(uint)time;



#pragma mark ------- 温度转换

/**
 摄氏度转换为华氏度    水温 1摄氏度(℃)=33.8华氏度(℉)
 
 @param tem 摄氏度
 @return 华氏度
 */
+ (NSString *)convertTemperatureToF:(CGFloat)tem;
@end
