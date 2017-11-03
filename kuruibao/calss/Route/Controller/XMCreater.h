//
//  XMCreater.h
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

//!< 获取时间类型
typedef NS_ENUM(NSUInteger, XMTimeType) {
    XMTimeTypeAll,//!< 当前年月日yyyy年MM月dd日
    XMTimeTypeDay,//!< 当前是几号
    XMTimeTypeFormatter//yyyy-MM-dd
};

@interface XMCreater : NSObject


/**
 创建label,alignment default is center

 @param color 颜色 默认F8F8F8
 @param font 字体大小
 @param text 文字内容
 @param isBold 是否加粗
 @return instance
 */
+ (UILabel *)createLabeWithColor:(UIColor *)color font:(float)font text:(NSString *)text bold:(BOOL)isBold;

/**
 获取当前时间

 @param type 获取时间的类型
 @param timeStr
 @return 时间字符串
 */
+ (NSString *)getCurrentDateWitgTimeType:(XMTimeType)type timeStr:(NSString *)timeStr;

/**
 判断第一个字符串时间是否小于第二个时间字符串

 @param str1 字符串1
 @param str2 字符串2
 @return 1是否大于2
 */
+ (BOOL)judgeString:(NSString *)str1 earlierThanString:(NSString *)str2;

/**
 判断目标字符串表示的时间是否在制定的字符串区域内

 @param desStr 目标字符串
 @param str1 时间起点
 @param str2 时间终点
 @return 是否在区间内
 */
+ (BOOL)judgeString:(NSString *)desStr withinStr:(NSString *)str1 andStr:(NSString *)str2;

/**
 对时间进行优化，系统时间可能会返回不是整点的时间，

 @param desStr 可能格式：13：24；
 @return 调整到分数可以被5整除，符合选择时间的样式
 */
+ (NSString *)handleWithStr:(NSString *)desStr;
@end
