//
//  XMGoogleViewController.m
//  kuruibao
//
//  Created by x on 17/6/22.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMGoogleViewController.h"

#import "JZLocationConverter.h"

#import <GoogleMaps/GoogleMaps.h>

#import <AMapFoundationKit/AMapFoundationKit.h>

#import "XMDefaultCarModel.h"

#import "XMBaiduLocationModel.h"

#import "XMCar.h"

#import "XMMapCustomCalloutView.h"

#import "XMCustomUserLocationView.h"
#import "XMRealTimeMonitorController.h"
#import <MapKit/MapKit.h>
#import "XMLocalDataManager.h"

#import "XMMarkerCreater.h"

#import "XMActiveManager.h"

#define kCalloutWidth       250.0
#define kCalloutHeight      95.0


@interface XMGoogleViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>{

BOOL _firstLocationUpdate;


}

//@property (weak, nonatomic) IBOutlet UIButton *stateBtn;//!< 控制当前车辆还是全部车辆的按钮

@property (weak, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) CLLocation *location;//!< 记录更新的位置

@property (strong, nonatomic) CLLocationManager *manager;

@property (strong, nonatomic) GMSMarker *userMarker;//!< 标记用户的位置

@property (strong, nonatomic) XMDefaultCarModel *defaultCar;//!< 默认车辆信息

@property (strong, nonatomic) XMBaiduLocationModel *defaultModel;//!< 包含默认车辆位置信息的模型

@property (strong, nonatomic) GMSMarker *localMarker;//!< 没有网的时候，加载本地数据

@end

@implementation XMGoogleViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        //!< 监听车辆信息变化的通知
          [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carInfodidChanged:) name:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
     }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupUI];
    
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //!< 更新位置信息
    if (self.defaultModel)
    {
        [self.defaultModel updateLocaton];
    }
    
    self.navigationController.navigationBarHidden = YES;
    
    [_mapView clear];//!< 清除所有标注
    
    
    XMUser *user = [XMUser user];
    
    if(user.qicheid.integerValue < 1)
    {
        XMLOG(@"---------未添加车辆，只显示用户当前位置---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------未添加车辆，只显示用户当前位置---------"]];

        [self showUserLocation];return;
    }
    
    if (user.tboxid.intValue < 1 && self.defaultModel.noLocation == YES)
    {
        XMLOG(@"---------车辆未激活，只显示用户位置---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆未激活，只显示用户位置---------"]];

        
        [self showUserLocation];return;
    }
    
    //!< 显示逻辑
    if (connecting)
    {
        //!< 有网络
        //!< 判断默认车辆位置信息存在就显示默认车辆位置，没有位置就显示用户位置
        
         if (self.defaultModel.noLocation) {
            
             [self showUserLocation];
            
            
        }else
        {
            [self locateCar:nil];
            
        }
        
        
    }else
    {
        //!< 没有网络
        
        //!< 判断是否有缓存
        if ([XMLocalDataManager hasCacheDataForCar:user.qicheid])
        {
            //!< 有缓存，显示汽车位置
            //!< 有车辆
            if (self.localMarker)
            {
                self.localMarker.map = _mapView;
                
                [_mapView animateToLocation:_localMarker.position];
                
                [_mapView animateToZoom:15];
                
            }else
            {
                [self showUserLocation];
            }
            
            
            
        }else
        {
            //!< 没有缓存，显示用户位置
            [self showUserLocation];
        
        }
    
    }
    
    

}



- (void)setupUI
{
    //!< 定位
    self.manager  = [CLLocationManager new];
    
    self.manager.delegate = self;
    
    [self.manager startUpdatingLocation];
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.26 longitude:115.25 zoom:6];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:self.view.bounds camera:camera];
  
    mapView.delegate = self;
    
    [self.view addSubview:mapView];
    
    self.mapView = mapView;
    
    [self.view insertSubview:mapView atIndex:0];
    
    [_mapView setMinZoom:2 maxZoom:21];
    
    
    
    //!< 添加导航按钮
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [naviBtn setImage:[UIImage imageNamed:@"gps icon"] forState:UIControlStateNormal];
    
    [naviBtn addTarget:self action:@selector(naviBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:naviBtn];
   
    [naviBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(70);
        
        make.right.equalTo(self.view).offset(-9);
        
        make.size.equalTo(CGSizeMake(39, 39));
        
    }];
    
}

#pragma mark ------- lazy

