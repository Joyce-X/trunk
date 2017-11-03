//
//  XMTrackSegmentStateModel.h
//  kuruibao
//
//  Created by x on 16/11/29.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XMTrackSegmentStateModel : NSObject

@property (copy, nonatomic) NSString *starttime;//!< 行程开始时间

@property (copy, nonatomic) NSString *endtime;//!< 行程结束时间

@property (assign, nonatomic) BOOL xingchengstatus;//!< 行程状态 1 一结束 0 未结束

@property (copy, nonatomic) NSString *penyou;//!< 行程油耗

@property (copy, nonatomic) NSString *licheng;//!< 行驶里程

/**
 行驶时间，已经对时间进行过处理，h-m-s
 */
@property (copy, nonatomic) NSString *xingshiTime;//!< 行驶时长

@property (copy, nonatomic) NSString *daisuTime;//!< 怠速时长

@property (copy, nonatomic) NSString *jishache;//!< 急刹车次数

@property (copy, nonatomic) NSString *jijiayou;//!< 急加油次数

@property (copy, nonatomic) NSString *comfortscore;//!< 舒适度得分

@property (copy, nonatomic) NSString *xingchengid;//!< 行程id


//!< 需要新添加的属性： 急转弯，弯道加速，平均油耗（服务器暂时不具备，带服务器添加),平均速度，
@property (copy, nonatomic) NSString *jizhuanwan;//!< 急转弯

@property (copy, nonatomic) NSString *wandaojiasu;//!< 弯道加速

@property (copy, nonatomic) NSString *pingjunouhao;//!< 平均油耗（新加数据）

@property (copy, nonatomic) NSString *pingjunsudu;//!< 平均速度

- (instancetype)initWithDictionary:(NSDictionary *)dic;

@end
