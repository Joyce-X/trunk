//
//  XMTrackCell_google.h
//  kuruibao
//
//  Created by x on 17/6/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XMTrackSegmentStateModel.h"

typedef void (^enlargeBlock) (UIButton *btn,UIEvent *event); //!< 点击地图的block

@interface XMTrackCell_google : UITableViewCell

@property (nonatomic) CLLocationCoordinate2D coor;//!< 当前分段数据的中心点

@property (strong, nonatomic) XMTrackSegmentStateModel *segmentData;//!< 每段数据

@property (copy, nonatomic) enlargeBlock clickEnlarge;//!< 点击地图回调方法

+ (instancetype)dequeueReuseableCellWith:(UITableView*)tableView;

@property (copy, nonatomic) NSString *qicheid;//!< 汽车编号

//- (void)willDisappare;

@end
