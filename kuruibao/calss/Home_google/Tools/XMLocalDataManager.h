//
//  XMLocalDataManager.h
//  kuruibao
//
//  Created by x on 17/9/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//


/***********************************************************************************************
 
 管理默认车辆的本地缓存数据
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>

@interface XMLocalDataManager : NSObject


/**
 判断是否有对应汽车的缓存数据

 @param qicheid 汽车id
 @return 是否有缓存
 */
+ (BOOL)hasCacheDataForCar:(NSString *)qicheid;

/**
 根据汽车id，保存对应的缓存数据

 @param qicheid 汽车编号
 */
+ (void)saveCacheDataForCar:(NSString *)qicheid data:(NSDictionary *)dic;

/**
 根据汽车id取出对应的缓存数据

 @param qicheid 汽车编号
 @return 缓存数据
 */
+ (NSDictionary *)fetchCacheDataForCar:(NSString *)qicheid;











































#pragma mark ------- 保存数据
/**
 保存最后定位的时间

 @param time 最后定位时间
 */
+ (void)saveLastLocateTime:(NSString *)time;


/**
 保存最后的司机名称

 @param name 司机名称
 */
+ (void)saveLastDriverName:(NSString *)name;



/**
 保存上一次的经度

 @param longitude 经度值
 */
+ (void)saveLastLongitude:(float)longitude;

/**
 保存上一次的纬度值

 @param latitude 纬度值
 */
+ (void)saveLastLatitude:(float)latitude;

/**
 保存车牌号码
 
 @param carNumber chepai号码
 */
+ (void)saveCarNumber:(NSString *)carNumber;

/**
 保存品牌编号

 @param ID 编号
 */
+ (void)saveID:(NSString *)ID;

#pragma mark ------- 获取数据

/**
 获取最后的定位时间

 @return 定位时间
 */
+ (NSString *)getLastLocateTime;

/**
 获取最后驾驶的司机名称

 @return 司机名称
 */
+ (NSString *)getLastDriverName;

/**
 获取上一次定位的经度

 @return 经度值
 */
+ (float)getLastLongitude;

/**
 获取上一次的纬度值

 @return 纬度值
 */
+ (float)getLastLatitude;

/**
 获取车牌号码
 
 @return 车牌号码
 */
+ (NSString *)getCarNumber;

/**
 获取品牌编号

 @return 编号，用来显示图片
 */
+ (NSString *)getCarId;

@end
