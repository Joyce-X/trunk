//
//  CoorsList.h
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "JJGPSModel.h"
#import <GoogleMaps/GoogleMaps.h>
@interface CoordsList : NSObject

@property(nonatomic, copy) GMSPath *path;

@property(nonatomic) NSUInteger target;

/**
 是否继续动画
 */
@property (assign, nonatomic) BOOL continueAnimate;

- (id)initWithPath:(GMSPath *)path;

- (CLLocationCoordinate2D)next;

@end
/*
 
 
  
 */
