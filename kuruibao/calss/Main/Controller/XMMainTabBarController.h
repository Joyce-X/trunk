//
//  XMMainTabBarController.h
//  KuRuiBao
//
//  Created by x on 16/6/21.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMMainTabBarController : UITabBarController

/**
 手动设置选中的item

 @param index 第几个 0-3
 */
- (void)setSelectItem:(int)index;

@end
