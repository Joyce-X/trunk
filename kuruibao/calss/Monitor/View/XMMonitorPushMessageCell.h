//
//  XMMontorPushMessageCell.h
//  kuruibao
//
//  Created by x on 16/12/12.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMMessageModel.h"
@interface XMMonitorPushMessageCell : UITableViewCell

//@property (copy, nonatomic) NSString *pushMessage;//!< 推送消息
/**
 显示事件
 */
@property (weak, nonatomic) UILabel *timeLabel;
@property (nonatomic,weak)UILabel* messageLabel;//!< 显示推送消息
@property (strong, nonatomic) XMMessageModel *model;

@property (assign, nonatomic) BOOL type;//!< 显示图片种类区分

+(instancetype)dequeueReuseableCellWithTableView:(UITableView *)tableView;


@end
