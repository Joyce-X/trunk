//
//  BaseViewController.h
//  kuruibao
//
//  Created by x on 17/7/18.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 新添加的控制器都继承自这个根控制器
 
 ************************************************************************************************/

#import <UIKit/UIKit.h>

#import "AFNetworking.h"

#import "XMUser.h"
/**
 网络连接
 */
#define connecting ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus != AFNetworkReachabilityStatusNotReachable)

@interface BaseViewController : UIViewController

/**
 *  数据源
 */
@property (nonatomic,strong)NSMutableArray* dataSource;


/**
 会话请求
 */
@property (strong, nonatomic) AFHTTPSessionManager *session;

/**
 是否显示背景图片，由子类自己控制,默认不显示 tag:7777
 */
@property (assign, nonatomic) BOOL showBackgroundImage;

/**
 是否显示返回按钮，由子类自己控制 tag:7778
 */
@property (assign, nonatomic) BOOL showBackArrow;

/**
  是否显示标题，由子类自己控制 tag:7779
 */
@property (assign, nonatomic) BOOL showTitle;

/**
 页面标题
 */
@property (copy, nonatomic) NSString *Title;
/**
 是否显示副标题，由子类自己控制 tag:7780
 */
@property (assign, nonatomic) BOOL showSubtitle;

/**
 页面副标题
 */
@property (copy, nonatomic) NSString *subtitle;

/**
 背景的目标高度
 */
@property (assign, nonatomic) NSInteger destinationHeight;


/**
 网络恢复
 */
- (void)networkResume;


/**
 网络失去连接
 */
- (void)networkDisconnect;

/**
 点击返回按钮
 */
- (void)backArrowClcik;
 

@end
