//
//  XMDateManager.h
//  kuruibao
//
//  Created by x on 17/8/25.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 destination：对时间进行管理和转换
 
 ************************************************************************************************/

#import <Foundation/Foundation.h>

@interface XMDateManager : NSObject

/**
 获取当前时间字符串，用英文替换月份

 @return 月份显示为英文的字符串
 */
+ (NSString *)getCurrentDateString;


/**
 将用英文表示月份的时间转换为时间对象 2017-August-12

 @param time 月份为英文的时间字符串
 @return 字符串对应的时间对象
 */
+ (NSDate *)convertStringToDate:(NSString *)time;



/**
 将开始时间或者结束时间转换为date对象

 @param time 开始时间字符串/结束时间字符串
 @return 开始/结束时间对应的日期对象
 */
+ (NSDate *)convertStartTimeString:(NSString *)time;


/**
 将正常的时间字符串转换为月份是英文显示的字符串 2017-05-27 -> May-27-2017

 @param timeStr 年月日的时间字符串 yyyy-MM-dd
 @return 月份为英文的时间字符串
 */
+ (NSString *)convertTimeToEnglishMonth:(NSString *)timeStr;

@end
