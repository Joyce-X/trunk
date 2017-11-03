//
//  XMEditCarController.h
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleController.h"
#import "XMCar.h"

@protocol XMEditCarControllerDelegate <NSObject>

/**
 刷新数据
 */
- (void)shouldUpdateData;

@end
@interface XMEditCarController : XMMiddleController

/**
 数据模型
 */
@property (strong, nonatomic) XMCar *carModel;

@property (weak, nonatomic) id<XMEditCarControllerDelegate> delegate;

@end
