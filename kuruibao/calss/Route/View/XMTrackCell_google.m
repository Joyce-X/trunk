//
//  XMTrackCell_google.m
//  kuruibao
//
//  Created by x on 17/6/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMTrackCell_google.h"
#import "NSString+extention.h"
#import "AFNetworking.h"
#import "NSDictionary+convert.h"
#import "XMUser.h"
#import "JZLocationConverter.h"
#import "JJGPSModel.h"
#import <GoogleMaps/GoogleMaps.h>

#define pi 3.14159265358979323846

#define degreesToRadian(x) (pi * x / 180.0)

#define radiansToDegrees(x) (180.0 * x / pi)

#define animationTime 20

/**********************************************************
 class description:自定义轨迹界面cell 使用百度地图
 
 **********************************************************/



@interface XMTrackCell_google()<GMSMapViewDelegate>

@property (strong, nonatomic) AFHTTPSessionManager *session;

@property (weak, nonatomic) GMSMapView *mapView;//!< 谷歌地图

@property (strong, nonatomic) GMSGeocoder *geocoder;//!< 谷歌地理编码类

@property (nonatomic,weak)UILabel* startAddressLabel;//!< 起始点位置

@property (nonatomic,weak)UILabel* endAddressLabel;//!< 结束点位置

@property (nonatomic,weak)UILabel* comfortScoreLabel;//!< 舒适度得分

@property (nonatomic,weak)UILabel* plusSpeedTimeLabel;//!< 急加速次数

@property (nonatomic,weak)UILabel* brakeTimeLabel;//!< 急刹车次数

@property (nonatomic,weak)UILabel* daisuTimeLabel;//!< 怠速时长

@property (nonatomic,weak)UILabel* distanceLabel;//!< 行驶里程

@property (nonatomic,weak)UILabel* oilConsumptionLabel;//!< 油耗

@property (nonatomic,weak)UILabel* trackTimeLabel;//!< 行驶时长

@property (nonatomic,weak)UIImageView* startIV;//!< 起始点图标

@property (nonatomic,weak)UILabel* jiasuLabel;//!< 显示”急加油“

@property (nonatomic,weak)UILabel* shaCheLabel;//!<  显示“急刹车”

@property (nonatomic,weak)UILabel* daiSuLabel;//!<  显示“怠速”

@property (nonatomic,weak)UIImageView* distanceIV;//!< 显示行驶里程图片

@property (nonatomic,weak)UIImageView* oilConsumptionIV;//!< 显示油耗图片

@property (nonatomic,weak)UIImageView* trackTimeIV;//!< 显示行驶时间图片

@property (nonatomic,weak)UIImageView* endIV;//!< 显示结束地址的图片

@property (weak, nonatomic) UIButton *jumpBtn;//!< 地图上覆盖的按钮，点击进行页面跳转

@property (assign, nonatomic) BOOL isStart;//!< 区分逆地理编码 开始点还是结束点

@property (assign, nonatomic) double totalDistance;

@end

@implementation XMTrackCell_google

////!< 计算两点间距离
//CGFloat distanceBetweenPoints (CGPoint first, CGPoint second) {
//    CGFloat deltaX = second.x - first.x;
//    CGFloat deltaY = second.y - first.y;
//    return sqrt(deltaX*deltaX + deltaY*deltaY );
//}
//
//
//
////!< 计算两点之间角度
//CGFloat angleBetweenPoints(CGPoint first, CGPoint second) {
//    CGFloat height = second.y - first.y;
//    CGFloat width = first.x - second.x;
//    CGFloat rads = atan(height/width);
//    return radiansToDegrees(rads);
//    //degs = degrees(atan((top - bottom)/(right - left)))
//}

