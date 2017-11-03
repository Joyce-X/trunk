//
//  XMGoogleViewController.m
//  kuruibao
//
//  Created by x on 17/6/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMGoogleMapEnlargeViewController.h"

#import <GoogleMaps/GoogleMaps.h>

#import "XMTrackLocationModel.h"

#import "JJGPSModel.h"

#import "CoordsList.h"

#import "XMControlAnimateView.h"

#import "XMArcConvert.h"

@interface XMGoogleMapEnlargeViewController ()<XMControlAnimateViewDelegate>


@property (strong, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) GMSMarker *animateMarker;//!< 动画的标注

@property (weak, nonatomic) XMControlAnimateView *controlView;//!< 底部控制动画view

@property (assign, nonatomic) float duration;//!< 画点时间间隔

@end

@implementation XMGoogleMapEnlargeViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //!< 初始化界面
    [self setupSubviews];
    
}


- (void)setupSubviews
{
    self.view.backgroundColor = XMWhiteColor;
    
    //!< 添加地图
    self.mapView = [[GMSMapView alloc]init];
    
    _mapView.frame = self.view.bounds;
    
     _mapView.myLocationEnabled = NO;
    
    [self.view addSubview:_mapView];
    
    //!< 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setImage:[UIImage imageNamed:@"backicon_us"] forState:UIControlStateNormal];
    
    backBtn.frame = CGRectMake(20, 48, 35, 35);
    
    [backBtn addTarget:self action:@selector(backItemClcik) forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn setContentEdgeInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    
    [self.view addSubview:backBtn];
    
    //!< 添加进度view
    XMControlAnimateView *view = [[NSBundle mainBundle] loadNibNamed:@"XMControlAnimateView" owner:nil options:nil].firstObject;
    
    view.frame = CGRectMake(20, mainSize.height - 13 - 52, mainSize.width - 40, 52);
    
    [self.view addSubview:view];
    
    self.controlView = view;
    
    view.delegate = self;

    //!< 显示到用户的定位位置，避免自动显示到一些不相干的地方
    if (self.coor.latitude != 0 && self.coor.longitude != 0)
    {
        [_mapView animateToLocation:self.coor];
        
        [_mapView animateToZoom:15];
    }
    
    //!< 设置画线的速度
    NSUInteger count = self.locationModels.count;
    
    if (count > 0 && count <= 100)
    {
        self.duration = 0.1;// 100ms / point ---0.1ms
    }
    
    if(count > 100 && count <= 500)
    {
    
        self.duration = 0.02;// 100ms / 5point ---0.02ms
    
    }
    
    if (count > 500 && count <= 2000)
    {
       self.duration = 0.005;// 100ms / 20 point --- 0.005ms
    }
    
    if (count > 2000 && count <= 5000)
    {
        self.duration = 1/300;// 100ms / 30 point
    }
    
    if (count > 5000 && count <= 8000)
    {
        
        self.duration = 1 / 500;// 100ms / 50 point
    }
    
    if ( count > 8000)
    {
        self.duration = 1 / 1000;// 100ms / 100 point
    }
    
    
    //!< 开始解析数据
    [self parserLocationData:self.locationModels];
    
}

/**
 *  禁止用户左滑返回上一页
 */
-(void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}
 

#pragma mark ------- XMControlAnimateViewDelegate

/**
 点击返回按钮回调，跳转上一级界面
 */
- (void)controlAnimateViewDidClickBack
{
      [self.navigationController popViewControllerAnimated:YES];
}

/**
 用户点击了播放按钮/暂停按钮
 
 @param palyBtn trigger
 */
- (void)controlAnimateViewDidClickPlayBtn:(UIButton *)palyBtn
{
    
    //!< selelct NO--play  yes--pause
    
    if(palyBtn.isSelected)
    {
        //!< 取消动画
        [self pauseAnimate];
        
    }else
    {
        //!< 开始动画
        [self startAnimate];
    }
   
    palyBtn.selected = ! palyBtn.selected;

}

/**
 滑动滑动条抬起手指后调用

 @param slider trigger 
 */
- (void)controlAnimateViewDidTouchUpInset:(UISlider *)slider
{


}

#pragma mark ------- btn click

/**
 * @brief 点击返回按钮触发
 */
- (void)backItemClcik
{
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}


//!< 解析请求来的位置数据
- (void)parserLocationData:(NSArray<JJGPSModel *> *)array
{
    
    //!< 隐藏事件点和起点终点，以及遮盖，在动画的时候进行绘制
    CLLocation *slocation = array.firstObject.location;
    
    //!< 添加起点
    GMSMarker *startMarker = [GMSMarker markerWithPosition:[slocation coordinate]];
    
    startMarker.icon = [UIImage imageNamed:@"starticon_us"];
    
    startMarker.map = _mapView;

    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
    
    //!< 添加轨迹
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (JJGPSModel *loca in array)
    {
        [path addCoordinate:loca.location.coordinate];
        
        bounds = [bounds includingCoordinate:loca.location.coordinate];
    }
    

    //!< 显示所有轨迹
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(50, 30, 50, 50)];
    
    [_mapView animateWithCameraUpdate:update];
 
    
    //添加动画的汽车图标
    GMSMarker *marker;
    
    marker = [GMSMarker markerWithPosition:slocation.coordinate];
    
    marker.icon = [UIImage imageNamed:@"car"];
    
    marker.groundAnchor = CGPointMake(0.5f, 0.5f);
    
    marker.flat = YES;
    
    marker.map = _mapView;
    
    marker.userData = [[CoordsList alloc] initWithPath:path];
    
    self.animateMarker = marker;
    
    [self animateToNextCoord:marker];
    
    
    
}
- (void)animateToNextCoord:(GMSMarker *)marker {
    
    CoordsList *coords = marker.userData;
    
     //!< 判断是否继续动画
    if (!coords.continueAnimate) {
        
        coords.continueAnimate = YES;
        return;
    }
    
    //!< 添加事件
    [self addEvent:coords.target];
    
    CLLocationCoordinate2D coord = [coords next];//-- 下一个坐标点
    
    NSUInteger totalCount = coords.path.count;//-- 总坐标数
    
    float percent = coords.target/(totalCount * 1.0);
    
    if (percent != 0)
    {
        
    _controlView.progress = percent;
        
        if (percent > 0.99)
        {
            _controlView.progress = 1;
            
             [self.navigationController popViewControllerAnimated:YES];//!< 播放完成返回
            
            [self endAnimate];
            
            return;
        }
    
    }
    //!< 到达终点的时候结束动画
    if (coord.latitude == 0 && coord.longitude == 0)
    {
        [self endAnimate];
        
        [self.navigationController popViewControllerAnimated:YES];//!< 播放完成返回
        
        return;
    }
     CLLocationCoordinate2D previous = marker.position;
    
//     CLLocationDirection heading = GMSGeometryHeading(previous, coord);
    
    float arc = [XMArcConvert convertArcWithPointA:previous Pb:coord];

    
 //    CLLocationDistance distance = GMSGeometryDistance(previous, coord);
     [CATransaction begin];
 //    [CATransaction setAnimationDuration:(distance / (30/10 * 1000))];  // custom duration, 50km/sec
//    [CATransaction setAnimationDuration:self.duration];
    
    [CATransaction setAnimationDuration:1];
    __weak XMGoogleMapEnlargeViewController *weakSelf = self;
     [CATransaction setCompletionBlock:^{
        
        [weakSelf animateToNextCoord:marker];
        
    }];
     marker.position = coord;
    
    [CATransaction commit];
    
    // If this marker is flat, implicitly trigger a change in rotation, which will finish quickly.
    if (marker.flat) {
        marker.rotation = arc;
    }
    

    
}

