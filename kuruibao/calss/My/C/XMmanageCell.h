//
//  XMmanageCell.h
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMmanageCell : UITableViewCell

+ (instancetype)dequeueResuableCellWithTableView:(UITableView *)tableView;


/**
 是否显示分割线
 */
@property (assign, nonatomic) BOOL showLine;

/**
 汽车图标
 */
@property (strong, nonatomic) UIImage *carImage;

/**
 第一个显示文字
 */
@property (copy, nonatomic) NSString *text1;

/**
 第2个显示文字
 */
@property (copy, nonatomic) NSString *text2;


/**
 是否是默认车辆
 */
@property (assign, nonatomic) BOOL isDefasult;

@end