+ (instancetype)dequeueReuseableCellWith:(UITableView *)tableView
{
    static NSString *identifier = @"TrackCell_goole";
    
    XMTrackCell_google *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil) {
        
        cell = [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
        XMLOG(@"---------Joyce - create baidu map cell---------");
    }
    
    return cell;
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        //!< 构造搜索管理者
//        _geocodesearch = [[BMKGeoCodeSearch alloc]init];
//        
//        _geocodesearch.delegate = self;
        
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.isStart = YES;
        
        [self addSubviews];
        
        
    }
    
    return self;
    
}

- (void)addSubviews
{
    
    self.geocoder = [[GMSGeocoder alloc]init];
    //!< 添加起始点图标
    UIImageView *startIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track_ovalCircle"]];
    
    [self.contentView addSubview:startIV];
    
    self.startIV = startIV;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 添加起始点位置label
    UILabel *startAddress = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentLeft];
    
    startAddress.text = JJLocalizedString(@"起点位置", nil);
    
    startAddress.numberOfLines = 0;
    
    [self.contentView addSubview:startAddress];
    
    self.startAddressLabel = startAddress;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< t地图
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:39.915325
                                                            longitude:116.404112
                                                                 zoom:14];
    
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectMake(0, 0, 100, 100) camera:camera];
//    GMSMapView *mapView = [GMSMapView new];
    
    mapView.delegate = self;
    
    mapView.myLocationEnabled = NO;
    
    mapView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    mapView.layer.borderWidth = 1;
    
    //    _mapView.logoPosition =
    
    [self.contentView addSubview:mapView];
    
    self.mapView = mapView;
    
    
    //!< 在地图上添加按钮，点击时候进行页面跳转
    UIButton *jumpBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [jumpBtn addTarget:self action:@selector(jumpBtnClick: event:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:jumpBtn];
    
    self.jumpBtn = jumpBtn;
    
    
    //!< 舒适度得分
    UILabel *comfortScore = [self labelWithFont:63 textColor:nil textAlignment:NSTextAlignmentCenter];
    
    comfortScore.text = JJLocalizedString(@"00", nil);
    
    comfortScore.adjustsFontSizeToFitWidth = YES;
    
    [self.contentView addSubview:comfortScore];
    
    self.comfortScoreLabel = comfortScore;
    
    //-----------------------------seperate line---------------------------------------//
    
    CGFloat fontSize;
    
    if (mainSize.width < 375)
    {
        fontSize = 11;
        
    }else
    {
        fontSize = 14;
        
    }
    
    //!< 急加速
    UILabel *jiasuLabel = [self labelWithFont:fontSize textColor:nil textAlignment:NSTextAlignmentLeft];
    
    jiasuLabel.text = JJLocalizedString(@"急加油:", nil);
    
    [self.contentView addSubview:jiasuLabel];
    
    self.jiasuLabel = jiasuLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 急刹车
    UILabel *shaCheLabel = [self labelWithFont:fontSize textColor:nil textAlignment:NSTextAlignmentLeft];
    
    shaCheLabel.text = JJLocalizedString(@"急刹车:", nil);
    
    [self.contentView addSubview:shaCheLabel];
    
    self.shaCheLabel = shaCheLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 怠速
    UILabel *daiSuLabel = [self labelWithFont:fontSize textColor:nil textAlignment:NSTextAlignmentLeft];
    
    daiSuLabel.text = JJLocalizedString(@"怠   速:", nil);
    
    [self.contentView addSubview:daiSuLabel];
    
    self.daiSuLabel = daiSuLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    
    
    //!< 显示急加油次数
    UILabel *plusSpeenLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentCenter];
    
    plusSpeenLabel.text = @"0";
    
    [self.contentView addSubview:plusSpeenLabel];
    
    self.plusSpeedTimeLabel = plusSpeenLabel;
    
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示急刹车次数
    UILabel *brakeLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentCenter];
    
    brakeLabel.text = @"0";
    
    [self.contentView addSubview:brakeLabel];
    
    self.brakeTimeLabel = brakeLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示怠速时间
    UILabel *daisuTimeLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentCenter];
    
    daisuTimeLabel.text = JJLocalizedString( @"0s", nil);
    
    [self.contentView addSubview:daisuTimeLabel];
    
    self.daisuTimeLabel = daisuTimeLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示行驶里程
    UIImageView *distanceIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track_distance"]];
    
    [self.contentView addSubview:distanceIV];
    
    self.distanceIV = distanceIV;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示油耗图片
    UIImageView *oilConsumptionIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track_averageOilConsumption"]];
    
    [self.contentView addSubview:oilConsumptionIV];
    
    self.oilConsumptionIV = oilConsumptionIV;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示行驶时间图片
    UIImageView *trackTimeIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track_time"]];
    
    [self.contentView addSubview:trackTimeIV];
    
    self.trackTimeIV = trackTimeIV;
    
    
    //-----------------------------seperate line---------------------------------------//
    //!< 行驶距离的label
    UILabel *distanceLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentLeft];
    
    distanceLabel.text = JJLocalizedString(@"00km", nil);
    
    [self.contentView addSubview:distanceLabel];
    
    self.distanceLabel = distanceLabel;
    
    //-----------------------------seperate line---------------------------------------//
    //!< 油耗的label
    UILabel *oilConsumptionLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentLeft];
    
    oilConsumptionLabel.text = JJLocalizedString(@"00.0L", nil);
    
    [self.contentView addSubview:oilConsumptionLabel];
    
    self.oilConsumptionLabel = oilConsumptionLabel;
    
    
    //-----------------------------seperate line---------------------------------------//
    //!< 行驶时间的label
    UILabel *trackTimeLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentLeft];
    
    trackTimeLabel.text = JJLocalizedString(@"01:02:03", nil);
    
    [self.contentView addSubview:trackTimeLabel];
    
    self.trackTimeLabel = trackTimeLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 添加显示结束图片的IV
    UIImageView *endIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"track_circle"]];
    
    [self.contentView addSubview:endIV];
    
    self.endIV = endIV;
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 显示结束地址的label
    UILabel *endAddressLabel = [self labelWithFont:14 textColor:nil textAlignment:NSTextAlignmentLeft];
    
    
    endAddressLabel.numberOfLines = 0;
    
    [self.contentView addSubview:endAddressLabel];
    
    self.endAddressLabel = endAddressLabel;
    
    //-----------------------------seperate line---------------------------------------//
    
    
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    [_startAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.contentView).offset(2);
        
        make.left.equalTo(self.contentView).offset(43);
        
        make.height.equalTo(40);
        
        make.right.equalTo(self.contentView).offset(-17);
        
        
    }];
    
    
    [_startIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(18);
        
        make.size.equalTo(CGSizeMake(10, 10));
        
        make.centerY.equalTo(_startAddressLabel);
    }];
    
    
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(FITWIDTH(215), 100));
        
        make.right.equalTo(self.contentView).offset(-17);
        
        make.top.equalTo(_startAddressLabel.mas_bottom).offset(10);
        
    }];
    
    [_jumpBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.top.bottom.equalTo(_mapView);
        
    }];
    
    
    //    CGSize size = [@"100" sizeWithFont:[UIFont systemFontOfSize:63]];
    
    [_comfortScoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_mapView).offset(-7);
        
        make.left.equalTo(self.contentView).offset(10);
        
        make.height.equalTo(46);
        
        make.right.equalTo(_mapView.mas_left).offset(-13);
        
        
    }];
    
    
    CGFloat fontSize;
    
    if (mainSize.width < 375)
    {
        fontSize = 12;
        
    }else
    {
        fontSize = 14;
        
    }
    CGFloat width = [@"急加油:" getWidthWith:fontSize];
    
    [_jiasuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_comfortScoreLabel);
        
        make.top.equalTo(_comfortScoreLabel.mas_bottom).offset(13);
        
        make.size.equalTo(CGSizeMake(width, 12));
        
        
    }];
    
    [_shaCheLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_jiasuLabel);
        
        make.top.equalTo(_jiasuLabel.mas_bottom).offset(5);
        
        make.size.equalTo(_jiasuLabel);
        
    }];
    //
    [_daiSuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_shaCheLabel);
        
        make.top.equalTo(_shaCheLabel.mas_bottom).offset(5);
        
        make.size.equalTo(_shaCheLabel);
        
    }
     ];
    //
    [_plusSpeedTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_jiasuLabel.mas_right);
        
        make.top.equalTo(_jiasuLabel);
        
        make.bottom.equalTo(_jiasuLabel);
        
        make.right.equalTo(_mapView.mas_left);
        
        
    }];
    //
    [_brakeTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_shaCheLabel.mas_right);
        
        make.top.equalTo(_shaCheLabel);
        
        make.bottom.equalTo(_shaCheLabel);
        
        make.right.equalTo(_mapView.mas_left);
        
        
    }];
    //
    [_daisuTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_daiSuLabel.mas_right);
        
        make.top.equalTo(_daiSuLabel);
        
        make.bottom.equalTo(_daiSuLabel);
        
        make.right.equalTo(_mapView.mas_left);
        
    }];
    
    [_distanceIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(10);
        
        make.top.equalTo(_mapView.mas_bottom).offset(7);
        
        make.size.equalTo(CGSizeMake(15, 15));
        
    }];
    
    [_oilConsumptionIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(FITWIDTH(125));
        
        make.top.equalTo(_distanceIV);
        
        make.size.equalTo(_distanceIV);
        
        
    }];
    
    [_trackTimeIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(_distanceIV);
        
        make.size.equalTo(_distanceIV);
        
        make.right.equalTo(self.contentView).offset(-FITWIDTH(76));
        
        
    }];
    
    [_distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_distanceIV.mas_right).offset(10);
        
        make.bottom.equalTo(_distanceIV);
        
        make.height.equalTo(12);
        
        make.right.equalTo(_oilConsumptionIV.mas_left);
        
    }];
    
    
    [_oilConsumptionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_oilConsumptionIV.mas_right).offset(10);
        
        make.height.equalTo(12);
        
        make.bottom.equalTo(_oilConsumptionIV);
        
        make.right.equalTo(_trackTimeIV.mas_left);
        
    }];
    
    [_trackTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(_trackTimeIV.mas_right).offset(10);
        
        make.bottom.equalTo(_trackTimeIV);
        
        make.height.equalTo(12);
        
        make.right.equalTo(self.contentView).offset(5);
        
        
    }];
    
    
    
    [_endAddressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView).offset(43);
        
        make.top.equalTo(_distanceIV.mas_bottom).offset(10);
        
        make.right.equalTo(_mapView);
        
        make.height.equalTo(40);
        
    }];
    
    
    [_endIV mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(10, 10));
        
        make.left.equalTo(self.contentView).offset(18);
        
        make.centerY.equalTo(_endAddressLabel) ;
        
        
    }];
    
    
    
    
}