//!< 懒加载显示用户当前位置
- (GMSMarker *)userMarker
{
    if (self.location == nil)
    {
        XMLOG(@"---------获取用户定位失败---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------获取用户定位失败---------"]];

        return nil;
    }

    if (!_userMarker)
    {
        _userMarker = [GMSMarker markerWithPosition:self.location.coordinate];
        
        _userMarker.tappable = NO;
        
    }

    UIView *view = [XMCustomUserLocationView new];
    
    view.frame = CGRectMake(0, 0, 30, 30);
    
    _userMarker.iconView = view;
    
    _userMarker.position = _location.coordinate;
    
    _userMarker.map = _mapView;
    
    [_mapView animateToZoom:15];
    
    [_mapView animateToLocation:_userMarker.position];
    
    return _userMarker;

}

/**
 *  没有网络的时候，创建汽车标注
 */
- (GMSMarker *)localMarker
{
    if (!_localMarker)
    {
        XMUser *user = [XMUser user];
        
        _localMarker = [XMMarkerCreater getLocalMarkerWithQicheid:user.qicheid];
        
    }

    return _localMarker;

}


/**
 *  显示用户当前的位置
 */
- (void)showUserLocation
{
    
    if (self.location)
    {
        //!< 页面即将出现的时候，重新显示用户位置，恢复动画
        [self userMarker];

    }
    
 }


#pragma mark ------- 响应通知的方法

/*!
 @brief 监听用户更换默认车辆 || 获取全部车辆信息成功的通知
 */
- (void)carInfodidChanged:(NSNotification *)noti
{
    
    NSString *changMode = noti.userInfo[@"mode"];//!< 默认车辆发生变化还是全部车辆
    
    id object = noti.userInfo[@"result"];//!< 改变的结果
    
    if([changMode isEqualToString:@"car"])
    {
        XMLOG(@"地图模块默认车辆获取成功");
        
        [XMMike addLogs:[NSString stringWithFormat:@"地图模块默认车辆获取成功"]];

        
        /**
            1.当车牌号码长度不够的时候且tboxid为0，判定用户没有添加车辆
         
            2.当noLocation为yes & 经度等于0 || 纬度等于0 的时候判定当前车辆位置数据不正常  （0，0）位于非洲附近
         
            3.
         */
        
        //!< 销毁数据模型，重新创建
        [self.defaultModel stopTimer];
        
        self.defaultModel = nil;
        
        XMDefaultCarModel *model = (XMDefaultCarModel *)object;
        
        self.defaultCar = model;
        
        XMBaiduLocationModel *dModel = [XMBaiduLocationModel new];
        
        dModel.qicheid = self.defaultCar.qicheid;
         
        dModel.chepaino = self.defaultCar.chepaino;
        
        //!< 全局单例车牌号码属性设置
//        [XMDashPalManager shareManager].carNumber = self.defaultCar.chepaino;
        
        dModel.carbrandid = self.defaultCar.carbrandid;
        
        dModel.tboxid = self.defaultCar.tboxid;
        
        self.defaultModel = dModel;
        
        [_mapView clear];//!< 清除所有标记
    }

}


#pragma mark ------- 按钮的点击事件

/**
 点击缩放按钮

 @param sender
 */
- (IBAction)reduceClick:(id)sender {
    
    float zoom = _mapView.camera.zoom;
    
    if (zoom <= kGMSMinZoomLevel)
    {
        return;
    }
    
    [_mapView animateToZoom:zoom - 1];
}

/**
 点击放大按钮

 @param sender
 */
- (IBAction)enlargeClick:(id)sender {
    
    float zoom = _mapView.camera.zoom;
    
    if (zoom >= kGMSMaxZoomLevel)
    {
        return;
    }
    
    [_mapView animateToZoom:zoom + 1];
    
}

/**
 定位用户的位置 要显示用户位置和汽车的位置

 @param sender
 */
