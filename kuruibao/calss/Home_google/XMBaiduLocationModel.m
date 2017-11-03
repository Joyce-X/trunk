//
//  XMBaiduLocationModel.m
//  kuruibao
//
//  Created by X on 2017/6/17.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMBaiduLocationModel.h"

#import "AFNetworking.h"

//#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "XMUser.h"

#import <AMapFoundationKit/AMapFoundationKit.h>

#import "NSDictionary+convert.h"

@interface XMBaiduLocationModel()

@property (nonatomic,strong)AFHTTPSessionManager* session;

/**
 定时更新数据
 */
@property (strong, nonatomic) NSTimer *timer;

//@property (strong, nonatomic) XMUser *user;

@end

@implementation XMBaiduLocationModel


+ (instancetype)defaultWithDictionary:(NSDictionary *)dic
{
    
    
    return [[self alloc] initWithDictionary:dic];
    
    
}


- (instancetype)initWithDictionary:(NSDictionary *)dic
{
    self = [super init];
    
    if (self) {
        
        self.currentstatus = dic[@"currentstatus"];
        
        self.qichetype = dic[@"qichetype"];
        
        self.stylename = dic[@"stylename"];
        
        self.seriesname = dic[@"seriesname"];
        
        self.brandname = dic[@"brandname"];
        
        self.carstyleid = dic[@"carstyleid"];
        
        self.carseriesid = dic[@"carseriesid"];
        
        self.carbrandid = dic[@"carbrandid"];
        
        self.imei = dic[@"imei"];
        
        self.secretflag = dic[@"secretflag"];
        
        self.tboxid = dic[@"tboxid"];
        
        self.chepaino = dic[@"chepaino"];
        
        self.qicheid = dic[@"qicheid"];
        
        self.companyid = dic[@"companyid"];
        
        self.role_id = dic[@"role_id"];
        
        self.typeID = dic[@"typeid"];
        
        self.registrationid = dic[@"registrationid"];
        
        self.userid = dic[@"userid"];
        
        self.mobil = dic[@"mobil"];
        
        self.locationState = XMLocationStateLoading;
        
    }
    
    return self;
}



- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        
        //!< 监听退出登录的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDashPalWillExitNotification object:nil];
        
        
    //!< 间隔一定时间，更新位置数据  5秒请求一次数据
    self.timer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(updateLocation:) userInfo:nil repeats:YES];
        
        
    }

    return self;

}

- (void)logout
{
    
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    
}


- (void)updateLocation:(NSTimer *)timer
{
    [self setTboxid:self.tboxid];
    
 
    
}


#pragma mark --setter


- (void)setTboxid:(NSString *)tboxid
{
    _tboxid = tboxid;
    
   
    
    if(tboxid <= 0 && self.chepaino.length < 2)
    {
        //!< 用户没有添加车辆
        XMLOG(@"---------用户没有车辆信息---------");
        
        [XMMike addLogs:@"---------用户没有车辆信息---------"];

        return;
    }
    
    if (tboxid.integerValue == 0)
    {
        XMLOG(@"---------车辆未激活，---------");
        
        [XMMike addLogs:@"---------车辆未激活，获取位置信息被终止，---------"];
        
//        return;
    }
    
    
    [self requestLocation];//!< 获取最近十条位置信息，数据正常

}

/**
 *  更新数据
 */
- (void)updateLocaton
{
    
    NSString *tboxid = self.tboxid;

    if (tboxid.integerValue == 0)
    {
        XMLOG(@"---------车辆未激活，获取位置信息被终止，---------");
        
        [XMMike addLogs:@"---------车辆未激活，获取位置信息被终止，---------"];

        return;
    }
    
    if(tboxid <= 0 && self.chepaino.length < 2)
    {
        //!< 用户没有添加车辆
        XMLOG(@"---------用户没有车辆信息---------");
        
        [XMMike addLogs:@"---------用户没有车辆信息---------"];

        return;
    }
    
    [self requestLocation];//!< 获取最近十条位置信息，数据正常
    

}

