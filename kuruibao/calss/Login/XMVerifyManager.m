//
//  XMVerifyManager.m
//  kuruibao
//
//  Created by x on 17/8/3.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMVerifyManager.h"

@implementation XMVerifyManager

//#define area 0  //1 代表美国，0 代表中国

//#define area 1  //1 代表美国，0 代表中国

/**
 *  说明：1 上边的两个宏，一个用来在美国发布，一个用来在中国测试，为了方便测试，暂时不使用宏来限制，等美国测试完成之后，没有什么问题的话，再使用宏来限定区域为美国
         2 暂定逻辑为：判定传进来的电话号码长度，如果长度等于10 的话，就当做美国号码来进行判定，否则就当中国号码来进行判定。----此逻辑仅用于测试阶段
 */

+ (BOOL)verifyAreaCode:(NSString *)phoneNumber
{
    
    if (phoneNumber.length == 0) return NO;
    
    //!< 在每次验证之前，将需要验证的数据，保存到msg中
    XMMike *mike = [XMMike shareMike];
    
    [XMMike addLogs:[NSString stringWithFormat:@"美国手机设定长度:%ld，是否开启中国手机号码验证%@，是否开启区域码验证：%@，需要验证的手机号码：%@",mike.americaPhoneNumberLength,mike.verifyChinaPhoneNumber ? @"是" : @"否",mike.verifyAmericaAreaCode ? @"是" : @"否",phoneNumber]];

    
    
    /**
     *  两条大横线之间是为美国暂定的逻辑，后期修改
     */
    
    //-----------------------------seperate line---------------------------------------//
    
    if (mike.verifyChinaPhoneNumber == NO)
    {
        //!< 验证中国手机号码功能关闭，只需要验证美国手机号码
        return [self onlyVerifyAmericaPhoneNumber:phoneNumber];
        
        
    }else
    {
    
        //!< 需要验证中国电话号码
        if (mike.americaPhoneNumberLength == 11)
        {
            //!< 美国电话号码为11位，则不再对中国电话号码进行验证，只验证美国电话号码
            return [self onlyVerifyAmericaPhoneNumber:phoneNumber];
            
        }else
        {
        
            //!< 美国电话号码不为11位，则对中国电话号码进行验证
            if (phoneNumber.length == 11)
            {
                //!< 判定为中国电话号码
                NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
                
                NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
                
                return [phoneTest evaluateWithObject:phoneNumber];
                
            }else
            {
            
                //!< 美国号码长度不为11位
                if (mike.americaPhoneNumberLength == phoneNumber.length)
                {
                    //!< 长度符合美国号码长度，则判定为美国号码
                    return [self onlyVerifyAmericaPhoneNumber:phoneNumber];
                    
                }else
                {
                    
                    //!< 都不符合，
                    return NO;
                
                }
            
            }
        
        }
        
    
    }
    
    
    
    return NO;
    //-----------------------------seperate line---------------------------------------//
    
    BOOL area  = NO;
    
    if(phoneNumber.length == 10)
    {
        
        //!< 长度为单例设置的数值 ，暂定为用户传进来的是美国的手机号码，否则判定为用户输入的是中国的电话号码，需要注意在发送验证码的时候的国家前缀进行判定
        area = YES;
    
    }else if (phoneNumber.length == 11)
    {
        //!< 长度为11 暂定用户传进来的是中国手机号码
        area = NO;
    
    }else
    {
    
        //!< 如果长度不为11 且不为10 则返回no，则任伟号码格式不正确，直接返回NO
        XMLOG(@"---------Joyce 验证失败，手机号码长度为%ld, 被判定为不合法的手机号码---------",phoneNumber.length);
        return NO;
    
    }
    
    if (area) {
        
         //!< 判断区域码是否合法
        NSString *areaCode = [phoneNumber substringToIndex:3];//!< 区域码
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AreaCode_US.plist" ofType:nil];
        
        NSArray *codes = [NSArray arrayWithContentsOfFile:path];
       
        BOOL contain = NO;
        
        for (NSString *code in codes)
        {
            
            if ([areaCode isEqualToString:code])
            {
                contain = YES;//!< 合法的区域码
                break;
            }
            
        }
       
        if (contain) {
            
           
            XMLOG(@"--------- Joyce 有效区域码---------");
             return YES;
            
        }else
        {
            
            XMLOG(@"--------- Joyce 无效区域码---------");
            
            return NO;
        }
        
        
    }else
    {
        //!< 为了测试国内账号设计
        //   手机号以13， 15，18开头，八个 \d 数字字符
        
            NSString *phoneRegex = @"^((13[0-9])|(17[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
        
            NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
        
            return [phoneTest evaluateWithObject:phoneNumber];
        
    }
    
    return YES;

}

