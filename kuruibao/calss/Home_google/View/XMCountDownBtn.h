//
//  XMCountDownBtn.h
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMCountDownBtnDelegate <NSObject>

/**
 按钮倒计时周期结束，通知代理更新数据
 */
-(void)pleaseUpdateData;

@end

@interface XMCountDownBtn : UIButton

@property (weak, nonatomic) id<XMCountDownBtnDelegate> delegate;

/**
 开始计时
 */
- (void)startTimer;

/**
 用户主动点击更新数据的时候，提供暂停计时的方法
 */
- (void)pauseTimer;

/**
 销毁定时器，恢复显示事件为初始值
 */
-  (void)stopTimer;

@end
