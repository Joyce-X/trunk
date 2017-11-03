//
//  XMSystemMessageModel.h
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMSystemMessageModel : NSObject

@property (assign, nonatomic) NSInteger pushid;

@property (copy, nonatomic) NSString *pushmessage;

@property (copy, nonatomic) NSString *imgUrl;

@property (copy, nonatomic) NSString *ToUrl;

@property (copy, nonatomic) NSString *createtime;
@end
