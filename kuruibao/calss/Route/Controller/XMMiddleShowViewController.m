//
//  XMMiddleShowViewController.m
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleShowViewController.h"
#import <GoogleMaps/GoogleMaps.h>

#import "XMUser.h"

#import "XMTrackLocationModel.h"

#import "NSDictionary+convert.h"

//#import "XMAnimateAnnotation.h"

#import "JZLocationConverter.h"

#import "JJGPSModel.h"

#import "CoordsList.h"

#import "JJColorCalculater.h"

#import "XMShareView.h"

#import "XMMiddleScrollView.h"

#import "XMGoogleMapEnlargeViewController.h"

//#import <ShareSDK/ShareSDK.h>

#import <MOBFoundation/MOBFoundation.h>

#define animationFactor 10 //动画时长系数，参数越小，动画时间越长

#define panHeight 463 //panView的高度



@interface XMMiddleShowViewController ()<GMSMapViewDelegate,XMShareViewDelegate,XMMiddleScrollViewDelegate,UIDocumentInteractionControllerDelegate>
{
    GMSMarker *_fadedMarker;
}

@property (strong, nonatomic) XMShareView *shareView;

@property (strong, nonatomic) GMSMapView *mapView;

@property (strong, nonatomic) UIImage *shareImage;//!< 需要分享的图片

/**
 动画的时间
 */
@property (assign, nonatomic) float animationTime;

@property (weak, nonatomic) XMMiddleScrollView *panView;//!< 手势操作的view

@property (strong, nonatomic)NSArray<JJGPSModel *> *locationArr;//!< 坐标模型数组，传到下一界面用到

@property (strong, nonatomic) XMUser *user;

@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;

@end

@implementation XMMiddleShowViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //!< 初始化界面
    [self setupSubviews];
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    self.shareImage = [self getShareImage];
    
}

- (void)setupSubviews
{
    
      self.user = [XMUser user];
    
    self.view.backgroundColor = XMWhiteColor;
    
    //!< 添加地图
    self.mapView = [[GMSMapView alloc]init];
    
    _mapView.delegate = self;
    
    _mapView.myLocationEnabled = NO;
    
    [self.view addSubview:_mapView];
    
    [_mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.right.left.bottom.equalTo(self.view);
        
    }];
    
    //!< 返回按钮和分享按钮
    self.showBackArrow = YES;
    
    UIButton *backBtn = [self.view viewWithTag:7778];
    
    [backBtn setImage:[UIImage imageNamed:@"backicon_us"] forState:UIControlStateNormal];
    
    [self.view bringSubviewToFront:backBtn];
    
    //!< 添加分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [shareBtn setImage:[UIImage imageNamed:@"shareIcon_us"] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(shareBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(53);
        
        make.right.equalTo(self.view).offset(-25);
        
        make.size.equalTo(CGSizeMake(35, 36));
        
    }];
    
    shareBtn.contentEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    
    //!< 添加色块
//    CAGradientLayer *layer = [[CAGradientLayer alloc]init];
//    
//    layer.frame = CGRectMake(20, 150, 25, 150);
//    
//    layer.colors = @[(id)XMColor(minR, minG, minB).CGColor,(id)XMColor(maxR, maxG, maxB).CGColor];
//    
//    layer.startPoint = CGPointMake(0.5, 0);
//    
//    layer.endPoint = CGPointMake(0.5, 1);
//    
//    [self.view.layer addSublayer:layer];
    
    if([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus == AFNetworkReachabilityStatusNotReachable)
    {
//        [MBProgressHUD showError:@"网络未连接"];return;
    }
    

    
    
    
    //!< 开始转模型，查找位置，添加遮盖
    [self searchLocation];
    
    //!< 显示到用户的定位位置，避免自动显示到一些不相干的地方
    if (self.coor.latitude != 0 && self.coor.longitude != 0)
    {
        [_mapView animateToLocation:self.coor];
        
        [_mapView animateToZoom:15];
    }
    
    //!< 添加需要手势的view
    XMMiddleScrollView *panView = [[NSBundle mainBundle] loadNibNamed:@"XMMiddleScrollView" owner:nil options:nil].firstObject;
    
    panView.frame = CGRectMake(15, mainSize.height - 134, mainSize.width - 30, panHeight);

    panView.delegate = self;
    
    panView.model = self.segmentData;
    
    [self.view addSubview:panView];
    
    self.panView = panView;
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    
    [panView addGestureRecognizer:pan];
    
   
}
 
#pragma mark ------- btn click

/**
 *  点击分享按钮
 */
