//
//  XMRealTimeView.h
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMRealTimeView;

@protocol XMRealTimeViewDelegate <NSObject>


/**
 通知代理 倒计时按钮被点击

 @param realTimeView trigger
 */
- (void)realTimeViewDidClickCountDownBtn:(XMRealTimeView *)realTimeView;

@end

@interface XMRealTimeView : UIView

/**
 提供设置数据的接口
 */
@property (strong, nonatomic) NSDictionary *dic;

/**
 是否正在倒计时
 */
@property (assign, nonatomic) BOOL isCountingDown;

@property (weak, nonatomic) id<XMRealTimeViewDelegate> delegate;

/**
 将倒计时的时间重置为10秒
 */
- (void)resteTime;

/**
 停止倒计时
 */
- (void)pauseTimer;


/**
 开始倒计时
 */
- (void)startTimer;

@end