- (IBAction)locateUser:(id)sender {
    
    if(![CLLocationManager locationServicesEnabled])
    {
        [MBProgressHUD showError:JJLocalizedString(@"定位服务不可用，请在设置中打开定位服务", nil)];
        
        return;
        
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        [MBProgressHUD showError:JJLocalizedString(@"请在设置中允许使用位置信息", nil)];
        
        return;
        
        
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        [self.manager requestWhenInUseAuthorization];//!< 请求授权
        
        return;
    }
    
    if (self.location == nil)
    {
        [MBProgressHUD showError:JJLocalizedString(@"获取定位信息失败", nil)];
        
        return;
    }
    
    //!< 显示用户位置
    [_mapView clear];
    
    
    //!< 更新位置数据
    if (self.defaultModel)
    {
        [self.defaultModel updateLocaton];
    }
    
    XMUser *user = [XMUser user];
    
    if(user.qicheid.integerValue < 1)
    {
        XMLOG(@"---------未添加车辆，只显示用户当前位置---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------未添加车辆，只显示用户当前位置---------"]];

        [self showUserLocation];return;
    }
    
    if (user.tboxid.intValue < 1)
    {
        XMLOG(@"---------车辆未激活，只显示用户位置---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆未激活，只显示用户位置---------"]];

        [self showUserLocation];return;
    }
    
    
    GMSMarker *userMarker = [self userMarker];
    
    if (!connecting)
    {
//        [_mapView animateToLocation:userMarker.position];
        
        
        //!< 判断是否有缓存
        if ([XMLocalDataManager hasCacheDataForCar:user.qicheid])
        {
            //!< 有缓存
            if (self.localMarker)
            {
                self.localMarker.map = _mapView;
                
                
                GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
                
                bounds =  [bounds includingCoordinate:userMarker.position];
                
                bounds =  [bounds includingCoordinate:self.localMarker.position];
                
                //        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:30.0f];
                
                //!< 设置显示人车位置的时候，对边距进行设定
                GMSCameraUpdate * update  =[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(100, 100, 90, 100)];
                
                [_mapView moveCamera:update];
                
                
            }

            
        }else
        {
            //!< 没有缓存，只显示用户位置即可
            
            
        }
       
        return;
    }else
    {
    
        //!< 判断是否有汽车位置
        if (!self.defaultModel.noLocation) {
            
            //!< 有汽车位置，显示汽车位置和用户位置
            GMSMarker *marker = [GMSMarker markerWithPosition:self.defaultModel.coor];
            
            marker.userData = self.defaultModel;
            
            if ([_defaultModel.showName isEqualToString:@"online"])
            {
                
                marker.icon = [UIImage imageNamed:@"map_annotation_online"];
                
            }else
            {
                
                marker.icon = [UIImage imageNamed:@"map_annotation_offline"];
                
            }
            
            marker.map = _mapView;
            
            
            //!< 显示范围
            //!< 显示起点和终点
            GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
            
            bounds =  [bounds includingCoordinate:userMarker.position];
            
            bounds =  [bounds includingCoordinate:marker.position];
            
            //        GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:30.0f];
            
            //!< 设置显示人车位置的时候，对边距进行设定
            GMSCameraUpdate * update  =[GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(100, 100, 90, 100)];
            
            [_mapView moveCamera:update];
            
        }else
        {
            
            //!< 没有汽车位置，只显示用户位置
//            [_mapView animateToCameraPosition:[GMSCameraPosition cameraWithTarget:_location.coordinate zoom:16]];
        }

    
    
    }
    
    
    
   
   
}

/**
 *  点击导航按钮，开始导航，导航到默认车辆
 */
- (void)naviBtnClick
{
    XMLOG(@"---------准备开始导航---------");
    
    if (!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];return;//!< 没有网络只显示用户位置
    }
    
    
    //!< 判断是否有车辆
    if (self.defaultCar.qicheid.integerValue == 0 || self.defaultCar.chepaino.length == 0)
    {
        [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil)];
        
        return;
    }
    
    if (self.defaultCar.tboxid.integerValue == 0 && self.defaultModel.noLocation)
    {
        //!< 车辆木有激活，且没有位置信息 提示无法获取位置数据
        [MBProgressHUD showError:JJLocalizedString(@"无法获取当前车辆位置数据", nil)];
        
        return;
    }
    
//    if (self.defaultCar.tboxid.integerValue == 0 && self.defaultModel.noLocation == NO)
//    {
//        //!< 车辆木有激活，但是获取到了以前的定位数据，显示车辆不在线
//        [MBProgressHUD showError:JJLocalizedString(@"无法获取当前车辆位置数据", nil)];
//        
//        return;
//    }
    
    //!< 判断是否获取到位置信息
    if (!self.defaultModel || (self.defaultModel.coor.latitude == 0 && self.defaultModel.coor.longitude == 0))
    {
        [MBProgressHUD showError:JJLocalizedString(@"正在获取位置信息...", nil)];
        
        return;
    }
    
    //!< 获取当前位置
    MKMapItem *myLocation = [MKMapItem mapItemForCurrentLocation];
    
    //!< 当前经纬度
