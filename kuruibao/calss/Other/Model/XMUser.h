//
//  XMAccount.h
//  KuRuiBao
//
//  Created by x on 16/6/22.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
// 面向模型开发

/***********************************************************************************************
 专门用来描述账户信息的模型
 
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>


@interface XMUser : NSObject<NSCoding>


@property (nonatomic, assign) NSInteger companyid;

@property (nonatomic, copy) NSString *carbrandid;

@property (nonatomic, copy) NSString *brandname;

@property (nonatomic, copy) NSString *carstyleid;

@property (nonatomic, copy) NSString *tboxid;

@property (nonatomic, assign) NSInteger userid;//!< 用户编号

@property (nonatomic, copy) NSString *vin;

@property (nonatomic, copy) NSString *carseriesid;

@property (nonatomic, copy) NSString *chepaino;

@property (nonatomic, copy) NSString *password;//!< 密码

@property (nonatomic, copy) NSString *imei;

@property (nonatomic, copy) NSString *registrationid;//!< 推送标示

@property (nonatomic, copy) NSString *qicheid;

@property (nonatomic, assign) NSInteger secretflag;

@property (nonatomic, copy) NSString *seriesname;

@property (nonatomic, copy) NSString *stylename;

@property (nonatomic, assign) NSInteger role_id;

@property (nonatomic, copy) NSString *mobil;//!< 登录名

@property (nonatomic, assign) NSInteger typeId;//!< 用户类别

/**
 *  获取用户模型数据
 *
 *
 */
+ (XMUser *)user ;


/**
 保存用户模型数据 登录的时候需要用户为空的时候保存，其他保存情况需要用户存在时候保存

 @param user 用户对象
 @param exist 用户是否存在
 */
+(void)save:(XMUser *)user whenUserExist:(BOOL)exist;


+ (instancetype)userWithDictionary:(NSDictionary *)dic;


/**
 删除用户数据
 */
+ (void)clearAccount;

/**
 当获取车辆列表的时候，跟新本地数据

 @param array 车辆列表
 */
+ (void)updateLocalUserModel:(NSArray *)array;


@end

