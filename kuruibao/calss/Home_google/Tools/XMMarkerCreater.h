//
//  XMMarkerCreater.h
//  kuruibao
//
//  Created by x on 17/9/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 加载本地数据的时候，用来生成marker
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>
#import <GoogleMaps/GoogleMaps.h>

@interface XMMarkerCreater : NSObject

/**
 根据本地数据获取marker

 @return marker ，如果数据不全会返回nil
 */
+ (GMSMarker *)getLocalMarkerWithQicheid:(NSString *)qicheid;

@end
