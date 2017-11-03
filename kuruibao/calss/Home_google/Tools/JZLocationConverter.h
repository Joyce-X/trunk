//
//  JZLocationConverter.h
//  JZCLLocationMangerDome
//
//  Created by jack zhou on 13-8-22.
//  Copyright (c) 2013年 JZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JJGPSModel.h"
@interface JZLocationConverter : NSObject

/**
 *	@brief	世界标准地理坐标(WGS-84) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *  ####只在中国大陆的范围的坐标有效，以外直接返回世界标准坐标
 *
 *	@param 	location 	世界标准地理坐标(WGS-84)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)wgs84ToGcj02:(CLLocationCoordinate2D)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02） 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	location 	中国国测局地理坐标（GCJ-02）
 *
 *	@return	世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)gcj02ToWgs84:(CLLocationCoordinate2D)location;


/**
 *	@brief	世界标准地理坐标(WGS-84) 转换成 百度地理坐标（BD-09)
 *
 *	@param 	location 	世界标准地理坐标(WGS-84)
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)wgs84ToBd09:(CLLocationCoordinate2D)location;


/**
 *	@brief	中国国测局地理坐标（GCJ-02）<火星坐标> 转换成 百度地理坐标（BD-09)
 *
 *	@param 	location 	中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@return	百度地理坐标（BD-09)
 */
+ (CLLocationCoordinate2D)gcj02ToBd09:(CLLocationCoordinate2D)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 中国国测局地理坐标（GCJ-02）<火星坐标>
 *
 *	@param 	location 	百度地理坐标（BD-09)
 *
 *	@return	中国国测局地理坐标（GCJ-02）<火星坐标>
 */
+ (CLLocationCoordinate2D)bd09ToGcj02:(CLLocationCoordinate2D)location;


/**
 *	@brief	百度地理坐标（BD-09) 转换成 世界标准地理坐标（WGS-84）
 *
 *  ####此接口有1－2米左右的误差，需要精确定位情景慎用
 *
 *	@param 	location 	百度地理坐标（BD-09)
 *
 *	@return	世界标准地理坐标（WGS-84）
 */
+ (CLLocationCoordinate2D)bd09ToWgs84:(CLLocationCoordinate2D)location;


/**
 对请求到的坐标进行处理
 
 @param array 转换之前的坐标（目前服务器返回的是百度坐标）
 @return 转换之后的坐标数组，如果在国内就返回gcj坐标，国外返回WGS坐标
 */
+ (NSArray<JJGPSModel *> *)handelCoordinate:(NSArray *)array;


/**
 对请求到的坐标进行处理(指针对实时绘制轨迹)
 
 @param array 转换之前的坐标（目前服务器返回的是百度坐标）
 @return 转换之后的坐标数组，如果在国内就返回gcj坐标，国外返回WGS坐标
 */
+ (NSArray<JJGPSModel *> *)handelCoordinateForRealTimeMonitor:(NSArray *)array;

/**
 判断坐标是否在中国境内

 @param lat 纬度
 @param lon 经度
 @return 
 */
+ (BOOL)outOfChina:(double)lat bdLon:(double)lon;
@end