-(void)setSegmentData:(XMTrackSegmentStateModel *)segmentData
{
    
    [_mapView clear];
    
    _segmentData = segmentData;
    
    self.comfortScoreLabel.text = segmentData.comfortscore;
    
    self.plusSpeedTimeLabel.text = segmentData.jijiayou;
    
    self.brakeTimeLabel.text = segmentData.jishache;
    
    self.daisuTimeLabel.text = [segmentData.daisuTime stringByAppendingString:@"s"];
    
    self.distanceLabel.text = [segmentData.licheng stringByAppendingString:@"km"];
    
    self.oilConsumptionLabel.text = [segmentData.penyou stringByAppendingString:@"L"];
    
    self.trackTimeLabel.text = segmentData.xingshiTime;
    
    self.startAddressLabel.text = JJLocalizedString(@"正在定位...", nil);
    
    self.endAddressLabel.text = JJLocalizedString(@"正在定位...", nil);
    
    self.isStart = YES;
    
//    [self hideLogo];//!< 隐藏百度logo
    
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
            
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        self.startAddressLabel.text = JJLocalizedString(@"定位失败", nil);
        
        self.endAddressLabel.text = JJLocalizedString(@"定位失败", nil);
        
    }];
    
    
    
    
    
    
}




//!< 解析请求来的位置数据
- (void)parserLocationData:(NSArray <JJGPSModel *> *)array
{
    
    //!< 添加起点
    GMSMarker *startMarker = [GMSMarker markerWithPosition:[array.firstObject.location coordinate]];
    
    startMarker.icon = [UIImage imageNamed:@"annotation_start"];
    
    startMarker.map = _mapView;
    
    //!< 设置cell的中心点坐标
    self.coor = startMarker.position;
    
    //!< 添加终点
    GMSMarker *endMarker = [GMSMarker markerWithPosition:[array.lastObject.location coordinate]];
    
    endMarker.icon = [UIImage imageNamed:@"annotation_end"];
    
    endMarker.map = _mapView;
    
    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
    
    bounds =  [bounds includingCoordinate:[array.firstObject.location coordinate]];
    
    bounds =  [bounds includingCoordinate:[array.lastObject.location coordinate]];
    
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withPadding:30.0f];
    
    [_mapView moveCamera:update];
    
    
    //!< 对起点和终点进行逆地理编码
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
    
    
    GMSReverseGeocodeCallback handler_S = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = response.firstResult;
        
        
        if (error)
        {
            self.startAddressLabel.text = JJLocalizedString(@"定位失败", nil);
            
            XMLOG(@"start--------%@---------",error);
            
        }else
        {
            NSString *text = [address.administrativeArea stringByAppendingString:address.locality ? address.locality : @""];
            
            text = [text stringByAppendingString:address.subLocality ? address.subLocality : @""];
            
            text = [text stringByAppendingString:address.thoroughfare ? address.thoroughfare : @""];
            
            //!< 起点位置
            self.startAddressLabel.text = text;
            
        }
         
    };
    [_geocoder reverseGeocodeCoordinate:startCoor completionHandler:handler_S];
    
    GMSReverseGeocodeCallback handler_E = ^(GMSReverseGeocodeResponse *response, NSError *error) {
        GMSAddress *address = response.firstResult;
        
        
        if (error)
        {
            self.endAddressLabel.text = JJLocalizedString(@"定位失败", nil);
            
            XMLOG(@"end--------%@---------",error);
            
        }else
        {
            NSString *text = [address.administrativeArea stringByAppendingString:address.locality];
            
            text = [text stringByAppendingString:address.subLocality ? address.subLocality : @""];
            
            text = [text stringByAppendingString:address.thoroughfare ? address.thoroughfare : @""];
            
            //!< 终点位置 
            self.endAddressLabel.text = text;
            
        }
        
    };
    [_geocoder reverseGeocodeCoordinate:endCoor completionHandler:handler_E];
 
    
   
    
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
    }
    return _session;
    
}



#pragma mark -------------- tool method

//!< 创建label

- (UILabel *)labelWithFont:(float)font textColor:(UIColor *)textColor textAlignment:(NSTextAlignment)textAlignment
{
    UILabel *label = [UILabel new];
    
    label.backgroundColor = [UIColor clearColor];
    
    label.textAlignment = textAlignment;
    
    label.textColor = [UIColor whiteColor];
    
    label.lineBreakMode = NSLineBreakByTruncatingTail;
    
    label.font = [UIFont systemFontOfSize:font];
    
    return label;
}


- (void)jumpBtnClick:(UIButton *)sender event:(UIEvent *)event
{
    if (_clickEnlarge)
    {
        _clickEnlarge(sender,event);//!< 回调通知控制器
    }
    
}



@end
