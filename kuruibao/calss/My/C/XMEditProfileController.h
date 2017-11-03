//
//  XMEditProfileController.h
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "BaseViewController.h"
#import "XMInfoManager.h"

typedef void (^chooseImageBlock) (id data);

@interface XMEditProfileController : BaseViewController


/**
 选择完成图片执行的callBack
 */
@property (copy, nonatomic) chooseImageBlock callBack;
 

@property (strong, nonatomic) XMInfoManager *manager;

@end
