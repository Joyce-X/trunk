//
//  XMMiddleShowViewController.h
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "BaseViewController.h"

#import "XMTrackSegmentStateModel.h"

#import "AFNetworking.h"

#import <CoreLocation/CoreLocation.h>
@interface XMMiddleShowViewController : BaseViewController

@property (strong, nonatomic) XMTrackSegmentStateModel *segmentData;//!< 每段数据

@property (copy, nonatomic) NSString *qicheid;

@property (nonatomic) CLLocationCoordinate2D coor;

@end
