//
//  XMDashPalManager.h
//  kuruibao
//
//  Created by x on 17/8/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMDashPalManager : NSObject



/**
 用户的昵称
 */
@property (copy, nonatomic) NSString *userNickName;

/**
 车牌号码
 */
@property (copy, nonatomic) NSString *carNumber;


/**
 获取单例对象

 @return 返回单例
 */
+ (instancetype)shareManager;

@end
