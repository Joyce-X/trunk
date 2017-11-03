//
//  XMInfoManager.h
//  kuruibao
//
//  Created by x on 17/9/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 管理没有网的时候的用户数据
 
 ************************************************************************************************/

#import <Foundation/Foundation.h>

@interface XMInfoManager : NSObject

/**
 用户是否存过数据
 */
@property (assign, nonatomic) BOOL flag;

/**
 用户昵称
 */
@property (copy, nonatomic) NSString *nickName;


/**
 用户头像数据
 */
@property (strong, nonatomic) NSData *profileData;

/**
 用户心情
 */
@property (copy, nonatomic) NSString *mood;


/**
 用户性别
 */
@property (copy, nonatomic) NSString *sex;

/**
 用户生日
 */
@property (copy, nonatomic) NSString *birthday;

/**
 用户位置
 */
@property (copy, nonatomic) NSString *region;


/**
 更新用户数据
 */
- (void)updateUserInfo:(NSDictionary *)infoDic;

@end