#pragma mark --lazy

-(AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer = [AFHTTPRequestSerializer serializer];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _session.requestSerializer.timeoutInterval = 10;
    }
    return _session;
    
}

/**
 停止计时器，
 */
- (void)stopTimer
{
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }


}
//
//- (void)requestLocation_current
//{
//    
//    //!< 根据汽车id获取汽车的位置信息，当tboxid为0的时候
//    NSString *urlStr = [mainAddress stringByAppendingFormat:@"q_location&Qicheid=%@",self.qicheid];
//    
//    self.locationState = XMLocationStateLoading;
//    
//    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//        
//        self.locationState = XMLocationStateSuccessed;
//        
//        if ([result isEqualToString:@"0"])
//        {
//            self.noLocation = YES;
//            
//        }else if([result isEqualToString:@"-1"])
//        {
//            XMLOG(@"XMBaiduLocationModel--参数类型或者网络错误");
//            
//        }else
//        {
//           
//            NSDictionary *locationDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            if ([locationDic[@"locationy"] isEqualToString:@"36.7"] && [locationDic[@"locationx"] isEqualToString:@"-119.7"] ) {
//                
////                XMLOG(@"Joyce---------%@，%@---------",locationDic[@"locationx"],locationDic[@"locationy"]);
//                //!< 过滤掉美国的坐标
//                return;
//            }
//            
//            
//            CLLocationCoordinate2D gpsCoordinate = CLLocationCoordinate2DMake([locationDic[@"locationy"] doubleValue], [locationDic[@"locationx"] doubleValue]);
//            
//            //!< 首先将gps坐标转换成为高德坐标系的坐标，然后判断这个点是否在国内，如果在国内的话就返回gcj-02坐标，不在国内就返回返回GPS坐标
//            CLLocationCoordinate2D coorGaoDe = AMapCoordinateConvert(gpsCoordinate, AMapCoordinateTypeGPS);
//            
//            BOOL isChina = AMapDataAvailableForCoordinate(coorGaoDe);
//            
//            //!< 在国内，使用高德地图坐标   在国外 直接使用GPS坐标
//            CLLocationCoordinate2D coor = isChina ? coorGaoDe : gpsCoordinate;
// 
//            self.noLocation = NO;
//            
//            self.locationState = XMLocationStateSuccessed;
//            
//             self.coor = coor;
//            
//            //!< 设置显示的时间
//            self.deadLine = locationDic[@"dthappen"];
//             
//            [self sendCheckCommand];
//                
//            
//            XMLOG(@"XMBaiduLocationModel--获取位置信息成功");
//        }
//        
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        self.locationState = XMLocationStateLoading;
//        XMLOG(@"XMBaiduLocationModel--网络连接失败");
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            //!< 5秒后重新获取数据
//            [self requestLocation_current];
//            
//        });
//        
//    }];
//
//
//}


/**
 *  请求最近十条位置信息数据
 */
