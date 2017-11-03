//
//  XMControlAnimateView.h
//  kuruibao
//
//  Created by x on 17/8/13.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMControlAnimateViewDelegate <NSObject>

/**
 点击返回按钮回调，跳转上一级界面
 */
- (void)controlAnimateViewDidClickBack;

/**
 用户点击了播放按钮/暂停按钮

 @param palyBtn trigger
 */
- (void)controlAnimateViewDidClickPlayBtn:(UIButton *)palyBtn;


/**
 滑动滚动条抬起时候调用

 @param slider trigger
 */
- (void)controlAnimateViewDidTouchUpInset:(UISlider *)slider;

@end

@interface XMControlAnimateView : UIView


/**
 设置进度
 */
@property (assign, nonatomic) float progress;

@property (weak, nonatomic) id<XMControlAnimateViewDelegate> delegate;


@end
