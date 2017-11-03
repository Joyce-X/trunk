//
//  XMSystemMessageModel.m
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMSystemMessageModel.h"

@implementation XMSystemMessageModel


- (void)setCreatetime:(NSString *)createtime
{

    //!<去掉时间中的毫秒
    NSString *tempStr = createtime;
    
    if ([createtime containsString:@"."])
    {
        //!< 如果包含"." 则说明带有毫秒，删掉毫秒部分
        NSRange range = [createtime rangeOfString:@"."];

        tempStr = [createtime substringToIndex:range.location];
        
    }
    
    
    //!< 替换分隔符
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    if (tempStr.length < 19)
    {
        _createtime = @"";
        
        XMLOG(@"---------服务器返回时间错误---------");
        
        return;
    }
    
    
    NSDateFormatter *df = [NSDateFormatter new];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    
    df.timeZone = [NSTimeZone timeZoneWithName:@"America/New_York"];
    
    NSDate *data_us = [df dateFromString:tempStr];

    df.timeZone = nil;//!< 设置为系统时区
    
    NSString * res = [df stringFromDate:data_us];
    
    _createtime = res;
    

}

@end
