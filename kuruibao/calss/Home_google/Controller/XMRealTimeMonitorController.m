//
//  XMRealTimeMonitorController.m
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 1 页面加载完毕：显示地图、显示标注并且为中心点、显示自定义视图并且停止倒计时 ✔️
 2 页面将要出现的时候，打开实时监控。失败提示失败原因，成功开始倒计时 ✔️
 3 页面即将消失的时候关闭实时监控，因为这个操作是比较耗时的 ✔️
 4 断网的时候，停止数据更新，提示网络已断开
 5 恢复的时候开始数据更新，不用做任何提示
 6 在页面加载完毕的时候，在子线程开启定时器，间隔固定的时间段去判断车辆是否在线，（1）在线的话，判断是否正在倒计时，如不在就开启倒计时，
 （2） 不在线的话判断是否再倒计时，如果在倒计时，则停止倒计时
 
 ************************************************************************************************/
#import "XMRealTimeMonitorController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "XMRealTimeView.h"
#import "JZLocationConverter.h"
#define realTimeH 388

@interface XMRealTimeMonitorController ()<GMSMapViewDelegate,XMRealTimeViewDelegate>

@property (weak, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) GMSMarker *marker;//!< 当前位置标注

@property (weak, nonatomic) XMRealTimeView *panView;//!< 手势操作的view

@property (copy, nonatomic) NSString *Gpsdatetime;//!<上次定位时间，用来获取实时数据上传给服务器的时间信息

@property (copy, nonatomic) NSString *gpsTimeLocation;//!< 获取定位点的时候需要上传给服务器的时间信息

@property (strong, nonatomic) XMUser *user;

/**
 用来监控车辆是否在线
 */
@property (strong, nonatomic) NSTimer *timer;

@end

@implementation XMRealTimeMonitorController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupUI];
 }

- (void)setupUI
{
   
    self.user = [XMUser user];
    //!< 添加地图
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.26 longitude:115.25 zoom:6];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
    
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    self.mapView = mapView;
    
    [self.view insertSubview:mapView atIndex:0];
    
    [_mapView setMinZoom:2 maxZoom:21];
    
    [_mapView animateToZoom:15];
    
    //!< 添加返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
 
    [backBtn setImage:[UIImage imageNamed:@"backicon_us"] forState:UIControlStateNormal];
    
    [backBtn addTarget:self action:@selector(bacKbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(48);
        
        make.left.equalTo(self.view).offset(25);
        
        make.size.equalTo(CGSizeMake(30, 30));
    }];
    
     //!< 添加标注
     self.marker = [GMSMarker markerWithPosition:_model.coor];
    
     self.marker.userData = _model;
//    starticon_us map_annotation_online
     self.marker.icon = [UIImage imageNamed:@"starticon_us"];
    
     self.marker.map = _mapView;
    
    [_mapView animateToLocation:self.model.coor];//!< 设置车辆为地图中心点
    
    
    //!< 添加需要手势的view
    XMRealTimeView *panView = [[NSBundle mainBundle] loadNibNamed:@"XMRealTimeView" owner:nil options:nil].firstObject;
    
    panView.frame = CGRectMake(13, mainSize.height - 240, mainSize.width-26, realTimeH);
    
    panView.delegate = self;
    
    [panView pauseTimer];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [panView addGestureRecognizer:pan];
    
    [self.view addSubview:panView];
    
    self.panView = panView;
    
  
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //!< 开启实时监控
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%ld&qicheid=%@&tboxid=%@&groupid=1",_user.userid,self.model.qicheid,_model.tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //!<  0 终端不在线，-1 网络异常，1 成功
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        if(result == 1)
        {
            //!< 开启实时监控成功
            [self startUpdateDate];
            
        }else
        {
             XMLOG(@"XMRealTimeMonitorController 开启实时监控失败，网");
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"XMRealTimeMonitorController 开启实时监控失败，网络原因:%@",error.userInfo);
        
       
        
    }];
    
    

}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //!< 关闭实时监控
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%lu&qicheid=%@&tboxid=%@&groupid=2",self.user.userid,self.model.qicheid,self.model.tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XMLOG(@"XMRealTimeMonitorController--------关闭实时监控成功---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"XMRealTimeMonitorController--------关闭实时监控成功---------"]];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"XMRealTimeMonitorController---------关闭实时监控失败---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"XMRealTimeMonitorController---------关闭实时监控失败---------"]];

        
    }];
    
    //!< 关闭定时器
    if (self.timer)
    {
        [self.timer invalidate];
    }
    
    [_panView pauseTimer];
}

