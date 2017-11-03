//
//  XMVerifyManager.h
//  kuruibao
//
//  Created by x on 17/8/3.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//


/***********************************************************************************************
 
在登录模块，处理一些验证的逻辑
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>

@interface XMVerifyManager : NSObject


/**
 用于验证美国电话号码前三位的区域码是否合法

 @param phoneNumber 电话号码
 @return 是否合法
 */
+ (BOOL)verifyAreaCode:(NSString *)phoneNumber;



/**
 用来判断密码是否合法
 判断规则：至少有一个字母 至少也要有一个数字

 @param password 密码
 @return 是否符合规则
 */
+ (BOOL)verifyPasswordValid:(NSString *)password;

@end
