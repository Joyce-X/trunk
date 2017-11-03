//
//  XMEnterPwd.h
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMEnterPwd;

@protocol XMEnterPwdDelegate <NSObject>

- (void)EnterPwdClickConfirmBtn:(XMEnterPwd *)enterView;

@end

@interface XMEnterPwd : UIView


/**
 密码1
 */
@property (copy, nonatomic,readonly) NSString *password1;

/**
 密码2
 */
@property (copy, nonatomic,readonly) NSString *password2;

@property (weak, nonatomic) id<XMEnterPwdDelegate> delegate;

@end