#pragma mark ------- operation data
/**
实时监控已经打开 开始更新数据
 */
- (void)startUpdateDate
{
    //!< 开始倒计时、开启定时器监控是否在线、首先获取一次数据用来显示、
    [_panView startTimer];
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(judgeCarState:) userInfo:nil repeats:YES];
    
    //!< 获取汽车运行数据显示
    [self getRealTimeData];
    
    //!< 获取汽车轨迹实时数据，并进行绘制
    [self redrawPolyline];
}

- (void)judgeCarState:(NSTimer *)timer
{
    
    XMLOG(@"---------当前线程：%@---------",[NSThread currentThread]);
    //!< 判断车辆是否在线
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_currentstatus&Qicheid=%@",_model.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        //        result = @1;//delete this line
        //!< 0-停止  1-行驶  2-失联  -1-参数或网络错误 -2 没有数据
        
        //!< 回调是在主线程中执行的
        if(result.integerValue == 1)
        {
            //!< 在线，判断按钮是否在倒计时，如不是，就开启
            if (_panView.isCountingDown)
            {
                //!< 正在倒计时，因为在线，故不执行操作
            }else
            {
                //!< 开启倒计时
                [_panView startTimer];
            }
            
        }else
        {
            //!< 不在线 判断按钮是否在倒计时，如果在倒计时 就关闭
            if (_panView.isCountingDown)
            {
                 //!<关闭倒计时
                [_panView pauseTimer];
                
                
            }else
            {
                
            }
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        XMLOG(@"---------车辆已经不在线了---------");
        
    }];
    
}


- (void)getRealTimeData
{
    
    //!< 第一次获取实时数据需要传当前时间格式
    
    if (self.Gpsdatetime == nil)
    {
        
        NSDateFormatter *df = [[NSDateFormatter alloc]init];
        
        df.dateFormat = @"yyyy-MM-dd%20HH:mm:ss";
        
        NSDate *date = [NSDate date];
        
        self.Gpsdatetime = [df stringFromDate:date];
    } 
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"q_run_info&Tboxid=%@&Qicheid=%@&Gpsdatetime=%@",_model.tboxid,_model.qicheid,self.Gpsdatetime];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        if(resultStr.length > 2)
        {
            XMLOG(@"获取实时数据成功");
            
            [XMMike addLogs:[NSString stringWithFormat:@"获取实时数据成功"]];

            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSString *time = dic[@"oTBoxInfo"][@"locationdate"];//!< 定位时间，需要下次传给服务器
            
            self.Gpsdatetime = [time stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
//            self.gpsTimeLocation = self.gpsTimeLocation;
            
            _panView.dic = dic;//!< 设置数据
             //!< 重新绘制
//             [self redrawPolyline];
            
        }else
        {
            XMLOG(@"获取实时数据失败");
            
            [XMMike addLogs:[NSString stringWithFormat:@"获取实时数据失败"]];

            
            [_panView startTimer];
            
        }
        
     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
         XMLOG(@"获取实时数据失败，网络原因");
         
         [XMMike addLogs:[NSString stringWithFormat:@"获取实时数据失败，网络原因"]];

        
         [_panView startTimer];
        
    }];

    
    
}


#pragma mark ------- 点击按钮

- (void)bacKbtnClick
{

    [self.navigationController popViewControllerAnimated:YES];
    
}

/**
 *  响应手势
 */
- (void)pan:(UIPanGestureRecognizer *)sender
{
    
    
    if(sender.state == UIGestureRecognizerStateEnded){
        
        //!< 手势结束，
        CGFloat y = _panView.y;
        
        
        
        if (y >= mainSize.height - 127) {
            
            [UIView animateWithDuration:0.1 animations:^{
                
                _panView.y = mainSize.height - 166;
            }];
            
        }else if(y >= mainSize.height - 222 && y < mainSize.height - 127)
        {
            [UIView animateWithDuration:0.1 animations:^{
                
                _panView.y = mainSize.height - 240;
                
            }];
        }else
        {
            [UIView animateWithDuration:0.1 animations:^{
                
                _panView.y = mainSize.height - realTimeH;
                
            }];
            
        }
        
    }else
    {
        //!< 手势开始和手势变化
        CGPoint p = [sender translationInView:sender.view];
        
        if (_panView.y <= mainSize.height - realTimeH)
        {
            if (p.y>0)
            {
                self.panView.y += p.y;
            }else
            {
                _panView.y = mainSize.height - realTimeH;
            }
        }else
        {
            self.panView.y += p.y;
            
        }
        [sender setTranslation:CGPointZero inView:sender.view];
        
        
    }
    
    
}

