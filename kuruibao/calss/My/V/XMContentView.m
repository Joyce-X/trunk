//
//  XMContentView.m
//  kuruibao
//
//  Created by x on 17/8/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMContentView.h"

@implementation XMContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        //!< 初始化成功的时候，添加点击手势，在点击时，动画移除
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        
        [self addGestureRecognizer:tap];
        
        
        //!< 监听键盘
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        
    }
    return self;
}


- (void)tap
{
 
    [UIView animateWithDuration:0.2 animations:^{
       
        self.y = mainSize.height;
        
    }];
    
    
    
}

/**
 隐藏到底部
 */
- (void)hideToBottom
{
    [self tap];
}

- (void)showFirstLevel
{
    [UIView animateWithDuration:0.2 animations:^{
       
        self.y = 0;
        
    }];

}

#pragma mark -- 监听通知的方法

- (void)keyboardWillShow:(NSNotification *)noti
{
    
    //!< 时间
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //!< bounds
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    //!< 键盘弹起的时候，改变自身的frame
    [UIView animateWithDuration:duration animations:^{
        
        self.frame = CGRectMake(0, rect.origin.y - mainSize.height, mainSize.width, mainSize.height);
        
    }];
    
}

- (void)keyboardWillHide:(NSNotification *)noti
{
    
    double duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    [UIView animateWithDuration:duration animations:^{
        
        self.frame = CGRectMake(0, mainSize.height , mainSize.width, mainSize.height);
    }];
    
    
}



@end
