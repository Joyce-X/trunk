//
//  XMGGMapCell.h
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "XMTrackSegmentStateModel.h"

@class XMGGMapCell;
//typedef void (^enlargeBlock) (UIButton *btn,UIEvent *event); //!< 点击地图的block
@protocol XMGGMapCellDelegate <NSObject>

- (void)mapCellDidSelectCell:(XMGGMapCell *)cell;

@end

@interface XMGGMapCell : UICollectionViewCell

@property (nonatomic) CLLocationCoordinate2D coor;//!< 当前分段数据的中心点

@property (strong, nonatomic) XMTrackSegmentStateModel *segmentData;//!< 每段数据


@property (copy, nonatomic) NSString *qicheid;//!< 汽车编号

@property (weak, nonatomic) id<XMGGMapCellDelegate> delegate;

/**
 是否有坐标点
 */
@property (assign, nonatomic) BOOL hasLocationPoints;

/**
 设置按钮图片
 */
- (void)setState:(BOOL)state;

@end



