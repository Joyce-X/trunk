//
//  XMMarkerCreater.m
//  kuruibao
//
//  Created by x on 17/9/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMarkerCreater.h"
#import "XMBaiduLocationModel.h"
#import "XMLocalDataManager.h"

#define fetchKey @"fetchKey_"

@implementation XMMarkerCreater


+ (GMSMarker *)getLocalMarkerWithQicheid:(NSString *)qicheid;
{
    
    if ([XMLocalDataManager hasCacheDataForCar:qicheid] == NO)
    {
        //!< 对应汽车没有缓存
        return nil;
    }
    
    NSString *key = [fetchKey stringByAppendingString:qicheid];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *dic = [df objectForKey:key];
    
//    {@"carID":@"sss",@"number":@"ddd",@"driverName":"sfs",@"time":@1,@"longitude":@1432,@"latitude":"ewfef"}
    
    
    XMBaiduLocationModel *model = [XMBaiduLocationModel new];
    
    model.carbrandid = dic[@"carID"];
    
    model.showName = @"offline";
    
    model.secretflag = dic[@"dricerName"];//司机名称
    
    model.role_id = dic[@"number"];//车牌号码
    
    model.deadLine = dic[@"time"];
    
    GMSMarker *marker = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake([dic[@"latitude"] floatValue], [dic[@"longitude"] floatValue])];
    
    marker.icon = [UIImage imageNamed:@"map_annotation_offline"];
    
    marker.userData = model;
    
    return marker;
    
 
}

@end
