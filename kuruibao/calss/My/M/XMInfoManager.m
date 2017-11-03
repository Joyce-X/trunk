//
//  XMInfoManager.m
//  kuruibao
//
//  Created by x on 17/9/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMInfoManager.h"

#define userInfo_nickName  @"userInfo_nickName" //用户昵称

#define userInfo_profileData  @"userInfo_profileData" // 用户头像数据

#define userInfo_mood  @"userInfo_mood" //  用户心情

#define userInfo_sex  @"userInfo_sex" // 用户性别

#define userInfo_birthday  @"userInfo_birthday" // 用户生日

#define userInfo_region  @"userInfo_region" // 用户位置

#define userInfo_flag @"userInfo_flag" //标志是否存过数据 BOOL类型

@implementation XMInfoManager

- (instancetype)init
{

    self = [super init];
    
    if (self)
    {
         NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
        
        self.flag = [df boolForKey:userInfo_flag];
        
        if (self.flag)
        {
            XMLOG(@"---------存有数据---------");
             self.nickName = [df objectForKey:userInfo_nickName];
            
             self.profileData = [df objectForKey:userInfo_profileData];
            
             self.sex = [df objectForKey:userInfo_sex];
            
             self.mood = [df objectForKey:userInfo_mood];
            
             self.birthday = [df objectForKey:userInfo_birthday];
            
             self.region = [df objectForKey:userInfo_region];
            
            
        }else
        {
            
            XMLOG(@"---------没有存过数据---------");
       
        
        }
        
        
        
    }
    
    return self;


}


/**
 更新用户数据
 */
- (void)updateUserInfo:(NSDictionary *)infoDic
{
    
    
    
    NSArray *arr = infoDic[@"data"];
    
    if (![arr isKindOfClass:[NSArray class]])
    {
        return;
    }
    
    NSDictionary *dic = arr.firstObject;

    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    [df setObject:dic[@"sex"] forKey:userInfo_sex];//!< 更新性别
    
    [df setObject:dic[@"signname"] forKey:userInfo_mood];//!< 更新签名
    
    [df setObject:dic[@"nickname"] forKey:userInfo_nickName];//!< 更新昵称
    
    [df setObject:dic[@"birthday"] forKey:userInfo_birthday];//!< 更新生日
    
    [df setObject:dic[@"userarea"] forKey:userInfo_region];//!< 更新地区
    
    [df setBool:YES forKey:userInfo_flag];
    
    [df synchronize];
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"userimage"]]];
       
       [df setObject:data forKey:userInfo_profileData];
       
       [df synchronize];
       
   });
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    



}
@end
