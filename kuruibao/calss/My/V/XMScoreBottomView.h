//
//  XMScoreBottomView.h
//  kuruibao
//
//  Created by x on 17/8/17.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMScoreBottomView : UIView

/**
 标题
 */
@property (copy, nonatomic) NSString *title;

/**
 分数一
 */
@property (copy, nonatomic) NSString *score1;

/**
 分数二
 */
@property (copy, nonatomic) NSString *score2;

/**
 分数三
 */
@property (copy, nonatomic) NSString *score3;

/**
 图片名称
 */
@property (copy, nonatomic) NSString *imageName;

/**
 显示第二个Label的名称（原始名称为Counts）
 */
@property (copy, nonatomic) NSString *secondLabelTitle;

@end
