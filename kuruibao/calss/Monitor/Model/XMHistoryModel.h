//
//  XMHistoryModel.h
//  kuruibao
//
//  Created by x on 17/7/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMHistoryModel : NSObject
/**
 创建时间
 */
@property (copy, nonatomic) NSString *time;

/**
 错误码
 */
@property (copy, nonatomic) NSString *errorCode;

@end