//    float currentLatitude = myLocation.placemark.location.coordinate.latitude;
//    
//    float currentLongitude = myLocation.placemark.location.coordinate.longitude;
//    
//    CLLocationCoordinate2D coords1 = CLLocationCoordinate2DMake(currentLatitude, currentLongitude);
    
    //!< 目标位置
    MKMapItem *toLocation = [[MKMapItem alloc]initWithPlacemark:[[MKPlacemark alloc]initWithCoordinate:self.defaultModel.coor]];
    
    toLocation.name = JJLocalizedString(@"车辆位置", nil);
    
    NSArray *items = @[myLocation,toLocation];
    
    NSDictionary *options = @{ MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeWalking, MKLaunchOptionsMapTypeKey: [NSNumber numberWithInteger:MKMapTypeStandard], MKLaunchOptionsShowsTrafficKey:@YES };
    
    //打开苹果自身地图应用，并呈现特定的item
    [MKMapItem openMapsWithItems:items launchOptions:options];
    
    
    
}

/**
 定位默认车辆或者当前车辆的位置

 @param sender
 */
- (IBAction)locateCar:(id)sender {
    
    //!< 更新位置数据
    if (self.defaultModel)
    {
        [self.defaultModel updateLocaton];
    }
    
    XMUser *user = [XMUser user];
    
    if(user.qicheid.integerValue < 1 && user.tboxid.integerValue < 1)
    {
        XMLOG(@"---------未添加车辆---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------未添加车辆---------"]];

        
        [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil)];
        
        return;
    }
    
//    if (user.qicheid.integerValue > 0 && user.tboxid.integerValue < 1)
//    {
//        XMLOG(@"---------车辆未激活---------");
//        
//        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆未激活---------"]];
//
//        
//        [MBProgressHUD showError:JJLocalizedString(@"车辆未激活", nil)];
//        return;
//    }
    
    
    
    if (!connecting)
    {
        [_mapView clear];
        
        //!< 没有网络的时候，判断是否需要加载缓存数据
        //!< 判断是否有缓存
        if ([XMLocalDataManager hasCacheDataForCar:user.qicheid])
        {
            //!< 有缓存
            if (self.localMarker)
            {
                self.localMarker.map = _mapView;
                
                [_mapView animateToLocation:_localMarker.position];
                
                [_mapView animateToZoom:15];
                
            }else
            {
                [self showUserLocation];
            }
        }else
        {
        
            //!< 没有缓存，显示默认位置
            //!< 没有车辆。显示用户位置
            [self showUserLocation];
        }
        
        return;

    }
    
    if(![CLLocationManager locationServicesEnabled])
    {
        if (sender)
        {
            
        [MBProgressHUD showError:JJLocalizedString(@"定位服务不可用，请在设置中打开定位服务", nil)];
        
       
        
        }
         return;
    }
    
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied) {
        
        if (sender)
        {
            
        [MBProgressHUD showError:JJLocalizedString(@"请在设置中允许使用位置信息", nil)];
        
       
        
        }
         return;
        
    }
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        if (sender)
        {
            
        [self.manager requestWhenInUseAuthorization];//!< 请求授权
        
        }
        
    }
    
    
    
    
    [self showDefaultCar];
    
}

- (void)showDefaultCar
{
    
    if(self.defaultModel.noLocation == YES)
    {
        [MBProgressHUD showError:JJLocalizedString(@"无法获取当前车辆位置数据", nil)];
        
        return;
    
    }
    
    if (self.defaultModel.locationState == XMLocationStateLoading)
    {
        [MBProgressHUD showError:JJLocalizedString(@"正在获取位置信息...", nil)];
        
        return;
    }
    
    if (self.defaultModel.locationState == XMLocationStateFailed)
    {
        
        XMLOG(@"---------获取位置信息失败---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------获取位置信息失败---------"]];

        [MBProgressHUD showError:JJLocalizedString(@"无法获取当前车辆位置数据", nil)];
        
        return;
    }
    
    [_mapView clear];
    
    [self handleLocationModel:self.defaultModel];
    
     [_mapView animateToLocation:_defaultModel.coor];
    
    [_mapView animateToZoom:18];//!< 显示范围
        
}


#pragma mark ------- CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    //!<在这里需要进行判断，如果在中国境内的话就需要转换坐标，因为谷歌用的是WGS-84 的坐标系，需要转成GCJ-02坐标进行展示
    
    CLLocation *location =locations.firstObject;
  
     //!< 首先将gps坐标转换成为高德坐标系的坐标，然后判断这个点是否在国内，如果在国内的话就返回gcj-02坐标，不在国内就返回返回GPS坐标
     CLLocationCoordinate2D coorGaoDe = AMapCoordinateConvert(location.coordinate, AMapCoordinateTypeGPS);
    
    BOOL isChina = AMapDataAvailableForCoordinate(coorGaoDe);
    
    //!< 在国内，使用高德地图坐标   在国外 直接使用GPS坐标
    self.location = isChina ? [[CLLocation alloc]initWithLatitude:coorGaoDe.latitude longitude:coorGaoDe.longitude] : location;


}


