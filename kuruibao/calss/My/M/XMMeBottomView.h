//
//  XMMeBottomView.h
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMMeBottomView;

@protocol XMMeBottomViewDelegate <NSObject>

/**
 点击车标一栏

 @param bottomView trigger
 */
- (void)bottomViewDidClickCar:(XMMeBottomView *)bottomView;

/**
 点击底部设置

 @param bottomView trigger
 */
- (void)bottomViewDidClickSetting:(XMMeBottomView *)bottomView;

/**
 点击底部的关于

 @param bottomView trigger
 */
- (void)bottomViewDidClickAbout:(XMMeBottomView *)bottomView;

@end

@interface XMMeBottomView : UIView

/**
 显示车牌号码的label
 */
@property (weak, nonatomic) IBOutlet UILabel *carNumberLabel;
/**
 显示汽车图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *carImageView;

@property (weak, nonatomic) id<XMMeBottomViewDelegate> delegate;

/**
 绑定状态
 */
@property (assign, nonatomic) BOOL linkState;
/**
 *  更新文字内容
 */
- (void)shouldUpdateText;

@end
