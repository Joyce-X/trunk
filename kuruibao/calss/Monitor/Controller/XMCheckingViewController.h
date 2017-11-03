//
//  XMCheckingViewController.h
//  kuruibao
//
//  Created by x on 17/7/27.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//
/***********************************************************************************************
 
 点击监控主界面检测按钮，正常的话，跳转到当前控制器
 
 ************************************************************************************************/
#import "XMMiddleController.h"

@class XMCheckingViewController;

@protocol XMCheckingViewControllerDelegate <NSObject>

/**
 *  通知代理执行动画
 */
- (void)checkingVCWillDisAppear:(XMCheckingViewController *)vc;


@end

@interface XMCheckingViewController : XMMiddleController

/**
 检测编号
 */
@property (copy, nonatomic) NSString *number;


/**
 最终分数
 */
@property (assign, nonatomic) int resultScore;

/**
 检测结果数据
 */
@property (strong, nonatomic) NSArray<NSDictionary *> *resultData;

@property (weak, nonatomic) id<XMCheckingViewControllerDelegate> delegate;

@end
