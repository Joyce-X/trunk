//
//  XMMapCustomCalloutView.h
//  kuruibao
//
//  Created by x on 16/11/27.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMMapCustomCalloutView : UIView

@property (strong, nonatomic) UIImage *image;//!< 车辆图标

@property (copy, nonatomic) NSString *title;//!< 车辆型号

@property (copy, nonatomic) NSString *subtitle;//!< 是否在线

@property (copy, nonatomic) NSString *time;//!< 定位时间、


#pragma mark ------- 美国项目新添加的属性，上边的属性只用到image
/**
 车牌号码
 */
@property (copy, nonatomic) NSString *carNumber;

/**
 状态 在线或者不在线
 */
@property (copy, nonatomic) NSString *state;


/**
 司机名称
 */
@property (copy, nonatomic) NSString *driver;

/**
 最后一获取次定位的时间
 */
@property (copy, nonatomic) NSString *lastTime;

@end
