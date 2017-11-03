//
//  XMPresent.h
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMPresent : NSObject


+ (void)presentView:(UIView *)view;

+ (void)presentView:(UIView *)view withSize:(CGSize)size;

+ (void)presentView:(UIView *)view withFrame:(CGRect)frame;

+(void)dismiss;

+(void)dismissAnimate:(BOOL)animate;

@end
