//
//  XMFindPwdViewController.h
//  KuRuiBao
//
//  Created by x on 16/6/23.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleController.h"


typedef void (^callbackBlock)(NSString *phoneNumber,NSString *pwd);

@interface XMFindPwdViewController : XMMiddleController

@property (copy, nonatomic) callbackBlock finishFind;

/**
 显示的标题
 */
@property (copy, nonatomic) NSString *titleText;

@end