- (void)shareBtnClick
{
    
    NSString* savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.png"];
    
    [UIImageJPEGRepresentation([self getShareImage], 1.0) writeToFile:savePath atomically:YES];
    
    _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
    
    _documentInteractionController.UTI = @"net.whatsapp.image";
    
    _documentInteractionController.delegate = self;
    
    [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
    
    
    return;
    
    
    XMLOG(@"---------click share btn---------");
    if (self.shareView == nil)
    {
        self.shareView = [[NSBundle mainBundle] loadNibNamed:@"XMShareView" owner:nil options:nil].firstObject;
        
        self.shareView.delegate = self;
        
        [self.view addSubview:self.shareView];
    }
    
    [_panView scrollToBottom];//!< 隐藏显示视图,实时监控的视图滑动到底部
    
    [self.shareView animateToShow];//!< 显示分享视图
    
}

/**
 *  响应手势
 */
- (void)pan:(UIPanGestureRecognizer *)sender
{
  
    
    if(sender.state == UIGestureRecognizerStateEnded){
    
        //!< 手势结束，
        CGFloat y = _panView.y;
        
        
        
        if (y >= mainSize.height - 134) {
            
            [UIView animateWithDuration:0.1 animations:^{
               
                _panView.y = mainSize.height - 134;
            }];
            
        }else if(y >= mainSize.height - 281 && y < mainSize.height - 134)
        {
            [UIView animateWithDuration:0.1 animations:^{
               
                _panView.y = mainSize.height - 281;
                
            }];
        }else
        {
            [UIView animateWithDuration:0.1 animations:^{
                
                _panView.y = mainSize.height - panHeight;
                
            }];
        
        }
    
    }else
    {
        //!< 手势开始和手势变化
        CGPoint p = [sender translationInView:sender.view];
        
        if (_panView.y <= mainSize.height - panHeight)
        {
            if (p.y>0)
            {
                self.panView.y += p.y;
            }else
            {
             _panView.y = mainSize.height - panHeight;
            }
        }else
        {
            self.panView.y += p.y;
            
        }
        [sender setTranslation:CGPointZero inView:sender.view];
    
    
    }
    
    
}


#pragma mark ------- searchLocaton

/**
 * @brief 获取当前行程id对应的一系列的坐标点
 */
- (void)searchLocation
{
  
    //!< 获取一段行程内的GPS数据
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_xc_gps_byxcid&qicheid=%@&Xingchengid=%@",_user.qicheid,self.segmentData.xingchengid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        XMLOG(@"---------%@---------",dic);
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.length > 2)
        {
            //!< 获取GPS数据成功
            
            NSArray *locationArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            //            locationArray = [NSDictionary nullDic:locationArray];
            
            //!< 对获取到的GPS数据进行处理，如果在国内就转换成gcj坐标，如果在国外就转换成GPS坐标  针对百度坐标
            
            //!< 因为目前服务器已经正常返回GPS坐标了，所以在国内就gps转02 国外不用处理
            locationArray = [JZLocationConverter handelCoordinate:locationArray];
            
            self.locationArr = locationArray;
            
            [self parserLocationData:locationArray];//!< 解析坐标数组
            
        }else
        {
            
            //!< 0 : 没有行程数据 1 :参数或网络错误
            [MBProgressHUD showError:JJLocalizedString(@"没有行程数据", nil)];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD showError:JJLocalizedString(@"获取数据失败", nil)];
    }];
    
}

//!< 解析请求来的位置数据
- (void)parserLocationData:(NSArray<JJGPSModel *> *)array
{
    CLLocation *slocation = array.firstObject.location;
    
    CLLocation *elocation = array.lastObject.location;
    
     //!< 显示起点和终点
    GMSCoordinateBounds *bounds = [GMSCoordinateBounds new];
   
    //!< 添加轨迹
    GMSMutablePath *path = [GMSMutablePath path];
    
    for (JJGPSModel *loca in array)
    {
        
        //!< 显示事件类型
         GMSMarker *marker_ecenttype = [loca getMarker];

         if (marker_ecenttype)
         {
             marker_ecenttype.map = _mapView;

             marker_ecenttype.icon = [UIImage imageNamed:@"event icon"];
         }
        
        [path addCoordinate:loca.location.coordinate];
        
        bounds = [bounds includingCoordinate:loca.location.coordinate];
        
    }
    
    //!< 添加overlay
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    
    polyline.strokeColor =  XMColor(100, 170, 216);//170,171,255 XMColor(100, 170, 216);
    
    polyline.geodesic = YES;
    
    polyline.strokeWidth = 4;
    
    polyline.map = _mapView;
    
    //!< 显示所有轨迹
    GMSCameraUpdate *update = [GMSCameraUpdate fitBounds:bounds withEdgeInsets:UIEdgeInsetsMake(90, 40, 140, 40)];
    
    [_mapView animateWithCameraUpdate:update];
    
     //测试代码 添加分段的遮盖
//     GMSMutablePath *temPath = [GMSMutablePath path];
//     
//     [temPath addCoordinate:slocation.coordinate];//!< 添加第一个点坐标
//     
//     JJGPSModel *lastModel = array.firstObject;//!< 上一个模型数据
//     
//     for(int i = 1;i < array.count;i++)
//     {
//         JJGPSModel *model = array[i];
//         
//         CLLocation *currentLocation = model.location;
//         
//         [temPath addCoordinate:currentLocation.coordinate]; //!< 添加当前点的坐标
//         
//         GMSPolyline *polyline = [GMSPolyline polylineWithPath:temPath];//!< 添加overlay
//         
//         //!< 计算颜色
//         polyline.strokeColor = [JJColorCalculater calculateColorWithFirstSpeed:lastModel.obdspeed secondSpeed:model.obdspeed];
//         
//         polyline.geodesic = YES;
//         
//         polyline.strokeWidth = 5;
//         
//         polyline.map = _mapView;
//         
//         [temPath removeCoordinateAtIndex:0];//!< 移除第一个坐标
//         
//         lastModel = model;
//         
//         
//         if(model == array[1])continue;//跳过起点,防止遮盖
//         if(model == array.lastObject)break;//!< 跳过终点
//         //!< 显示事件类型
//         GMSMarker *marker_ecenttype = [model getMarker];
//         
//         if (marker_ecenttype)
//         {
//             marker_ecenttype.map = _mapView;
//             
//             marker_ecenttype.icon = [UIImage imageNamed:@"event icon"];
//         }
//         
//     
//     
//     
//     }
    
    //!< 添加终点
    GMSMarker *endMarker = [GMSMarker markerWithPosition:[elocation coordinate]];
    
    endMarker.icon = [UIImage imageNamed:@"end icon"];
    
    endMarker.map = _mapView;

    //!< 添加起点
    GMSMarker *startMarker = [GMSMarker markerWithPosition:[slocation coordinate]];
    
    startMarker.icon = [UIImage imageNamed:@"starticon_us"];
    
    startMarker.map = _mapView;
}

