//
//  XMCreater.m
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCreater.h"

@implementation XMCreater

+ (UILabel *)createLabeWithColor:(UIColor *)color font:(float)font text:(NSString *)text bold:(BOOL)isBold
{

    UILabel *label = [UILabel new];
    
    label.text = text;
    
    if (color == nil)
    {
        color = XMWhiteColor;//!< default is F8F8F8
        label.textAlignment = NSTextAlignmentCenter;

        
    }
    
      label.textColor = color;
    
    
    font = font < 10 ? 15 : font;//!< set min font size is 10
    
    if (isBold)
    {
        label.font = [UIFont boldSystemFontOfSize:font];
    }else
    {
        label.font = [UIFont systemFontOfSize:font];
    }
    
    //!< calculate the width of text
    CGSize size = [text sizeWithAttributes:@{NSFontAttributeName : label.font}];
    
    CGFloat width = ceil(size.width);
    
    label.tag = (NSInteger)(width + 1);
    
    return label;

}



#pragma mark -------------- tool method

//!< 获取当前日期
+ (NSString *)getCurrentDateWitgTimeType:(XMTimeType)type timeStr:(NSString *)timeStr
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDate *now;
    
    //    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSDateComponents *comps;
    NSInteger unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday |
    NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    //
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd";
    
    if (timeStr)
    {
        //!< 有传时间就用传来的时间
        now = [df dateFromString:timeStr];
        
    }else
    {
        //!< 没有传时间就默认为当前时间
        now=[NSDate date];
        
    }
    
    comps = [calendar components:unitFlags fromDate:now];
    
    NSInteger year = [comps year];
    
    NSInteger  month = [comps month];
    
    NSInteger  day = [comps day];
    
    
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
    
    
    if (type == XMTimeTypeDay)//!< dayBtn
    {
        
        return [NSString stringWithFormat:@"%ld",(long)day];
        
    }else if(type == XMTimeTypeAll)//!< 标题
    {
        return [NSString stringWithFormat:@"%ld-%@-%ld",(long)year,monthStr,(long)day];
        
    }else if(type == XMTimeTypeFormatter)//!< 请求数据做参数是用
    {
        
        return [df stringFromDate:now];
        
        
    }else
    {
        return nil;
    }
}

/**
 *   判断第一个时间是否大于第二个时间
 */
+ (BOOL)judgeString:(NSString *)str1 earlierThanString:(NSString *)str2
{
    if(str2.length != 5 || str1.length != 5 || ![str1 containsString:@":"] || ![str2 containsString:@":"]){
    
        //!< 长度不一样，没有分割
        XMLOG(@"---------无效字符串---------");
        
        [XMMike addLogs:@"---------无效字符串---------"];


        return NO;
    }
    
    NSArray *arr1 = [str1 componentsSeparatedByString:@":"];
    int hour1 = [arr1.firstObject intValue];
    int minute1 = [arr1.lastObject intValue];
    
    NSArray *arr2 = [str2 componentsSeparatedByString:@":"];
    int hour2 = [arr2.firstObject intValue];
    int minute2 = [arr2.lastObject intValue];
    
    if (hour1 > hour2)
    {
        //!< 小时大于小时
        return NO;
        
    }else if(hour2 == hour1)
    {
     
//        //!<小时相等，判断分钟
//        if(minute1 % 5 != 0)
//        {
//            //!< 出现这种情况是picker没有滚动，系统给出当前的时间，下同
//            minute1 = minute1 - (minute1 % 5);
//        
//        }
//        if(minute2 % 5 != 0)
//        {
//            //!< 出现这种情况是picker没有滚动，系统给出当前的时间，下同
//            minute2 = minute2 - (minute2 % 5);
//            
//        }
        
        if (minute1 < minute2)
        {
            return YES;
        }else{
        
            //!< 等于大于就返回NO;
            
            return NO;
         
        }
        
     }else
    {
        return YES;
    
    }
   
}

/**
 *   判断目标字符串表示的时间是否在制定的字符串区域内
 */

+ (BOOL)judgeString:(NSString *)desStr withinStr:(NSString *)str1 andStr:(NSString *)str2
{
    
    if(desStr.length == 0)
    {

        XMLOG(@"---------传进无效字符串，时间解析失败---------");
        
        [XMMike addLogs:@"---------传进无效字符串，时间解析失败---------"];

        return NO;
    
    }
    
    NSArray *arr1 = [str1 componentsSeparatedByString:@":"];
    int hour1 = [arr1.firstObject intValue];
    int minute1 = [arr1.lastObject intValue];
    
    NSArray *arr2 = [str2 componentsSeparatedByString:@":"];
    int hour2 = [arr2.firstObject intValue];
    int minute2 = [arr2.lastObject intValue];

    //!<校正时间
//    if(minute1 % 5 != 0)
//    {
//        //!< 出现这种情况是picker没有滚动，系统给出当前的时间，下同
//        minute1 = minute1 - (minute1 % 5);
//        
//    }
//    if(minute2 % 5 != 0)
//    {
//        //!< 出现这种情况是picker没有滚动，系统给出当前的时间，下同
//        minute2 = minute2 - (minute2 % 5);
//        
//    }
    
    //!< 取出目标时间段
    NSString *destinationStr = [desStr componentsSeparatedByString:@"T"].lastObject;
    
    NSArray *arr3 = [destinationStr componentsSeparatedByString:@":"];
    
    int desHour = [arr3.firstObject intValue];
    
    int desMinute = [arr3[1] intValue];
    
    if (desHour < hour1 || desHour > hour2)
    {
        //!< 小于最小，大于最大 不在区间内
        return NO;
        
    }else if(desHour == hour1)
    {
        //!< 和最小的小时相同，进行分钟判定
        if (desMinute >= minute1 && desMinute <= minute2)
        {
            return YES;
        }else
        {
            return NO;
        }
    
    }else if (desHour == hour2)
    {
        //!< 和最大的小时时间相同，进行分钟的判定
        if (desMinute >= minute1 && desMinute <= minute2)
        {
            return YES;
        }else
        {
            return NO;
        }
    
    }else
    {
        //!< 小时>最小，小于最大，在区间内
    
        return YES;
    
    }
    
    
}

//+ (NSString *)handleWithStr:(NSString *)desStr
//{
//    NSArray *arr2 = [desStr componentsSeparatedByString:@":"];
//    int hour2 = [arr2.firstObject intValue];
//    int minute2 = [arr2.lastObject intValue];
//    
//    //!<校正时间
//    if(minute2 % 5 != 0)
//    {
//        //!< 出现这种情况是picker没有滚动，系统给出当前的时间，下同
//        minute2 = minute2 - (minute2 % 5);
//        
//        return [NSString stringWithFormat:@"%d:%d",hour2,minute2];
//    }else
//    {
//        return desStr;
//    }
//    
//   
//
//}

@end
