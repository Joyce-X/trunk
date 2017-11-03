//
//  XMSystemMessageCell.h
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMSystemMessageModel.h"
@interface XMSystemMessageCell : UITableViewCell

@property (strong, nonatomic) XMSystemMessageModel *model;

+(instancetype)dequeueReuseableCellWithTableView:(UITableView *)tableView;



@end
