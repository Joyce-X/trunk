//
//  XMTroubleCell_us.h
//  kuruibao
//
//  Created by x on 17/8/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMTroubleCell_us : UITableViewCell
+(instancetype)dequeueReusedCellWithTableView:(UITableView *)tableview;


/**
 content
 */
@property (copy, nonatomic) NSString *text;

@end
