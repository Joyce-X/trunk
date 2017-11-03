//
//  CoorsList.m
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "CoordsList.h"

@implementation CoordsList

- (id)initWithPath:(GMSPath *)path {
    
    if ((self = [super init])) {
        
        _path = [path copy];
        
        _target = 0;
        
        self.continueAnimate = YES;
    }
    
    return self;
}

- (CLLocationCoordinate2D)next {
    
    ++_target;
    
    if (_target == _path.count) {
        
        _target = 0;
        
        return CLLocationCoordinate2DMake(0, 0);//!< 判断是否结束动画
    }
    
    return [_path coordinateAtIndex:_target];
}

@end

 
