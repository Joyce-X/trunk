//
//  XMRealTimeMonitorController.h
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleController.h"

#import "XMBaiduLocationModel.h"

@interface XMRealTimeMonitorController : XMMiddleController

/**
 需要传递的数据模型
 */
@property (strong, nonatomic) XMBaiduLocationModel *model;

@end
