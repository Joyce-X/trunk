//
//  XMHome_usScrollView.h
//  kuruibao
//
//  Created by x on 17/7/26.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMHome_usScrollView : UIScrollView



/**
 清除数据
 */
- (void)clear;


/**
 设置数据

 @param dic 实时数据
 */
- (void)setData:(NSDictionary *)dic;


- (void)shouldUpdateText;

@end
