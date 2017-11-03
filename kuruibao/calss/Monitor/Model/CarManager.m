//
//  CarManager.m
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "CarManager.h"

#import "AFNetworking.h"

#import "XMUser.h"

#define timeInterval 5

@interface CarManager ()

@property (strong, nonatomic)AFHTTPSessionManager *session;

@property (copy, nonatomic) successBlock successCallback;

@property (copy, nonatomic) failureBlock failCallback;

@property (copy, nonatomic) NSString *Gpsdatetime;

@property (strong, nonatomic) NSTimer *timer;//!< 定时获取实时数据

@property (strong, nonatomic) XMUser *user;
@end


@implementation CarManager

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //!< 监听程序进入后台和前台的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
        
        //!< 监听退出登录的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logout) name:kDashPalWillExitNotification object:nil];
        
        self.user = [XMUser user];
        
        
        
    }
    return self;
}

#pragma mark ------- lazy
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
 开启实时监控
 */
- (void)startMonitorSuccess:(successBlock)successHandle failHandle:(failureBlock)fail
{
    //!< 判断网络，判断车辆，判断是否激活
    
    if (_defaultCar == nil)
    {
        XMLOG(@"---------没有设置默认车辆为空---------");
        
        [XMMike addLogs:@"---------没有设置默认车辆为空---------"];
        
                
        return;
    }
    
    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus <= 0)
    {
        //!< 未知网络，或者为连接网络
        if (fail)
        {
             fail(CarManagerErrorTypeDisconnect,nil);
        }
       return;
        
    }
    
    
    if(_defaultCar.chepaino.length < 2)
    {
        XMLOG(@"---------没有添加默认车辆---------");
        
        [XMMike addLogs:@"---------没有添加默认车辆---------"];
        //!< 没有添加车辆
        if (fail)
        {
            fail(CarManagerErrorTypeNone,nil);
        }
        return;
    
    }
    
    if(_defaultCar.tboxid.intValue == 0)
    {
        XMLOG(@"---------车辆未激活，开始尝试重新激活---------");
        [XMMike addLogs:@"---------车辆未激活，开始尝试重新激活---------"];
        
        //!< 可以在这里进行激活
        [self activeCar];
        
        if (fail)
        {
            fail(CarManagerErrorTypeNotActive,nil);
        }
        
        return;
    
    }
    
    //!< 开启实时监控
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%ld&qicheid=%@&tboxid=%@&groupid=1",_user.userid,_defaultCar.qicheid,_defaultCar.tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //!<  0 终端不在线，-1 网络异常，1 成功
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        if(result == 1)
        {
            
            XMLOG(@"---------开启实时监控成功---------");
            [XMMike addLogs:@"---------开启实时监控成功---------"];
            //!< 开启实时监控成功
            if (successHandle)
            {
                successHandle();
            }
            
            if (self.timer)
            {
                [self.timer invalidate];
                
                self.timer = nil;
            }
            //!< 开启定时器，获取数据
            self.timer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(getRealtimeData) userInfo:nil repeats:YES];
            
            
        }else
        {
            
            XMLOG(@" 开启实时监控失败");
            [XMMike addLogs:@" 开启实时监控失败"];
            
            if (fail)
            {
                fail(CarManagerErrorTypeOther,@(result));
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@" 开启实时监控失败，网络原因:%@",error.userInfo);
        [XMMike addLogs:@" 开启实时监控失败，网络原因"];
        
        if (fail)
        {
            fail(CarManagerErrorTypeOther,@"网络连接失败");
        }
        
    }];
    
    
 }
