//
//  XMDetailTroubleController.h
//  kuruibao
//
//  Created by x on 17/8/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "BaseViewController.h"

@interface XMDetailTroubleController : BaseViewController

/**
 需要显示的数据源
 */
@property (strong, nonatomic) NSArray<NSDictionary *> *data;


/**
 点击哪一项的名称，赋值给subtitile
 */
@property (copy, nonatomic) NSString *itemName;

@end
