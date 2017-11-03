//
//  XMUnitConvertManager.m
//  kuruibao
//
//  Created by x on 17/8/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//


/***********************************************************************************************
 
 专门处理单位转换业务逻辑的工具类，
 
 ************************************************************************************************/
#import "XMUnitConvertManager.h"

@implementation XMUnitConvertManager


#pragma mark ------- 带单位计算
/**
 将原始的用km计量的数据，转换为用mile计量的数据，并且带“mile”单位，外部不必重复处理
 
 @param sourceDistance 需要转换的公里数
 @return mile数量 并且带单位
 */
+ (NSString *)convertKmToMile:(float)sourceDistance
{
    // 1mile = 1.609公里  1千米(km)=0.6213712英里(mi)

    XMLOG(@"---------%f-------km--",sourceDistance);
    
    float result = sourceDistance * 0.6213712;
    
    return [NSString stringWithFormat:@"%.2f mile",result];


}


/**
 将用升计量的数据，转换成为用Gallon计量的数据，并且带“gallon”单位，外部不用重复处理
 
 @param sourceLitre 用升计量的原始数据，注意：不是公升
 @return gallon数量 并且带单位
 */
+ (NSString *)convertLitreToGallon:(float)sourceLitre
{

    //1升(l)=0.2641721美制加仑(us gal)  1加仑 = 3.79公升
    XMLOG(@"---------%f-------L--",sourceLitre);
    
    float result = sourceLitre * 0.2641721;
    
    return [NSString stringWithFormat:@"%.2f gallon",result];


}

#pragma mark ------- 不带单位计算
/**
 将原始的用km计量的数据，转换为用mile计量的数据，不带“mile”单位，
 
 @param sourceDistance 需要转换的公里数
 @return mile数量 不会带单位
 */
+ (NSString *)convertKmToMileWithoutUnit:(float)sourceDistance
{
    float result = sourceDistance * 0.6213712;
    
    return [NSString stringWithFormat:@"%.2f",result];

}


/**
 将用升计量的数据，转换成为用Gallon计量的数据，不附带“gallon”单位
 
 @param sourceLitre 用升计量的原始数据，注意：1公升 = 1升
 @return gallon数量  不附带单位
 */
+ (NSString *)convertLitreToGallonWithoutUnit:(float)sourceLitre
{
    float result = sourceLitre * 0.2641721;
    
    return [NSString stringWithFormat:@"%.2f",result];

}


/**
 将argL/100km 换算成为 xGallon/100mile 并且带单位（gal/100mile）返回
 
 @param arg 百公里油耗 单位：L/100km
 @return 百公里油耗 单位：gal/100mile
 */
+ (NSString *)litrePer100KMToGallonPer100Mile:(CGFloat)arg
{

    // eg: 12L/100km -> xgallon/100mile 先转换成为多少加仑每多少mile
    float gallon = arg * 0.2641721;
    
    float mile = 100 * 0.6213712;

    float res = gallon / mile * 100;
    
    return [NSString stringWithFormat:@"%.1f gal/100mile",res];



}

#pragma mark ------- 时间转换

/**
 将秒数转换为标准的时间格式
 
 @param time 用秒表示的时间
 @return eg:  12:09:23
 */
+ (NSString *)convertTimeToStandardFormat:(uint)time
{
    int hour = time / 3600;
    
    int sec = time % 60;
    
    int min = (time % 3600) / 60;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hour,min,sec];

 
}

#pragma mark ------- 温度转换

/**
 摄氏度转换为华氏度    水温 1摄氏度(℃)=33.8华氏度(℉)

 @param tem 摄氏度
 @return 华氏度
 */
+ (NSString *)convertTemperatureToF:(CGFloat)tem
{
    float resTem = tem * (190.4/88);
    
    return [NSString stringWithFormat:@"%0.2f °F",resTem];

}

@end
