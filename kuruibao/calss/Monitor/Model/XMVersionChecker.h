//
//  XMVersionChecker.h
//  kuruibao
//
//  Created by x on 17/9/6.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XMVersionChecker;

@protocol XMVersionCheckerDelegate <NSObject>

/**
 通知代理更新新版本(如果没有检测新版本，不会通知代理，所以不用传检测结果)

 @param checker trigger
 */
- (void)checkerDidFinishVersionChecker:(XMVersionChecker *)checker;

/**
 通知代理，跳转到登录界面，因为密码已经发生变化

 @param checker trigger
 */
- (void)checkerFinishCheckUserStateJumpToLoginVC:(XMVersionChecker *)checker;





@end

@interface XMVersionChecker : NSObject


/**
 是否有新版本
 */
@property (assign, nonatomic) BOOL hasNewVersion;


/**
 判断用户是否有修改密码
 */
@property (assign, nonatomic) BOOL pwdError;


/**
 初始化方法

 @param delegate 代理
 @return 实例
 */
- (instancetype)initWithDelegate:(id<XMVersionCheckerDelegate>)delegate;


/**
 获取加载图片地址

 @return 图片地址
 */
+ (UIImage *)launchImageAddress;

@end
