//
//  XMMessageModel.h
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMMessageModel : NSObject

/**
 消息内容
 */
@property (copy, nonatomic) NSString *message;


/**
 时间
 */
@property (copy, nonatomic) NSString *happentime;

@end
