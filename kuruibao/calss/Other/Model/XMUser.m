//
//  XMAccount.m
//  KuRuiBao
//
//  Created by x on 16/6/22.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMUser.h"

#import "XMCar.h"

@implementation XMUser



- (void)encodeWithCoder:(NSCoder *)encoder
{
    //-- 序列化
    
    [encoder encodeInteger:self.companyid forKey:@"companyid"];
    [encoder encodeInteger:self.typeId forKey:@"typeId"];
    [encoder encodeInteger:self.role_id forKey:@"role_id"];
    [encoder encodeInteger:self.secretflag forKey:@"secretflag"];
    [encoder encodeInteger:self.userid forKey:@"userid"];

    
    [encoder encodeObject:self.tboxid forKey:@"tboxid"];
    [encoder encodeObject:self.carstyleid forKey:@"carstyleid"];
    [encoder encodeObject:self.brandname forKey:@"brandname"];
    [encoder encodeObject:self.carbrandid forKey:@"carbrandid"];
    [encoder encodeObject:self.mobil forKey:@"mobil"];
    [encoder encodeObject:self.stylename forKey:@"stylename"];
    [encoder encodeObject:self.seriesname forKey:@"seriesname"];
    [encoder encodeObject:self.qicheid forKey:@"qicheid"];
    [encoder encodeObject:self.registrationid forKey:@"registrationid"];
    [encoder encodeObject:self.imei forKey:@"imei"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeObject:self.chepaino forKey:@"chepaino"];
    [encoder encodeObject:self.vin forKey:@"vin"];
    [encoder encodeObject:self.carseriesid forKey:@"carseriesid"];
    

}
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder
{
    //-- 反序列化
    self = [super init];
    if (self)
    {
        
         self.companyid = [aDecoder decodeIntegerForKey:@"companyid"];
         self.typeId = [aDecoder decodeIntegerForKey:@"typeId"];
         self.role_id = [aDecoder decodeIntegerForKey:@"role_id"];
         self.secretflag = [aDecoder decodeIntegerForKey:@"secretflag"];
         self.userid = [aDecoder decodeIntegerForKey:@"userid"];
        
        
        self.tboxid = [aDecoder decodeObjectForKey:@"tboxid"];
        self.brandname = [aDecoder decodeObjectForKey:@"brandname"];
        self.carbrandid = [aDecoder decodeObjectForKey:@"carbrandid"];
        self.mobil = [aDecoder decodeObjectForKey:@"mobil"];
        self.stylename = [aDecoder decodeObjectForKey:@"stylename"];
        
        
        self.seriesname = [aDecoder decodeObjectForKey:@"seriesname"];
        self.qicheid = [aDecoder decodeObjectForKey:@"qicheid"];
        self.registrationid = [aDecoder decodeObjectForKey:@"registrationid"];
        self.imei = [aDecoder decodeObjectForKey:@"imei"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
        
        
        
        self.chepaino = [aDecoder decodeObjectForKey:@"chepaino"];
        self.vin = [aDecoder decodeObjectForKey:@"vin"];
        self.carseriesid = [aDecoder decodeObjectForKey:@"carseriesid"];
        self.carstyleid = [aDecoder decodeObjectForKey:@"carstyleid"];
        
    }
    
    return self;
}

+ (XMUser *)user
{
    
    
     BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:ACCOUNTPATH];
    
    XMUser *account = nil;
    
    if (isExist)
    {
        account = [NSKeyedUnarchiver unarchiveObjectWithFile:ACCOUNTPATH];
    }
    
    return account;
    
}

+(void)save:(XMUser *)user whenUserExist:(BOOL)exist
{
    
    //exist 标志用户信息是否存在的情况下，对数据进行保存
 
    //!< 判断用户信息是否存在
    BOOL hasUser = [[NSFileManager defaultManager] fileExistsAtPath:ACCOUNTPATH];
    
    if(exist)
    {
        //!< 需要在用户存在的情况下，保存用户数据
        if(hasUser)
        {
            //!< 用户存在，保存数据
             [NSKeyedArchiver archiveRootObject:user toFile:ACCOUNTPATH];
            
        }else
        {
            
            //!< 用户不存在，不保存数据
            XMLOG(@"---------Joyce 有线程想要保存数据，但是用户不存在，所以保存失败---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------Joyce 有线程想要保存数据，但是用户不存在，所以保存失败---------"]];

            
        }
    
    }else
    {
        //!< 需要在用户不存在的情况下保存数据
        if(hasUser)
        {
            //!< 用户存在，不保存数据
            XMLOG(@"---------有线程想要保存数据，但是用户存在，保存失败，Joyce---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------有线程想要保存数据，但是用户存在，保存失败，Joyce---------"]];

        
        }else
        {
         
            //!< 用户不存在，保存数据
             [NSKeyedArchiver archiveRootObject:user toFile:ACCOUNTPATH];
        }
    
    
    }
    
    
    
  
    
 
    
}

