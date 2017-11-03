//
//  XMGGMapCell.m
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMGGMapCell.h"
#import "NSString+extention.h"
#import "AFNetworking.h"
#import "NSDictionary+convert.h"
#import "XMUser.h"
#import "JZLocationConverter.h"
 
#import <GoogleMaps/GoogleMaps.h>
#import "XMMapCeeInsertView.h"

@interface XMGGMapCell ()<GMSMapViewDelegate>

@property (strong, nonatomic) AFHTTPSessionManager *session;

@property (weak, nonatomic) GMSMapView *mapView;//!< 谷歌地图

@property (weak, nonatomic) UIButton *jumpBtn;//!< 地图上覆盖的按钮，点击进行页面跳转

@property (assign, nonatomic) double totalDistance;

@property (weak, nonatomic) UIButton *iconBtn;//!< 显示图标

@property (weak, nonatomic) XMMapCeeInsertView *smallView;//!< 显示文字

@end

@implementation XMGGMapCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XMClearColor;
        
        [self addSubviews:frame];
        
    }
    return self;
}



- (void)addSubviews:(CGRect)frame
{

    //!< t地图
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.915325
                                                            longitude:116.404112
                                                                 zoom:14];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 32, frame.size.width, frame.size.height - 32) camera:camera];
    
    mapView.delegate = self;
    
    mapView.myLocationEnabled = NO;
    
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    mapView.layer.borderWidth = 1;
    
    mapView.userInteractionEnabled = NO;
    
    [self.contentView addSubview:mapView];
    
    self.mapView = mapView;
    
    
    //!< 添加图标
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn setImage:[UIImage imageNamed:@"r r"] forState:UIControlStateNormal];
    
    [btn setImage: [UIImage imageNamed:@"r r"] forState:UIControlStateHighlighted];
    
    btn.userInteractionEnabled = NO;
    
    btn.frame = CGRectMake(13, 0, 64, 64);
    
    [self.contentView addSubview:btn];
    
    self.iconBtn = btn;
    
    //!< 添加显示view
    XMMapCeeInsertView *view = [[NSBundle mainBundle] loadNibNamed:@"XMMapCellInsertView" owner:nil options:nil].firstObject;
    
    view.alpha = 0.85;
    
    view.backgroundColor = XMColor(248, 248, 248);
    
    view.frame = CGRectMake(20, 72, 225, 88);
    
    [self.contentView addSubview:view];
    
    self.smallView = view;
    
    //!< 在地图上添加按钮，点击时候进行页面跳转
//    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    jumpBtn.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
//    
//    [jumpBtn addTarget:self action:@selector(jumpBtnClick: event:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.contentView addSubview:jumpBtn];
//    
//    self.jumpBtn = jumpBtn;
    
     
    
}
 

- (void)setState:(BOOL)state
{
    
    self.iconBtn.selected = state;

}

-(void)setSegmentData:(XMTrackSegmentStateModel *)segmentData
{
    
    [_mapView clear];
    
    _segmentData = segmentData;
    
    //!< 开始时间
    NSString *startTime = [segmentData.starttime componentsSeparatedByString:@"T"].lastObject;
    
    //!< 结束时间
    NSString *endTime = [segmentData.endtime componentsSeparatedByString:@"T"].lastObject;
    
    self.smallView.distanceLabel.text = [XMUnitConvertManager convertKmToMile:segmentData.licheng.floatValue];
    
    //[NSString stringWithFormat:@"%@km",segmentData.licheng];
    
    self.smallView.startTimeLabel.text = startTime;
    
    self.smallView.endTimeLabel.text = endTime;
    
    //!< 解析一段行程的GPS数据，在解析之前进行判断，可能会存在数据没有上到服务器的情况
    [self searchLocation];
    
    
    
}

- (void)searchLocation
{
    
    //!< 获取一段行程内的GPS数据
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_xc_gps_byxcid&qicheid=%@&Xingchengid=%@",_qicheid,self.segmentData.xingchengid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if (result.length > 2)
        {
            //!< 获取GPS数据成功
            NSArray *locationArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            //!< 对获取到的GPS数据进行处理，如果在国内就转换成gcj坐标，如果在国外就转换成GPS坐标
            locationArray = [JZLocationConverter handelCoordinate:locationArray];
            
            [self parserLocationData:locationArray];
            
            self.hasLocationPoints = YES;
            
        }else
        {
            
            self.hasLocationPoints = NO;
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];

}

//!< 解析请求来的位置数据
- (void)parserLocationData:(NSArray <JJGPSModel *> *)array
{
    
    //!< 添加起点
    GMSMarker *startMarker = [GMSMarker markerWithPosition:[array.firstObject.location coordinate]];
    
    startMarker.icon = [UIImage imageNamed:@"starticon_us"];
    
    startMarker.map = _mapView;
    
    //!< 设置cell的中心点坐标
    self.coor = startMarker.position;
    
    //!< 添加终点
    GMSMarker *endMarker = [GMSMarker markerWithPosition:[array.lastObject.location coordinate]];
    
    endMarker.icon = [UIImage imageNamed:@"end icon"];
    
    endMarker.map = _mapView;
    
    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
    
    bounds =  [bounds includingCoordinate:[array.firstObject.location coordinate]];
    
    bounds =  [bounds includingCoordinate:[array.lastObject.location coordinate]];
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:30.0f];
    
    [_mapView moveCamera:update];
    
    
    //!< 对起点和终点进行逆地理编码
    /*
    CLLocationCoordinate2D startCoor,endCoor;
    //!< 在地理编码的时候需要从gcj-02坐标转回wgs坐标  当前坐标可能的wgs，也可能是gcj坐标，如果是gcj则需要转回wgs进行地理编码
    
    if(![JZLocationConverter outOfChina:startMarker.position.latitude bdLon:startMarker.position.longitude])
    {
        // GCJ - WGS
        startCoor = [JZLocationConverter gcj02ToWgs84:startMarker.position];
        
        
    }else
    {
        
        startCoor = startMarker.position;
    }
    
    if(![JZLocationConverter outOfChina:endMarker.position.latitude bdLon:endMarker.position.longitude])
    {
        // GCJ - WGS
        endCoor = [JZLocationConverter gcj02ToWgs84:endMarker.position];
        
        
    }else
    {
        
        endCoor = endMarker.position;
    }
    
     */
    
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (JJGPSModel *loca in array)
    {
        [path addCoordinate:loca.location.coordinate];
    }
    
    //!< 添加overlay
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
    polyline.strokeColor = XMColor(100, 170, 216);
    
    polyline.geodesic = YES;
    
    polyline.strokeWidth = 4;
    
    polyline.map = _mapView;
    
    
}





#pragma mark ---------- lazy
-(AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer = [AFHTTPRequestSerializer serializer];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _session.requestSerializer.timeoutInterval = 10;
         [_session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    }
    return _session;
    
}



#pragma mark -------------- tool method


//- (void)jumpBtnClick:(UIButton *)sender event:(UIEvent *)event
//{
// 
//    if (self.delegate && [self.delegate respondsToSelector:@selector(mapCellDidSelectCell:)])
//    {
//        [self.delegate mapCellDidSelectCell:self];
//    }
//    
//    XMLOG(@"---------点击按钮了---------");
//  
//}

@end
