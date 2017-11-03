//
//  XMAddCarController.h
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleController.h"

@protocol XMAddCarControllerDelegate <NSObject>

- (void)shouldRefresh;//!< 刷新界面

@end
@interface XMAddCarController : XMMiddleController

@property (weak, nonatomic) id<XMAddCarControllerDelegate> delegate;

@end
