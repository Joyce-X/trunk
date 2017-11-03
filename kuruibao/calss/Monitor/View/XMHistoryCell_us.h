//
//  XMHistoryCell_us.h
//  kuruibao
//
//  Created by x on 17/7/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMHistoryCell_us : UITableViewCell

/**
 设置数据
 */
@property (strong, nonatomic) NSDictionary *data;

+(instancetype)dequeueReusedCellWithTableView:(UITableView *)tableview;

@end
