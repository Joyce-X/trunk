//
//  XMShareView.h
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMShareView;

@protocol XMShareViewDelegate <NSObject>

- (void)shareViewClickFacebook:(XMShareView *)view;
- (void)shareViewClickTwitter:(XMShareView *)view;
- (void)shareViewClickWhatsapp:(XMShareView *)view;
@end
@interface XMShareView : UIView

/**
 展示
 */
- (void)animateToShow;
/**
 收起
 */
- (void)animateToHide;
@property (weak, nonatomic) id<XMShareViewDelegate> delegate;

@end
