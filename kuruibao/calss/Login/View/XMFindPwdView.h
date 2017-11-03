//
//  XMFindPwdView.h
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XMFindPwdView;

@protocol XMFindPwdViewDelegate <NSObject>

/**
 点击下一步按钮

 @param view 触发者
 */
- (void)findPwdViewNextBtnClick:(XMFindPwdView *)view;

/**
 点击获取验证码按钮
 
 @param view 触发者
 */
- (void)findPwdViewGetVerifyCodeBtnClick:(XMFindPwdView *)view;


@end

@interface XMFindPwdView : UIView

@property (weak, nonatomic) id<XMFindPwdViewDelegate> delegate;

/**
 用户输入的电话号码
 */
@property (copy, nonatomic,readonly) NSString *phoneNumber;
/**
 用户输入的验证码
 */
@property (copy, nonatomic,readonly) NSString *verificationCode;

/**
 开始倒计时
 */
-(void)startCountdown;

- (void)stopTimer;


/**
 用户修改密码的时候，提供的接口

 @param phoneNumber 用户电话号码
 */
- (void)setExistPhoneNumber:(NSString *)phoneNumber;

@end
