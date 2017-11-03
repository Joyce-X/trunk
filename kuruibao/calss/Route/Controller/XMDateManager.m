//
//  XMDateManager.m
//  kuruibao
//
//  Created by x on 17/8/25.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMDateManager.h"

@implementation XMDateManager


//!< 获取当前日期
+ (NSString *)getCurrentDateString
{
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd";
    
    NSDate * now = [NSDate date];
    
    NSString *timeStr = [df stringFromDate:now];
    
    NSArray *arr = [timeStr componentsSeparatedByString:@"-"];
    
    NSInteger month = [arr[1] integerValue];
    
    NSString *monthStr;
    
    switch (month) {
        case 1:
            
            monthStr = @"January";
            
            break;
        case 2:
            
            monthStr = @"February";
            
            break;
        case 3:
            
            monthStr = @"March";
            
            break;
        case 4:
            
            monthStr = @"April";
            
            break;
        case 5:
            
            monthStr = @"May";
            
            break;
        case 6:
            
            monthStr = @"June";
            
            break;
        case 7:
            
            monthStr = @"July";
            
            break;
        case 8:
            
            monthStr = @"August";
            
            break;
        case 9:
            
            monthStr = @"September";
            
            break;
        case 10:
            
            monthStr = @"October";
            
            break;
        case 11:
            
            monthStr = @"November";
            
            break;
        case 12:
            
            monthStr = @"December";
            
            break;
            
        default:
            break;
    }
    
    NSString *result = [timeStr stringByReplacingCharactersInRange:NSMakeRange(5, 2) withString:monthStr];
    
    return result;
    
}

 

/**
 将用英文表示月份的时间转换为时间对象 2017-August-12
 
 @param time 月份为英文的时间字符串
 @return 字符串对应的时间对象
 */
+ (NSDate *)convertStringToDate:(NSString *)time
{
    
    
    NSArray *arr = [time componentsSeparatedByString:@"-"];
    
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd";

    NSString *month = arr[1];
    
    //!< 月份转换为数字
    NSArray *months = @[@"January",@"February",@"March",@"April",@"May",@"June",@"July",@"August",@"September",@"October",@"November",@"December"];
    
    NSInteger number = 0;
    
    for (NSString *str in months)
    {
        if ([str isEqualToString:month])
        {
            NSInteger index = [months indexOfObject:str];
            
            number = index + 1;
            break;
        }
    }
    
    NSString *result = [NSString stringWithFormat:@"%04ld-%02ld-%02ld",(long)[arr[0] integerValue],(long)number,(long)[arr[2] integerValue]];
    
    NSDate *date = [df dateFromString:result];
    
    return date;


}

 
/**
 将开始时间或者结束时间转换为date对象
 
 @param time 开始时间字符串/结束时间字符串
 @return 开始/结束时间对应的日期对象
 */
+ (NSDate *)convertStartTimeString:(NSString *)time
{
    NSArray *arr = [time componentsSeparatedByString:@":"];
    
    int hour = [arr[0] intValue];
    
    int minute = [arr[1] intValue];

    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    
    //!< 年份随便给，主要用到的是小时和分钟
    NSString *result = [NSString stringWithFormat:@"2017-10-10 %02d:%02d",hour,minute];
    
    NSDate *date = [df dateFromString:result];
    
    return date;


}

/**
 将正常的时间字符串转换为月份是英文显示的字符串 2017-05-27 -> May-27-2017
 
 @param timeStr 年月日的时间字符串 yyyy-MM-dd
 @return 月份为英文的时间字符串
 */
+ (NSString *)convertTimeToEnglishMonth:(NSString *)timeStr
{
    NSArray *arr = [timeStr componentsSeparatedByString:@"-"];
    
    int month = [arr[1] intValue];
    
    NSString *monthStr;
    
    switch (month) {
        case 1:
            
            monthStr = @"January";
            
            break;
        case 2:
            
            monthStr = @"February";
            
            break;
        case 3:
            
            monthStr = @"March";
            
            break;
        case 4:
            
            monthStr = @"April";
            
            break;
        case 5:
            
            monthStr = @"May";
            
            break;
        case 6:
            
            monthStr = @"June";
            
            break;
        case 7:
            
            monthStr = @"July";
            
            break;
        case 8:
            
            monthStr = @"August";
            
            break;
        case 9:
            
            monthStr = @"September";
            
            break;
        case 10:
            
            monthStr = @"October";
            
            break;
        case 11:
            
            monthStr = @"November";
            
            break;
        case 12:
            
            monthStr = @"December";
            
            break;
            
        default:
            break;
    }


    return [NSString stringWithFormat:@"%@-%@-%@",monthStr,arr[2],arr[0]];


}

@end