- (void)requestLocation
{
    
        //!< 获取最近十条位置信息
        NSString *urlStr = [mainAddress stringByAppendingFormat:@"q_run_gpsinfo&Qicheid=%@&Tboxid=%@",self.qicheid,self.tboxid];
    
        [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if ([result isEqualToString:@"0"])
            {
                XMLOG(@"XMBaiduLocationModel---没有获取到位置信息");
                
                [XMMike addLogs:@"XMBaiduLocationModel---没有获取到位置信息"];

                
                self.noLocation = YES;
                
            }else if([result isEqualToString:@"-1"])
            {
                XMLOG(@"XMBaiduLocationModel--参数类型或者网络错误");
                
                [XMMike addLogs:@"XMBaiduLocationModel--参数类型或者网络错误"];

                 self.noLocation = YES;
                
            }else
            {
                 self.locationState = XMLocationStateSuccessed;
                
                //!< 获取最近10条位置信息成功，只取出第一条来显示位置信息
                self.noLocation = NO;
                
                NSArray *locationArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                if (locationArr.count == 0)
                {
                    self.noLocation = YES;
                    XMLOG(@"---------位置数据不正常---------");
                    return ;
                }
                
                NSDictionary *locationDic = [locationArr firstObject];
              
                CLLocationCoordinate2D gpsCoordinate = CLLocationCoordinate2DMake([locationDic[@"locationy"] doubleValue], [locationDic[@"locationx"] doubleValue]);
                
                
                //!< 判断坐标是否正常
                if (gpsCoordinate.latitude == 0 && gpsCoordinate.longitude == 0)
                {
                    //!< 数据错误
                    XMLOG(@"---------位置数据不正常---------");
                    self.noLocation = YES;return ;
                }
                
                
                //!< 首先将gps坐标转换成为高德坐标系的坐标，然后判断这个点是否在国内，如果在国内的话就返回gcj-02坐标，不在国内就返回返回GPS坐标
                CLLocationCoordinate2D coorGaoDe = AMapCoordinateConvert(gpsCoordinate, AMapCoordinateTypeGPS);
                
                BOOL isChina = AMapDataAvailableForCoordinate(coorGaoDe);
                
                //!< 在国内，使用高德地图坐标   在国外 直接使用GPS坐标
                CLLocationCoordinate2D coor = isChina ? coorGaoDe : gpsCoordinate;
                
                self.coor = coor;
                
                 //!< 设置显示的时间
                self.deadLine = locationDic[@"dthappen"];
              
                //!< 发送检测指令，检测是否在线
                [self sendCheckCommand];
                
                XMLOG(@"XMBaiduLocationModel--更新位置信息成功");
                
                [XMMike addLogs:@"XMBaiduLocationModel--更新位置信息成功"];

                
                
            }
        
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            self.locationState = XMLocationStateFailed;
            
            XMLOG(@"XMBaiduLocationModel--网络连接失败");
            
            [XMMike addLogs:@"XMBaiduLocationModel--网络连接失败"];

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //!< 5秒后重新获取数据
                [self requestLocation];
                
                XMLOG(@"---------尝试重新请求位置信息---------");
                
                [XMMike addLogs:@"---------尝试重新请求位置信息---------"];

                
            });
        }];
        
        
    

    
    
}

//!< 发送检测指令，判断终端是否在线
- (void)sendCheckCommand
{
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_currentstatus&Qicheid=%@",self.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *res = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if(res.integerValue == 0 || res.integerValue == 2)
        {
            
            //!< 停止/ 失联
        self.showName = @"offline";
            
            
            
        }else if (res.integerValue == 1)
        {
            //!< 行驶
           
            XMLOG(@"发送检测指令时，终端在线" );
            
            [XMMike addLogs:@"发送检测指令时，终端在线"];

            
            self.showName = @"online";
            
        }else if (res.integerValue == -1)
        {
            //!< 参数或网络错误
            self.showName = @"offline";
            
        }else if (res.integerValue == -2)
        {
            //!< 没有数据
             self.showName = @"offline";
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"网络错误");
        
        [XMMike addLogs:@"网络错误"];

        self.showName = @"offline";
        
        
    }];
    /*
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%ld&qicheid=%@&tboxid=%@&commandtype=50&subtype=0",[XMUser user].userid,_qicheid,_tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
         if (result == 0 || result == -1)
        {
            XMLOG(@"发送检测指令时，终端不在线");
            
            self.showName = @"offline";
            
            
        }else
        {
            XMLOG(@"发送检测指令时，终端在线" );
             self.showName = @"online";
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"网络错误");
         self.showName = @"offline";
        
    }];
    
    */
}

-(void)dealloc
{

    [[NSNotificationCenter defaultCenter] removeObserver:self];//!< 移除通知
    XMLOG(@"---------baidulocation dealloc---------");
    
    [XMMike addLogs:@"---------baidulocation dealloc---------"];


}


@end
