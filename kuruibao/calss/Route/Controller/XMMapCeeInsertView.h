//
//  XMMapCeeInsertView.h
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMMapCeeInsertView : UIView
/**
 显示总里程
 */
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
/**
 显示行程开始时间
 */
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
/**
 显示行程结束时间
 */
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;

@end
