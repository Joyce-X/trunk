//
//  XMLocalDataManager.m
//  kuruibao
//
//  Created by x on 17/9/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMLocalDataManager.h"

#define timeKey   @"timeKey"
#define nameKey   @"nameKey"
#define latKey    @"latitudeKey"
#define longKey   @"longitude"
#define numberKey @"numberKey"
#define IDKey     @"IDKey"

#define fetchKey @"fetchKey_"

@implementation XMLocalDataManager


/**
 判断是否有对应汽车的缓存数据
 
 @param qicheid 汽车id
 @return 是否有缓存
 */
+ (BOOL)hasCacheDataForCar:(NSString *)qicheid
{
    NSString *key = [fetchKey stringByAppendingString:qicheid];
    
    id obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    
    if(obj)
    {
        
        XMLOG(@"---------编号为%@的汽车有缓存的位置数据---------",qicheid);
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------编号为%@的汽车有缓存的位置数据---------",qicheid]];

        
        
    
    }else
    {
        XMLOG(@"---------编号为%@的汽车没有魂缓存数据---------",qicheid);
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------编号为%@的汽车没有魂缓存数据---------",qicheid]];

    
    }
    
    return obj ? YES : NO;

}


/**
 根据汽车id，保存对应的缓存数据
 
 @param qicheid 汽车编号
 */
+ (void)saveCacheDataForCar:(NSString *)qicheid data:(NSDictionary *)dic
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    NSString *key = [fetchKey stringByAppendingString:qicheid];
    
    [df setObject:dic forKey:key];
    
    [df synchronize];



}

/**
 根据汽车id取出对应的缓存数据
 
 @param qicheid 汽车编号
 @return 缓存数据
 */
+ (NSDictionary *)fetchCacheDataForCar:(NSString *)qicheid
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    NSString *key = [fetchKey stringByAppendingString:qicheid];
    
    NSDictionary *dic = [df objectForKey:key];
    
    return dic;
    
    
}



















#pragma mark ------- 保存数据
/**
 保存最后定位的时间
 
 @param time 最后定位时间
 */
+ (void)saveLastLocateTime:(NSString *)time
{

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:time forKey:timeKey];
    
    [df synchronize];
    
    
}


/**
 保存最后的司机名称
 
 @param name 司机名称
 */
+ (void)saveLastDriverName:(NSString *)name
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:name forKey:nameKey];
    
    [df synchronize];

}



/**
 保存上一次的经度
 
 @param longitude 经度值
 */
+ (void)saveLastLongitude:(float)longitude
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setFloat:longitude forKey:longKey];
    
    [df synchronize];


}

/**
 保存上一次的纬度值
 
 @param latitude 纬度值
 */
+ (void)saveLastLatitude:(float)latitude
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setFloat:latitude forKey:latKey];
    
    [df synchronize];


}


/**
 保存车牌号码

 @param carNumber chepai号码
 */
+ (void)saveCarNumber:(NSString *)carNumber
{

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:carNumber forKey:numberKey];
    
    [df synchronize];


}

+(void)saveID:(NSString *)ID
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:ID forKey:IDKey];
    
    [df synchronize];


}
#pragma mark ------- 获取数据

/**
 获取最后的定位时间
 
 @return 定位时间
 */
+ (NSString *)getLastLocateTime
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df objectForKey:timeKey];
    

}

/**
 获取最后驾驶的司机名称
 
 @return 司机名称
 */
+ (NSString *)getLastDriverName
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df objectForKey:nameKey];
    
 
}

/**
 获取上一次定位的经度
 
 @return 经度值
 */
+ (float)getLastLongitude
{

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df floatForKey:longKey];
    

}

/**
 获取上一次的纬度值
 
 @return 纬度值
 */
+ (float)getLastLatitude
{
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df floatForKey:latKey];

}

/**
 获取车牌号码

 @return 车牌号码
 */
+ (NSString *)getCarNumber
{
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df objectForKey:numberKey];


}

+ (NSString *)getCarId
{

    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    return [df objectForKey:IDKey];


}
@end