/**
 *  开始动画
 */
- (void)startAnimate
{
    
//    _controlView.progress = 0;
    
//    _animateMarker.map = _mapView;
    if(_animateMarker.map == nil)
    {
        _animateMarker.map = _mapView;
    }
    
    CoordsList *coods =  _animateMarker.userData;
    
    coods.continueAnimate = YES;//!< 可以开始动画
    
    [self animateToNextCoord:_animateMarker];
    
}

/**
 *  结束动画
 */
- (void)endAnimate
{
    _controlView.progress = 0;
    
    _animateMarker.map = nil;
    
    CoordsList *coods =  _animateMarker.userData;
    
    coods.continueAnimate = NO;//!< 停止动画
    
    coods.target = 1;
    
    _animateMarker.position = [coods.path coordinateAtIndex:1];

}


/**
 * 暂停动画
 */
- (void)pauseAnimate
{
   
    CoordsList *coods =  _animateMarker.userData;
    
    coods.continueAnimate = NO;
    
}

/**
 添加事件

 @param index 下标
 */
- (void)addEvent:(NSInteger)index
{
    
         GMSMarker *marker_ecenttype = [self.locationModels[index] getMarker];
    
        if (marker_ecenttype)
        {
            marker_ecenttype.map = _mapView;

            marker_ecenttype.icon = [UIImage imageNamed:@"event icon"];
        }

    [self addOverlay:index];
}


/**
 添加遮盖

 @param index 下标
 */
- (void)addOverlay:(NSInteger)index
{
    
    JJGPSModel *model1 = self.locationModels[index];
    
    if (index + 1 >= self.locationModels.count)
    {
        return;
    }
    
    JJGPSModel *model2 = self.locationModels[index + 1];
    
    GMSMutablePath *path = [GMSMutablePath path];
   
  
    [path addCoordinate:model1.location.coordinate];
    
    [path addCoordinate:model2.location.coordinate];
        
    
    //!< 添加overlay 最底层的遮盖，
        GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
        polyline.strokeColor =  XMColor(100, 170, 216); //XMColor(100, 170, 216);170,171,255
        
        polyline.geodesic = YES;
        
        polyline.strokeWidth = 4;
        
        polyline.map = _mapView;
    
}


@end
