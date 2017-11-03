//
//  CarManager.h
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XMDefaultCarModel.h"

typedef NS_ENUM(NSUInteger, CarManagerErrorType) {
    
    CarManagerErrorTypeNone         = 1, //!<没有车辆
    CarManagerErrorTypeNotActive    = 1 << 1,//!< 没有激活车辆
    CarManagerErrorTypeDisconnect   = 1 << 2,//!< 无网络连接
    CarManagerErrorTypeOther        = 1 << 3 //!< 其他原因
};


typedef void (^failureBlock)(CarManagerErrorType errorType,id errorInfo);

typedef void (^successBlock)();

@class CarManager;

@protocol CarManagerDelegate <NSObject>

@optional
/**
 开启实时监控成功后，会间隔10秒获取新数据，获取成功，通知代理更新界面

 @param manager trigger
 @param data 获取到的数据
 */
- (void)carManager:(CarManager *) manager didUpdateRealtimeData:(NSDictionary *)data;

@end

@interface CarManager : NSObject



/**
 默认车辆
 */
@property (strong, nonatomic) XMDefaultCarModel *defaultCar;

@property (weak, nonatomic) id<CarManagerDelegate> delegate;


/**
 开启实时监控
 */
- (void)startMonitorSuccess:(successBlock)successHandle failHandle:(failureBlock)fail;

/**
 关闭实时监控
 */
- (void)stopMonitor;

@end
