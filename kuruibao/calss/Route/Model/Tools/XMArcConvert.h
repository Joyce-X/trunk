//
//  XMArcConvert.h
//  kuruibao
//
//  Created by X on 2017/9/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

//-- 计算两点之间于x轴中间的夹角

#import <Foundation/Foundation.h>
@import CoreLocation;
@interface XMArcConvert : NSObject

/**
 计算两点之间与X轴之间的夹角

 @param Pa 第一个点
 @param Pb 第二个点
 @return 角度值)
 */
+ (float)convertArcWithPointA:(CLLocationCoordinate2D)Pa Pb:(CLLocationCoordinate2D)Pb;

@end
