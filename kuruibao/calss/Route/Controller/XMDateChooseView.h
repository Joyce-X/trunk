//
//  XMDateChooseView.h
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol XMDateChooseViewDelegate <NSObject>

/**
 时间选择完毕，通知代理

 @param date 日期
 @param start 开始时间
 @param end 结束时间
 */
- (void)chooseViewDidSelectDate:(NSString *)date start:(NSString *)start end:(NSString *)end;

@end

@interface XMDateChooseView : UIView


@property (weak, nonatomic) id<XMDateChooseViewDelegate> delegate;

//!< 需要提供接口来设置要显示的时间
/**
 显示年月日的时间
 */
@property (strong, nonatomic) NSDate *date1;

/**
 显示开始时间
 */
@property (strong, nonatomic) NSDate *date2;

/**
显示结束时间
 */
@property (strong, nonatomic) NSDate *date3;

/**
 展示时间选择器
 */
- (void)show;




@end