- (void)getRealtimeData
{
    //!< 第一次获取实时数据需要传当前时间格式
     if (self.Gpsdatetime == nil)
    {
         NSDateFormatter *df = [[NSDateFormatter alloc]init];
        
        df.dateFormat = @"yyyy-MM-dd%20HH:mm:ss";
        
        NSDate *date = [NSDate date];
        
        self.Gpsdatetime = [df stringFromDate:date];
    }
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"q_run_info&Tboxid=%@&Qicheid=%@&Gpsdatetime=%@",_defaultCar.tboxid,_defaultCar.qicheid,self.Gpsdatetime];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if(resultStr.length > 2)
        {
            XMLOG(@"获取实时数据成功");
            [XMMike addLogs:@"获取实时数据成功"];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSString *time = dic[@"oTBoxInfo"][@"locationdate"];//!< 定位时间，需要下次传给服务器
            
            self.Gpsdatetime = [time stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            //!< 通知代理，更新数据
            if (self.delegate)
            {
                [self.delegate carManager:self didUpdateRealtimeData:dic];
            }
            
            
        }else
        {
            XMLOG(@"获取实时数据失败,失败原因：%@---车辆状态为停止",resultStr);
            
            [XMMike addLogs:@"获取实时数据失败,失败原因：---车辆状态为停止"];
            self.Gpsdatetime = nil;//!< 下次传gps数据会从新生成当前时间
            
            //!< 通知代理，清除数据
            if (self.delegate)
            {
                [self.delegate carManager:self didUpdateRealtimeData:nil];
            }
            
         }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"获取实时数据失败，网络原因");
        [XMMike addLogs:@"获取实时数据失败，网络原因"];
        
        
        
    }];
}


- (void)activeCar{

    XMLOG(@"---------正在尝试重新激活---------");
    [XMMike addLogs:@"---------正在尝试重新激活---------"];
    //!< 在线激活 发送101指令
    
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Active&Userid=%lu&Qicheid=%@",_user.userid,_defaultCar.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        int statusCode = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        switch (statusCode)
        {
            case 0:
                
                XMLOG(@"激活失败，网络错误");
                [XMMike addLogs:@"激活失败，网络错误"];
                
                break;
                
            case -1:
                
                XMLOG(@"激活失败，终端不在线");
                [XMMike addLogs:@"激活失败，终端不在线"];
                break;
                
                
                
            default:
                
                //!< 激活成功，返回终端编号
                XMLOG(@"激活成功");
                [XMMike addLogs:@"激活成功"];
                
                break;
        }
         
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"激活失败，网络错误");
        [XMMike addLogs:@"激活失败，网络错误"];
    }];

    

}

/**
 关闭实时监控
 */
- (void)stopMonitor
{

    if (_defaultCar == nil)
    {
        XMLOG(@"---------关闭实时监控失败，未设置默认车辆---------");
        [XMMike addLogs:@"---------关闭实时监控失败，未设置默认车辆---------"];
        return;
    }
    
    
    //!< 关闭实时监控
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%lu&qicheid=%@&tboxid=%@&groupid=2",_user.userid,_defaultCar.qicheid,_defaultCar.tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XMLOG(@"--------关闭实时监控成功---------");
        [XMMike addLogs:@"--------关闭实时监控成功---------"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"---------关闭实时监控失败---------");
        [XMMike addLogs:@"---------关闭实时监控失败---------"];
        
    }];
    
}

//http://api.longseer.online/v2.ashx?key=43f32f4722e0991ae17403a549e1f244&method=q_run_gpsinfo&Qicheid=34&Tboxid=31
#pragma mark ------- 通知的方法
/**
 *  将要进入后台
 */
- (void)applicationWillEnterBackground
{
    if(_defaultCar == nil) return;
    
    [self stopMonitor];
    
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    self.Gpsdatetime = nil;
     
}

/**
 *  将要进入前台的时候
 */
- (void)applicationWillBecomeActive
{
    if(_defaultCar == nil) return;
    
    [self startMonitorSuccess:nil failHandle:nil];
    
    
}

- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    XMLOG(@"---------carManager dealloc---------");
    
    [XMMike addLogs:@"---------carManager dealloc---------"];
}
- (void)logout
{
    
    if ( self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    
}


@end
