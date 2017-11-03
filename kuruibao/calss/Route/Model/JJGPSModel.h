//
//  JJGPSModel.h
//  kuruibao
//
//  Created by x on 17/7/24.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//
/***********************************************************************************************
 
 点击放大地图，进入到轨迹回放界面的时候请求gps轨迹，建模
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
@interface JJGPSModel : NSObject

@property (strong, nonatomic) CLLocation *location;

/**
 事件的状态 eventtype=19,异常振动,0震动开始,1-震动停止; eventtype=30,超速报警,0-报警1-报警取消； eventtype=31,水温报警,0-水温过低，1-水温恢复正常，2-水温过高； eventtype=32,转速报警,0-报警1-报警取消； eventtype=33,电瓶电压报警,0-电压过低，1-电压恢复正常，2-电压过高； eventtype=35,怠速报警,0-怠速开始，1-怠速超过3分钟，2-怠速结束；
 */
@property (copy, nonatomic) NSString *eventstatus;


/**
 GPS事件类型 1:行程开始; 2:行程结束; 3:水平校准进行中; 4:水平校准完成; 5:方向校准进行中; 6:方向校准完成; 7:安装位置移动; 10:急刹车; 11:急加油; 12:快速变道; 13:弯道加速; 14:碰撞; 15:频繁变道; 16:烂路高速行驶; 17:急转弯; 18:翻车 19:异常震动; 20:车门异常; 21:胎压和手刹异常; 30:超速报警; 31:水温报警; 32:转速报警; 33:电压报警; 34:故障报警; 35:怠速报警; 38:拖吊报警
 */
@property (assign, nonatomic) NSInteger eventtype;

/**
 obd采集的速度
 */
@property (assign, nonatomic) NSInteger obdspeed;


/**
 卫星定位给出的速度
 */
@property (assign, nonatomic) NSInteger speed;

/**
 时间
 */
@property (copy, nonatomic) NSString *dthappen;



//!< 计算事件类型
- (GMSMarker *)getMarker;

@end