/**
 删除用户数据
 */
+ (void)clearAccount
{

    //!< 删除用户数据后，依旧有线程在保存用户数据，导致用户数据有时候，不能完全清除掉，
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:ACCOUNTPATH];
    
    if (exist)
    {
        NSError *error;
        
        [[NSFileManager defaultManager] removeItemAtPath:ACCOUNTPATH error:&error];
        
        if (error)
        {
            XMLOG(@"---------删除用户信息失败，失败原因%@---------",error);
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------删除用户信息失败，失败原因%@---------",error]];

        }else
        {
            
            XMLOG(@"---------删除用户信息成功---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------删除用户信息成功---------"]];

            
        }
    }
    
   
    
    
}

+ (instancetype)userWithDictionary:(NSDictionary *)dic
{
    
    //-- 消除字典中的NSNull
    NSMutableDictionary *dic_M = [NSMutableDictionary dictionaryWithCapacity:dic.allKeys.count];
    
    for (NSString *key in dic.allKeys)
    {
        id obj = [dic objectForKey:key];
        
        if ([obj isKindOfClass:[NSNull class]])
        {
            obj = @"";
        }
        
        [dic_M setObject:obj forKey:key];
    }
    
    
    
    return [[self alloc]initWithDictionary:dic_M];


}

- (instancetype)initWithDictionary:(NSDictionary *)dic

{
    self = [super init];
    if (self)
    {
        self.userid = [dic[@"userid"] integerValue];
        self.mobil = dic[@"mobil"];
        self.registrationid = dic[@"registrationid"];
        self.password = dic[@"password"];
        self.typeId = [dic[@"typeid"] integerValue];
        self.role_id = [dic[@"role_id"] integerValue];
        self.companyid = [dic[@"companyid"] integerValue];
        self.qicheid = dic[@"qicheid"];
        self.tboxid = dic[@"tboxid"];
        self.chepaino = dic[@"chepaino"];
        self.imei = dic[@"imei"];
        self.vin = dic[@"vin"];
        self.carbrandid = dic[@"carbrandid"];
        self.carseriesid = dic[@"carseriesid"];
        self.carstyleid = dic[@"carstyleid"];
        self.secretflag = [dic[@"secretflag"] integerValue];
        self.brandname = dic[@"brandname"];
        self.seriesname = dic[@"seriesname"];
        self.stylename = dic[@"stylename"];
        
       
        
        
    }
    
    return self;

}

/**
 @property (nonatomic, assign) NSInteger isfirst;//!< 是否为默认车辆
 
 @property (nonatomic, assign) NSInteger carstyleid;//!<款式编号
 
 @property (nonatomic, assign) NSInteger tboxid;//!<绑定的设备号----
 
 @property (nonatomic, assign) NSInteger userid;//!< 用户编号----
 
 @property (nonatomic, copy) NSString *brandname;//!< 品牌---
 
 @property (nonatomic, assign) NSInteger carseriesid;//!< 车系编号
 
 @property (nonatomic, copy) NSString *chepaino;//!< 车牌号码----
 
 @property (nonatomic, copy) NSString *stylename;//!< 款号----
 
 @property (nonatomic, copy) NSString *imei;//!< 车辆绑定的imei----
 
 @property (nonatomic, copy) NSString *seriesname;//!< 车系名称---
 
 @property (nonatomic, assign) NSInteger uqid;//!< 未知
 
 @property (nonatomic, assign) NSInteger qicheid;//!< 汽车编号---
 
 @property (nonatomic, assign) NSInteger carbrandid;//!< 品牌编号

 
 
 
 
 
 @property (nonatomic, copy) NSString *tboxid;
 
 @property (nonatomic, copy) NSString *chepaino;
 
 @property (nonatomic, copy) NSString *imei;
 
 
 @property (nonatomic, copy) NSString *qicheid;
 
 
 
 
 
  
 */

/**
 当获取车辆列表的时候，跟新本地数据
 
 @param array 车辆列表
 */
+ (void)updateLocalUserModel:(NSArray *)array
{
    XMUser *user = [XMUser user];
    
//    XMLOG(@"Joyce qian---------%@---------",user);
    
    for (XMCar *car in array)
    {
        if (car.isfirst)
        {
            //!< 修改本地数据为默认车辆的数据
            user.tboxid = [NSString stringWithFormat:@"%ld",car.tboxid];
            
            user.chepaino = car.chepaino;
            
            user.imei = car.imei;
            
            user.qicheid = [NSString stringWithFormat:@"%ld",car.qicheid];
            
        }
    }

    [self save:user whenUserExist:YES];
    
//     XMLOG(@"Joyce hou---------%@---------",user);

}
@end