-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{    XMLOG(@"---------开始定位失败---------");
}


#pragma mark ------- GMSMapViewDelegate

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{

    XMBaiduLocationModel *model = marker.userData;
    
    XMMapCustomCalloutView *contentView = [[XMMapCustomCalloutView alloc] initWithFrame:CGRectMake(0, -300, kCalloutWidth,kCalloutHeight)];
    
    //!< 设置图片
    contentView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",model.carbrandid]];
    
    if (contentView.image == nil)
    {
        contentView.image = [UIImage imageNamed:@"companyList_placeholderImahe"];
    }
    
//    [XMLocalDataManager saveID:model.carbrandid];
    
    //!< 设置状态
    if (connecting)
    {
        contentView.state = model.showName;
    }else
    {
        contentView.state = @"offline";
    
    }
    
    
    //!< 设置车牌号码
//    XMDashPalManager *manager = [XMDashPalManager shareManager];
    
    XMUser *user = [XMUser user];
    
    contentView.carNumber = user.chepaino;
    
    //!< 保存车牌号码
//    [XMLocalDataManager saveCarNumber:manager.carNumber];
    
    //!< 设置司机名称
//    if (manager.userNickName.length == 0)
//    {
//        XMUser *user = [XMUser user];
    
  
    
    if (user.vin.length == 0)
    {
        contentView.driver = user.mobil;
    }else
    {
        contentView.driver = user.vin;
    }
        //!< 没有设置昵称。默认显示手机号码
//    }else
//    {
//        contentView.driver = manager.userNickName;
//    }
    
//    [XMLocalDataManager saveLastDriverName:contentView.driver];//!< 保存司机名称
   
    //!< 设置最后一次定位时间
    contentView.lastTime = model.deadLine;
    
    [XMLocalDataManager saveLastLocateTime:model.deadLine];//!< 保存最后定位时间
    
    //!< 保存最后定位
//    [XMLocalDataManager saveLastLongitude:marker.position.longitude];
//    [XMLocalDataManager saveLastLatitude:marker.position.latitude];
    
    //!< 保存数据
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    @try {
        dic[@"carID"] = model.carbrandid;
        dic[@"number"] = user.chepaino;
        dic[@"driverName"] = user.vin;
        dic[@"time"] = model.deadLine;
        dic[@"latitude"] = @(marker.position.latitude);
        dic[@"longitude"] = @(marker.position.longitude);
        [XMLocalDataManager saveCacheDataForCar:user.qicheid data:dic];
        
    } @catch (NSException *exception) {
        
        XMLOG(@"--------Joyce 抓到一场-%@---------",exception);
        
        [XMMike addLogs:[NSString stringWithFormat:@"--------Joyce 抓到一场-%@---------",exception]];

        
        XMLOG(@"---------sss---------");
        
    } @finally {
       
        XMLOG(@"---------Joyce 处理异常---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------Joyce 处理异常---------"]];

        
    }
     
     return contentView;
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(GMSMarker *)marker
{

    XMLOG(@"---------tap---------");
    //!< 判断当前车辆是否在线，如果不在线就不跳转
    XMBaiduLocationModel *model = marker.userData;
    
    if ([model.showName isEqualToString:@"online"])
    {
        //!< 跳转到实时监控界面
        XMRealTimeMonitorController *vc = [XMRealTimeMonitorController new];
        
        vc.hidesBottomBarWhenPushed = YES;
        
        vc.model = model;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    
    
    
}


#pragma mark ------- tool

/**
 处理数据，模型转标注

 @param locationModel 模型数据
 */
- (void)handleLocationModel:(XMBaiduLocationModel *)locationModel
{
//    map_annotation_offline  map_annotation_online  图片名称
    GMSMarker *marker = [GMSMarker markerWithPosition:locationModel.coor];
    
    marker.userData = locationModel;
 
    if ([locationModel.showName isEqualToString:@"online"])
    {
       marker.icon = [UIImage imageNamed:@"map_annotation_online"];
        
    }else
    {
        
        marker.icon = [UIImage imageNamed:@"map_annotation_offline"];
    
    }
    
    marker.map = _mapView;
    
   
    
}


@end
