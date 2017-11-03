//
//  XMGoogleViewController.h
//  kuruibao
//
//  Created by x on 17/6/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMTrackSegmentStateModel.h"

#import "AFNetworking.h"

#import <CoreLocation/CoreLocation.h>

#import "JJGPSModel.h"

@interface XMGoogleMapEnlargeViewController : UIViewController

@property (strong, nonatomic) XMTrackSegmentStateModel *segmentData;//!< 每段数据

@property (copy, nonatomic) NSString *qicheid;

@property (nonatomic) CLLocationCoordinate2D coor;


/**
 用来接收存储坐标数据的模型数组
 */
@property (strong, nonatomic) NSArray <JJGPSModel *> *locationModels;

@end