#pragma mark ------- XMRealTimeViewDelegate
/**
 通知代理 倒计时按钮被点击
 
 @param realTimeView trigger
 */
- (void)realTimeViewDidClickCountDownBtn:(XMRealTimeView *)realTimeView
{
     //!< 获取新数据
    [self getRealTimeData];
    
    [self redrawPolyline];
    

}

/**
 重新绘制线条  绘制轨迹
 */
- (void)redrawPolyline
{
    
//    if (self.gpsTimeLocation == nil)
//    {
//        
//        NSDateFormatter *df = [[NSDateFormatter alloc]init];
//        
//        df.dateFormat = @"yyyy-MM-dd%20HH:mm:ss";
//        
//        NSDate *date = [NSDate date];
//        
//        self.gpsTimeLocation = [df stringFromDate:date];
//    }
//    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_xc_gps_newest&qicheid=%@&tboxid=%@&lastGpsTime=%@",_model.qicheid,_model.tboxid,self.Gpsdatetime];
    XMLOG(@"---------%@---------3322",urlStr);
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        XMLOG(@"---------%@---------332211",str);
        
        if (str.integerValue == -1)
        {
            XMLOG(@"---------参数或网络错误---------");
            self.gpsTimeLocation = nil;
            
        }else if(str.length == 1 && str.integerValue == 1)
        {
            self.gpsTimeLocation = nil;
             XMLOG(@"---------没有新的数据---------");
        }else
        {
            
           
            //!< 有新的数据
            NSArray *locations = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            locations = [JZLocationConverter handelCoordinateForRealTimeMonitor:locations];
            
            [self parserLocationData:locations];//!< 解析坐标数组
            
            XMLOG(@"---------新数据----%d条-----",(int)locations.count);
            
         
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"---------获取实时数据失败，网络原因---------");
        self.gpsTimeLocation = nil;
    }];
    
    
    
}

//!< 解析请求来的位置数据
- (void)parserLocationData:(NSArray<JJGPSModel *> *)array
{
    
    //!< 有时间可以再进行优化： 增加点到点的思路
    if (array.count > 0)
    {
        [self.dataSource addObjectsFromArray:array];
        
//        self.gpsTimeLocation = array.firstObject.dthappen;//!< 修改时间，下次传服务器
        
    }else
    {
    
        return;
    }
    
    [_mapView clear];
    
    _marker.position = array.firstObject.location.coordinate;
    
    _marker.map = _mapView;
    
    //!< 添加新的显示当前位置的marker
    GMSMarker * Cmarker = [GMSMarker markerWithPosition:array.lastObject.location.coordinate];
    
    Cmarker.userData = _model;

    Cmarker.icon = [UIImage imageNamed:@"map_annotation_online"];
    
    Cmarker.map = _mapView;
    
 
    
     //!< 添加轨迹
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (JJGPSModel *loca in self.dataSource)
    {
        [path addCoordinate:loca.location.coordinate];
    }
    
    //!< 添加overlay
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
    polyline.strokeColor =  XMColor(100, 170, 216);//170,171,255 XMColor(100, 170, 216);
    
    polyline.geodesic = YES;
    
    polyline.strokeWidth = 4;
    
    polyline.map = _mapView;
    
     //!< 显示起点和终点
    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
    
    bounds =  [bounds includingPath:path];
     
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:30.0f];
    
    [_mapView moveCamera:update];
    

    
    
}


#pragma mark ------- system method

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)networkDisconnect
{
    
    [super networkDisconnect];
    
    [MBProgressHUD showError:JJLocalizedString(@"网络已断开", nil)];

    [_panView resteTime];
    
    [_panView pauseTimer];
    
    self.gpsTimeLocation = nil;
    
    self.Gpsdatetime = nil;

}

- (void)networkResume
{
    [super networkResume];
    //!< 开始倒计时
    [_panView startTimer];

}

@end
