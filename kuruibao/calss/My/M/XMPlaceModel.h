//
//  XMPlaceModel.h
//  kuruibao
//
//  Created by x on 17/8/22.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XMUSCityModel.h"
@interface XMPlaceModel : NSObject

/**
 州名称
 */
@property (copy, nonatomic) NSString *name;

/**
 州内的城市数组
 */
@property (strong, nonatomic) NSArray<XMUSCityModel *> *city;

@end