#pragma mark ------- XMShareViewDelegate
- (void)shareViewClickFacebook:(XMShareView *)view
{
    XMLOG(@"---------shareViewClickFacebook---------");
//   [self shareWithType:SSDKPlatformTypeFacebook];
    
    

}
- (void)shareViewClickTwitter:(XMShareView *)view
{
    
//   [self shareWithType:SSDKPlatformTypeTwitter];

     XMLOG(@"---------shareViewClickTwitter---------");

}
- (void)shareViewClickWhatsapp:(XMShareView *)view
{
    
//    [self shareWithType:SSDKPlatformTypeWhatsApp];
    
    [view animateToHide];//!< 隐藏分享视图
    XMLOG(@"---------shareViewClickWhatsapp---------");
}

//- (void)shareWithType:(SSDKPlatformType)type
//{
//
//    //!< 判断网络
//    if (!connecting)
//    {
//        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
//        
//        return;
//    }
//    
//    NSMutableDictionary *shareParameterDic = [NSMutableDictionary dictionary];
//    
//    [shareParameterDic SSDKSetupShareParamsByText:JJLocalizedString(@"车小米智能网络科技股份有限公司", nil) images:@[self.shareImage] url:[NSURL URLWithString:JJLocalizedString(@"http://www.cesiumai.com", nil)] title:nil type:SSDKContentTypeImage];
//    
//    if (type != SSDKPlatformTypeTwitter) {
//        
//         [shareParameterDic SSDKEnableUseClientShare];
//    
//    }
//   
//    
//    [ShareSDK share:type parameters:shareParameterDic onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
//        
//        switch (state) {
//            case SSDKResponseStateSuccess:
//                
//                [MBProgressHUD showSuccess:JJLocalizedString(@"分享成功", nil)];
//                
//                XMLOG(@"---------分享成功---------");
//                
//                break;
//            case SSDKResponseStateFail:
//                
//                [MBProgressHUD showError:JJLocalizedString(@"分享失败", nil)];
//                
//                XMLOG(@"---------%@---------",error);
//                
//                
//                break;
//                
//            case SSDKResponseStateCancel:
//                
//                [MBProgressHUD showError:JJLocalizedString(@"分享取消", nil)];
//                
//                XMLOG(@"---------分享失败---------");
//                
//                break;
//                
//            default:
//                break;
//        }
//        
//    }];
//
//}

#pragma mark ------- XMMiddleScrollViewDelegate

/**
 点击跳转按钮，控制器执行跳转操作
 
 @param view trigger's super view
 */
- (void)scrollViewJumpBtnClick:(XMMiddleScrollView *)view
{
    
    //!< 判断当前点的数量是否足够，否则不显示
    if (self.locationArr.count < 4)
    {
        [MBProgressHUD showError:JJLocalizedString(@"没有足够的轨迹点", nil)];
        
        return;
    }
    
    XMGoogleMapEnlargeViewController * vc = [XMGoogleMapEnlargeViewController new];//!< 显示谷歌地图
    
    vc.segmentData = self.segmentData;
    
    vc.qicheid = self.qicheid;
   
    //!< 传递坐标模型数组
    vc.locationModels = self.locationArr;
    
    [self.navigationController pushViewController:vc animated:YES];


}

//!< 获取截屏
- (UIImage *)getShareImage
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    //    float x = 0;
    //    float y = 80 * [UIScreen mainScreen].scale;
    //    float w = image.size.width * [UIScreen mainScreen].scale;
    //    float h = image.size.height  * [UIScreen mainScreen].scale - y;
    //    CGImageRef cut = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, w, h));
    //
    //       UIImage *result = [UIImage imageWithCGImage:cut];
    //
    //    CFRelease(cut);
    
    return image;
    
    
    
}

@end