/**
 只验证美国电话号码

 @param number 电话号码
 @return 是否符合格式
 */
+ (BOOL)onlyVerifyAmericaPhoneNumber:(NSString *)number
{
    //!< 验证美国电话号码，判断是否需要验证区域码
    if ([XMMike shareMike].verifyAmericaAreaCode == NO)
    {
        //!< 不需要验证区域码
       return  [self onlyVerifyAmericaPhoneNumberWithoutAreaCode:number];
        
    }else
    {
        //!< 需要验证区域码
        return  [self onlyVerifyAmericaPhoneNumberNeedAreaCode:number];

        
    }
    
    return NO;
}

/**
 验证美国手机号码不需要验证区域码

 @param number
 @return
 */
+ (BOOL)onlyVerifyAmericaPhoneNumberWithoutAreaCode:(NSString *)number
{
    //!< 不需要验证区域码，则只需要判断长度是否等于单例长度即可
    if([XMMike shareMike].americaPhoneNumberLength == number.length)
    {
        //!< 合法
        return YES;
    
    }else
    {
        
        //!< 不合法
        return NO;
    
    }
    
    
    //!< 马来西亚逻辑
//    if (number.length == 10 || number.length == 11)
//    {
//        return YES;
//    }else
//    {
//        return NO;
//    }
}

/**
 验证美国手机号码需要验证区域码
 
 @param number
 @return
 */
+ (BOOL)onlyVerifyAmericaPhoneNumberNeedAreaCode:(NSString *)number
{
    
    //!< 需要验证区域码，首先验证长度
     if([XMMike shareMike].americaPhoneNumberLength == number.length)
    {
        //!< 合法 继续验证区域码
        //!< 判断区域码是否合法
        NSString *areaCode = [number substringToIndex:3];//!< 区域码
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"AreaCode_US.plist" ofType:nil];
        
        NSArray *codes = [NSArray arrayWithContentsOfFile:path];
        
        BOOL contain = NO;
        
        for (NSString *code in codes)
        {
            
            if ([areaCode isEqualToString:code])
            {
                contain = YES;//!< 合法的区域码
                break;
            }
            
        }
        
        if (contain) {
            
            
            XMLOG(@"--------- Joyce 有效区域码---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"--------- Joyce 有效区域码---------"]];

            return YES;
            
        }else
        {
            
            XMLOG(@"--------- Joyce 无效区域码---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"--------- Joyce 无效区域码---------"]];

            
            return NO;
        }

        
    }else
    {
        
        //!< 不合法
        return NO;
        
    }
    
    return NO;
}


+ (BOOL)verifyPasswordValid:(NSString *)password
{
    if(password.length < 6)
    {
        return NO;//!< 少于6位，不合法
    }
    
    BOOL hasChar = NO;
    
    BOOL hasNum = NO;
    
    //!< 遍历字符串，判断是否有字符
    for (int i = 0; i<password.length; i++)
    {
        char name = [password characterAtIndex:i];
        
        if ((name>= 'A' && name <= 'Z') || (name>= 'a' && name <= 'z'))
        {
            hasChar = YES;
        }
        
        if (name <= 57 && name >= 48)
        {
            hasNum = YES;
        }
        
        
            
        
    }
    
    if (hasNum && hasChar)
    {
        return YES;
    }
  
    return NO;
}



















@end
