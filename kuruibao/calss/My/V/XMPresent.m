//
//  XMPresent.m
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMPresent.h"
#import "XMPrentView.h"

@implementation XMPresent

+ (void)presentView:(UIView *)view
{
    
    XMPrentView *chooseView = [[XMPrentView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    
    [chooseView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(chooseView);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(255), FITHEIGHT(134)));
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:chooseView];
    
    chooseView.alpha = 0;
    
    chooseView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.13 animations:^{
       
        chooseView.alpha = 1;
        
        chooseView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        chooseView.transform = CGAffineTransformIdentity;
        
//        chooseView.alpha = 0.8;
        
    }];


}

+ (void)presentView:(UIView *)view withSize:(CGSize)size
{
    XMPrentView *chooseView = [[XMPrentView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    
    [chooseView addSubview:view];
    
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.center.equalTo(chooseView);
        
        make.size.equalTo(size);
        
    }];
    
    [[UIApplication sharedApplication].keyWindow addSubview:chooseView];
    
    chooseView.alpha = 0;
    
    chooseView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.13 animations:^{
        
        chooseView.alpha = 1;
        
        chooseView.transform = CGAffineTransformMakeScale(1.05, 1.05);
        
    } completion:^(BOOL finished) {
        
        chooseView.transform = CGAffineTransformIdentity;
        
        //        chooseView.alpha = 0.8;
        
    }];


}

+ (void)presentView:(UIView *)view withFrame:(CGRect)frame
{
    XMPrentView *chooseView = [[XMPrentView alloc]initWithFrame:CGRectMake(0, mainSize.height, mainSize.width, mainSize.height)];
    
    chooseView.backgroundColor = XMClearColor;
    
    [chooseView addSubview:view];
    
    [[UIApplication sharedApplication].keyWindow addSubview:chooseView];
    
//    chooseView.alpha = 0;
    
//    chooseView.transform = CGAffineTransformMakeScale(0, 0);
    
    [UIView animateWithDuration:0.3 animations:^{
        
//        chooseView.alpha = 1;
        
        chooseView.transform = CGAffineTransformMakeTranslation(0, -mainSize.height);
        
    } completion:^(BOOL finished) {
        
//        chooseView.transform = CGAffineTransformIdentity;
        
        //        chooseView.alpha = 0.8;
        
    }];

}
+(void)dismiss
{
   UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:12345];

    [view removeFromSuperview];
    
}
+(void)dismissAnimate:(BOOL)animate
{
    
    UIView *view = [[UIApplication sharedApplication].keyWindow viewWithTag:12345];
    
    [UIView animateWithDuration:0.3 animations:^{
                
        view.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        //!< 移除视图
        [view removeFromSuperview];
        
    }];

}
@end
