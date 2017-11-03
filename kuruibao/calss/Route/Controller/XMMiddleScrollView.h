//
//  XMMiddleScrollView.h
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMTrackSegmentStateModel.h"
@class XMMiddleScrollView;

@protocol XMMiddleScrollViewDelegate <NSObject>

/**
 点击跳转按钮，控制器执行跳转操作

 @param view trigger's super view
 */
- (void)scrollViewJumpBtnClick:(XMMiddleScrollView *)view;


@end

@interface XMMiddleScrollView : UIView

//!< 提供一个接口来设置数据（提供模型还是字典根据上一个界面来确定）
/**
 数据模型，用来设置数据
 */
@property (strong, nonatomic) XMTrackSegmentStateModel *model;

/**
 代理
 */
@property (weak, nonatomic) id<XMMiddleScrollViewDelegate> delegate;


/**
 在弹起分享视图的时候，将自己隐藏到底部
 */
- (void)scrollToBottom;

@end
