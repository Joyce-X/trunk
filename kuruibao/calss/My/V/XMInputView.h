//
//  XMInputView.h
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMInputView;

@protocol XMInputViewDelegate <NSObject>


/**
 inputView点击ok按钮

 @param view trigger
 */
- (void)inputViewOKClick:(XMInputView*)view;

 

@end
@interface XMInputView : UIView



- (void)toBecomeFirstResponder;

@property (weak, nonatomic) id<XMInputViewDelegate> delegate;

/**
 输入结果
 */
@property (copy, nonatomic) NSString *result;

/**
 字长限制 注意：必须先设置限制字长，再设置内容
 */
@property (assign, nonatomic) NSInteger limitLength;

/**
 是否显示剩余字数
 */
@property (assign, nonatomic) BOOL showLeftLabel;

/**
 显示用户需要修改的内容
 */
@property (copy, nonatomic) NSString *content;

@end
