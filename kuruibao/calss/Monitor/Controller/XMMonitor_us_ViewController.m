//
//  XMMonitor_us_ViewController.m
//  kuruibao
//
//  Created by x on 17/7/26.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMonitor_us_ViewController.h"
#import "XMHome_usScrollView.h"
#import "XMCircleView.h"
//#import "XMMessageViewController.h"
#import "XMMsgController.h"
#import "PathView.h"
#import "RYGradientAnimation.h"
#import "XMDataTool.h"
#import "XMScoreLabel.h"
#import "XMUser.h"
#import "XMDefaultCarModel.h"
#import "NSDictionary+convert.h"
#import "XMCar.h"
#import "JPUSHService.h"
#import "XMCheckingViewController.h"
#import "XMDetailTroubleController.h"
#import "CarManager.h"
#import "XMBadgeButton.h"
#import "XMActiveManager.h"
#import "XMVersionChecker.h"

#import "XMMainTabBarController.h"

#import "XMLoginNaviController.h"

#import "XMLoginViewController.h"

#import "MJExtension.h"

//#import <FBSDKLoginKit/FBSDKLoginKit.h>

@interface XMMonitor_us_ViewController ()<XMCheckingViewControllerDelegate,CarManagerDelegate,UIScrollViewDelegate,XMVersionCheckerDelegate,UIAlertViewDelegate>

/**
    消息按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *messageBtn;

/**
    分数
 */
@property (strong, nonatomic) XMScoreLabel *scoreLabel;

/**
 底部滑动视图
 */
@property (weak, nonatomic) XMHome_usScrollView *scrollView;

/**
 百分比动画view
 */
@property (weak, nonatomic) PathView *pathView;

@property (nonatomic,strong)XMDefaultCarModel* defaultCar;//->>当前默认车辆

@property (strong, nonatomic) NSArray *carList;//!< 用户所有车辆

/**
 更新实时数据的定时器
 */
@property (strong, nonatomic) NSTimer *realTimer;

@property (copy, nonatomic) NSString *Gpsdatetime;//!<上次定位时间，用来获取实时数据


/**
 检测到的问题项数组
 */
@property (strong, nonatomic) NSArray<NSDictionary *> *troubleArray;

@property (strong, nonatomic) CarManager *manager;//!< 车辆管理者

@property (weak, nonatomic) UIPageControl *pageControl;//!< 显示下标

@property (weak, nonatomic) XMBadgeButton *badgeBtn;//!< 显示未读消息数


@property (strong, nonatomic) XMVersionChecker *checker;//!< 负责检测新版本

@property (assign, nonatomic) BOOL hasNewVersion;//!< 标志是否有新版本

@end

@implementation XMMonitor_us_ViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        
        //!< 监听收到APNS通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveRemoteNotification:) name:kCheXiaoMiDidReceiveRemoteNotification object:nil];
        
        //!< 获取用户默认车辆
        [self getDefaultCarInfo];
        
        self.manager = [[CarManager alloc]init];
        
        self.manager.delegate = self;
        
        //!< 获取所有车辆
//        [self getUserAllCars];
        
         [self updatePushID];//!< 是否更新pushid
        
//        //!< 监听广告页加载完毕的通知
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ADDidFinishLaunch:) name:kXMDidFinishLaunchADNotiication object:nil];
        
       
        
    }
    
    return self;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setSubviews];
    
    [self addobserver];
    
    [self setData];
    
  
    
    //!< 监听通知
    if ([XMUser user].userid == 48)
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carInfoDidUpdate:) name:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
    }

}

- (void)addobserver
{
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    //!< 监听进入后台的通知
//    [center addObserver:self selector:@selector(applicationWillEnterBackground) name:UIApplicationWillResignActiveNotification object:nil];
//    
//    
//    //!< 监听进入前台的通知
//    [center addObserver:self selector:@selector(applicationWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    [center addObserver:self selector:@selector(defaultCarDidClick) name:kCheXiaoMiUserSetDefaultCarSuccessNotification object:nil];
    
    //默认车被编辑
    [center addObserver:self selector:@selector(defaultCarDidClick) name:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
    
    //!< 监听语言变化
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateText) name:kDashPalWillChangeLanguageNotification object:nil];
    
}


- (void)setSubviews
{
    
    //消息按钮的tag值是77 
    self.badgeBtn = [self.view viewWithTag:77];
    
    UILabel *titleLabel = [self.view viewWithTag:443];
    
    titleLabel.text = JJLocalizedString(@"车辆健康状态", nil);
    
    
    //!< 底圆 home_circle_us
    UIImageView *backCircle = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"origin"]];
    
    [self.view addSubview:backCircle];
    
    [backCircle mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(FITHEIGHT(204), FITHEIGHT(204)));
        
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(110));
        
        
    }];
    
    //!< 外圆
    PathView *circleView = [[PathView alloc]initWithFrame:CGRectMake(0, 0, FITHEIGHT(224), FITHEIGHT(224))];
    
    circleView.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:circleView];
    
    self.pathView = circleView;
    
    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(backCircle);
        
        make.size.equalTo(CGSizeMake(FITHEIGHT(224), FITHEIGHT(224)));
        
    }];
    
    
//    circleView.layer.transform = CATransform3DRotate(circleView.layer.transform , 2, 0, 1, 0);
    
    
    
    //!< 检测按钮
    UIButton *checkBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [checkBtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    
    [checkBtn addTarget:self action:@selector(checkBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
//    [self.view insertSubview:checkBtn belowSubview:backCircle];
    
    [self.view addSubview:checkBtn];
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(backCircle);
        
        make.size.equalTo(CGSizeMake(FITHEIGHT(138),FITHEIGHT(138)));
        
    }];
    
    //!< 分数label
    XMScoreLabel *scoreLabel = [XMScoreLabel new];
    
    scoreLabel.fontSize = 60;
    
    scoreLabel.score = 0;
    
    [self.view addSubview:scoreLabel];
    
    self.scoreLabel = scoreLabel;
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(backCircle).offset(-10);
        make.centerX.equalTo(backCircle).offset(3);
        make.size.equalTo(CGSizeMake(100, 35));
    }];
    
    
    
    
    //!< diagnostics Label
    UILabel *diagnosticsLabel = [UILabel new];
    diagnosticsLabel.adjustsFontSizeToFitWidth = YES;
    diagnosticsLabel.textColor = XMWhiteColor;
    diagnosticsLabel.tag = 110;
    diagnosticsLabel.text = JJLocalizedString(@"检测", nil);
    diagnosticsLabel.font = [UIFont boldSystemFontOfSize:14];
    diagnosticsLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:diagnosticsLabel];
    CGSize size2 = [JJLocalizedString(@"检测", nil) sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    [diagnosticsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(backCircle);
        make.top.equalTo(scoreLabel.mas_bottom).offset(6);
        make.size.equalTo(size2);
        
    }];
    
    //!< seperate line
    UIImageView *seperateLine1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_connectLine_us"]];
    
    [self.view addSubview:seperateLine1];
    
    [seperateLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(1);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(327));
        
    }];
    
     //!< 四大系统
    for (int i = 0; i < 4; i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        NSString *normalName = [NSString stringWithFormat:@"home_detail_normal_%d",i+1];
        
        NSString *highLightName = [NSString stringWithFormat:@"home_detail_highlight_%d",i+1];
        
        [btn setImage:[UIImage imageNamed:normalName] forState:UIControlStateNormal];
        
        [btn setImage:[UIImage imageNamed:highLightName] forState:UIControlStateSelected];
        
        btn.tag = i+101;
        
        btn.enabled = NO;
        
        btn.adjustsImageWhenHighlighted = NO;
        
        [btn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
       
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.top.equalTo(seperateLine1).offset(10);
            make.size.equalTo(CGSizeMake(FITWIDTH(94), FITHEIGHT(125)));
            make.left.equalTo(self.view).offset(FITWIDTH(94) * i);
            
        }];
 
        
    }
    
    
    UIImageView *seperateLine2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_connectLine_us"]];
    
    seperateLine2.alpha = 0;
    
    [self.view addSubview:seperateLine2];
    
    [seperateLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(1);
        
        make.top.equalTo(seperateLine1).offset(13 + FITHEIGHT(130));
        
    }];
    
    
    UIImageView *seperateLine3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_connectLine_us"]];
    
    [self.view addSubview:seperateLine3];
    
    [seperateLine3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(1);
        
        make.bottom.equalTo(self.view).offset(-49 - 13);
        
    }];
    
    
    //!< 添加滑动视图
    XMHome_usScrollView *scrollView = [XMHome_usScrollView new];
    
    scrollView.delegate = self;//!< 监听滑动，改变选中的点
    
    [self.view addSubview:scrollView];
    
    self.scrollView = scrollView;
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(seperateLine2).offset(13);
        
        make.bottom.equalTo(seperateLine3).offset(-13);
        
        
    }];
    
    //!< 添加pagecontrol
    
    UIPageControl *pageControl = [[UIPageControl alloc]init];
    
    pageControl.numberOfPages = 3;
    
    pageControl.pageIndicatorTintColor = XMGrayColor;
    
    pageControl.currentPageIndicatorTintColor = XMWhiteColor;
    
    pageControl.frame = CGRectMake((mainSize.width - 80) / 2, mainSize.height - 49 - 30, 80, 20);
    
    [self.view addSubview:pageControl];
    
    self.pageControl = pageControl;
    
    //!< 检测新版本
    self.checker = [[XMVersionChecker alloc]initWithDelegate:self];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    //!< 设置角标数
    self.badgeBtn.badgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber;
    
    //!< 判定是否有新版本
    if (_hasNewVersion)
    {
        _hasNewVersion = NO;//!< 每次运行只提示一次
        
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:JJLocalizedString(@"检测到新版本，是否更新", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"否", nil) otherButtonTitles:JJLocalizedString(@"是", nil), nil];
        
        alert.tag = 111;
        
        [alert show];
    }
  
   
    
    
    
}


- (void)shouldUpdateText
{
    
    [self.scrollView shouldUpdateText];
    
    UILabel *titleLabel = [self.view viewWithTag:443];
    
    titleLabel.text = JJLocalizedString(@"车辆健康状态", nil);
    
    UILabel *diagnosticsLabel = [self.view viewWithTag:110];;
    
    diagnosticsLabel.text = JJLocalizedString(@"检测", nil);
    
    
    CGSize size2 = [JJLocalizedString(@"检测", nil) sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14]}];
    
    [diagnosticsLabel updateConstraints:^(MASConstraintMaker *make) {
      
        make.size.equalTo(CGSizeMake(size2.width + 3,size2.height));
        
    }];
}


/**
 设置数据
 */
- (void)setData
{
    
    //!< 上次检测的数据  1设置显示分数
    NSInteger score = [XMDataTool getLastCheckScore];
    
    [self.scoreLabel animateToScore:score duration:1.2];
    
    //!< 2 设置圆弧显示
    [self.pathView animateWithDuration:1.2 percent:(float)score/100];
    
    
}



#pragma mark ------- btn click
//!< 点击消息按钮
- (IBAction)messageBtnClick:(UIButton *)sender {
    
    XMMsgController *vc = [XMMsgController new];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 点击体检按钮
 */
- (void)checkBtnClick
{
    //!< 判断网络
    if (!connecting) {
        
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];return;
        
    }
    //!< 判断默认车辆是否有值
    if (_defaultCar == nil)
    {
        //!< 未请求到默认车辆数据
        [self getDefaultCarInfo];
        
        [MBProgressHUD showError:JJLocalizedString(@"正在获取数据", nil)];
        
        return;
    }
    
    //!< 判断是否添加车辆
//    if (self.defaultCar.qicheid.integerValue < 1)
//    {
//        //!< 未添加车辆，没有汽车id
//        [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil)];
//        
//        return;
//    }
    //!< 判定用户是否添加车辆
    if(connecting && self.defaultCar && self.defaultCar.qicheid.integerValue < 1 && self.defaultCar.tboxid.integerValue < 1)
    {
        //!< 用户没有添加车辆，提醒用户添加汽车
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:JJLocalizedString(@"未添加车辆，是否添加", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"否", nil) otherButtonTitles:JJLocalizedString(@"是", nil), nil];
        
        alert.tag = 999;
        
        [alert show];
        
//        alert.transform = CGAffineTransformMakeRotation(20);
        
        
        return;
//        self.checker.hasNewVersion = YES;//!< 只加载一次
        
    }
    
    
    //!< 判断车辆是否激活
    if (self.defaultCar.tboxid.integerValue < 1)
    {
        [MBProgressHUD showError:JJLocalizedString(@"通讯失败", nil)];
        
        XMLOG(@"---------车辆未激活---，正在尝试激活------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆未激活---，正在尝试激活------"]];

        
        [XMActiveManager activeCarWithQicheid:self.defaultCar.qicheid];
        
        return;
    }
    
    /*
        1 判断默认车辆是否有值，有的话进行下一步，木有说明还未请求到数据，从轻请求数据
        2 默认车辆有数据的话，请求是否在线，如果在线，开启实时监控，不在线提示用户不在线
        3 开启实时监控成功，不执行额外操作，隐藏hud，开启监控失败，提醒用户，开起失败
     
     
     */
    
    //!< 判断是否在线
    /*
     
     [MBProgressHUD showMessage:nil];
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"isonline&tboxid=%@",_defaultCar.tboxid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSNumber *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
 
        //!< 0-不在线  1-在线   -1-参数或网络错误
        [MBProgressHUD hideHUD];
        
        switch (result.intValue)
        {
            case  0:
                
                [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
            
                XMLOG(@"---------不在线，清空实时数据---------");
                [self.scrollView clear];

                
                break;
                
            case  -1:
                
                 [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
                
                break;
                
            case  1:
                
                //!< 在线处理 发送检测指令
            {
                
                [self sendCheckCommand];
             
            }
                
                break;
            
                
            default:
                
                 [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
                
                break;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        
    }];

     */
    
    [MBProgressHUD showMessage:nil];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_currentstatus&Qicheid=%@",_defaultCar.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSString *res = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        if(res.integerValue == 0 || res.integerValue == 2)
        {
        
            //!< 停止/ 失联
            [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
            
            XMLOG(@"---------不在线，清空实时数据---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------不在线，清空实时数据---------"]];

            [self.scrollView clear];
            
            
        }else if (res.integerValue == 1)
        {
            //!< 行驶
             [self sendCheckCommand];//!< 发送检测指令
        
        }else if (res.integerValue == -1)
        {
            //!< 参数或网络错误
             [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
            
        }else if (res.integerValue == -2)
        {
            //!< 没有数据
             [MBProgressHUD showError:JJLocalizedString(@"设备不在线", nil)];
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];

        
    }];
    
}


//!< 发送检测指令
- (void)sendCheckCommand
{
    
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"sendcommand&userid=%ld&qicheid=%@&tboxid=%@&commandtype=50&subtype=0",user.userid,_defaultCar.qicheid,_defaultCar.tboxid];
    
    [MBProgressHUD showMessage:nil];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
//        result = 2;//test
        
        if (result == 0 || result == -1)
        {
             [MBProgressHUD showError:JJLocalizedString(@"通讯失败", nil)];
            
        }else
        {
            
            //!< 下发指令成功，记录下发给终端的记录编号，过几秒用终端编号获取检测结果
            NSString *recordNumber = [[NSString alloc]initWithFormat:@"%d",result];
            
            XMCheckingViewController *vc = [XMCheckingViewController new];
            
            vc.hidesBottomBarWhenPushed = YES;
            
            vc.number = recordNumber;
            
            vc.delegate = self;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            [self startMonitor];//开启实时监控
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
         [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        
    }];
    
    
}


/**
 点击体检结果详情
 */
- (void)detailBtnClick:(UIButton *)sender
{
    
    XMDetailTroubleController *vc = [XMDetailTroubleController new];
    vc.hidesBottomBarWhenPushed = YES;
    
    //!< 判断点击的是哪一项
    switch (sender.tag) {
        case 101:
            
            vc.itemName = JJLocalizedString(@"发动机系统", nil);
            
            vc.data = [XMDataTool separateArrayWithString:@"P" from:self.troubleArray];
            
            break;
        case 102:
            
            
            vc.itemName = JJLocalizedString(@"刹车系统", nil);
            vc.data = [XMDataTool separateArrayWithString:@"B" from:self.troubleArray];
            

            break;
        case 103:
            
            vc.itemName = JJLocalizedString(@"车身稳定系统", nil);
            vc.data = [XMDataTool separateArrayWithString:@"C" from:self.troubleArray];
            

            
            break;
        case 104:
            
            vc.itemName = JJLocalizedString(@"其他 ", nil);
            vc.data = [XMDataTool separateArrayWithString:@"U" from:self.troubleArray];
            

            
            break;
            
        default:
            break;
    }
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  初始化的时候获取用户默认车辆信息
 */
- (void)getDefaultCarInfo
{
    
    
    
    XMUser *user = [XMUser user];
    
    if(user.userid == 48)
    {
        //!< 企业用户，获取默认车辆
        [self getCompanyCars];
        
        return;
    
    }
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"user_qiche_first_get&Userid=%d",(int)user.userid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString * result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] ;
        
        if ([result isEqualToString:@"-1"])
        {
            XMLOG(@"初始化时获取默认车辆信息失败，error：网络错误");//!< 请求失败，不执行操作，点击体检按钮会再判断
            
            
            [XMMike addLogs:[NSString stringWithFormat:@"初始化时获取默认车辆信息失败，error：网络错误"]];

            
        }else if([result isEqualToString:@"0"])
        {
            
            //!< 只有用户编号错误的时候出现这种错误 可以排除用户标号错误的情况
            
        }else{
            
            XMLOG(@"初始化时获取用户默认车辆成功");
            
            [XMMike addLogs:[NSString stringWithFormat:@"初始化时获取用户默认车辆成功"]];

            
            //!< 转模型
            NSArray *carInfo = (NSArray *)[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *dic = [NSDictionary nullDic:[carInfo firstObject]];
            
            self.defaultCar = [XMDefaultCarModel defaultWithDictionary:dic];
            
            //!< 更新本地存储的用户数据
            user.qicheid = self.defaultCar.qicheid;
            
            user.chepaino = self.defaultCar.chepaino;
            
            user.imei = self.defaultCar.imei;
            
            user.tboxid = self.defaultCar.tboxid;
            
            user.carbrandid = self.defaultCar.carbrandid;
            
            [XMUser save:user whenUserExist:YES];
            
            
            //!< 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil userInfo:@{@"mode":@"car",@"result":self.defaultCar}];
            
            self.manager.defaultCar = self.defaultCar;
            
            [self startMonitor];//!< 开始监控
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"初始化时获取默认车辆失败，error：网络错误");//请求失败，不执行操作，点击体检按钮是会再判断
        
        
        [XMMike addLogs:[NSString stringWithFormat:@"初始化时获取默认车辆失败，error：网络错误"]];

    }];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
    
        //!< 默认只执行一次，开启接收服务器消息
        
        NSString *urlStr = [mainAddress stringByAppendingFormat:@"pushsetting&Userid=%lu&type=3&Value=1",user.userid];
        
        [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            XMLOG(@"---------开启接收消息推送成功---------");
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            XMLOG(@"---------开启接收推送消息失败---------");
            
        }];
        
        
    });
    
}

- (void)getCompanyCars
{
    //    用户编号
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"c_qiche_list&companyid=%ld&Page=1&Pagesize=10",user.companyid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"-1"])
        {
            //!< 网络异常
            XMLOG(@"---------企业用户获取车辆信息失败，原因网络异常---------");
            
        }else if([result isEqualToString:@"0"])
        {
               XMLOG(@"---------企业用户获取车辆信息失败，原因未添加车辆---------");
            
            
        }else
        {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            //!< 返回车辆列表信息  数据转模型进行处理
            NSMutableArray *arr = [XMCar mj_objectArrayWithKeyValuesArray:dic[@"rows"]];
            
            if (arr.count == 0) {
                
                return ;
            }
            
            XMCar *car = arr.firstObject;
            
            self.defaultCar = [XMDefaultCarModel new];
            
            _defaultCar.qicheid = [NSString stringWithFormat:@"%ld",car.qicheid];
            
            _defaultCar.tboxid = [NSString stringWithFormat:@"%ld",car.tboxid];
            
            _defaultCar.chepaino = car.chepaino;
            
            _defaultCar.imei = car.imei;
            
            _defaultCar.carbrandid = [NSString stringWithFormat:@"%ld",car.carbrandid];
            
            
            
            //!< 更新本地存储的用户数据
            user.qicheid = self.defaultCar.qicheid;
            
            user.chepaino = self.defaultCar.chepaino;
            
            user.imei = self.defaultCar.imei;
            
            user.tboxid = self.defaultCar.tboxid;
            
            user.carbrandid = self.defaultCar.carbrandid;
            
            [XMUser save:user whenUserExist:YES];
            
            
            //!< 发送通知
            [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil userInfo:@{@"mode":@"car",@"result":self.defaultCar}];
            
            self.manager.defaultCar = self.defaultCar;
            
            [self startMonitor];//!< 开始监控

            
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
         XMLOG(@"---------企业用户获取车辆信息失败，原因网络连接失败---------");
        
    }];
}




/**
 开始实时监控
 */
- (void)startMonitor
{
    [self.manager startMonitorSuccess:^{
        XMLOG(@"---------开启实时监控成功---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------开启实时监控成功---------"]];

    } failHandle:^(CarManagerErrorType errorType, id errorInfo) {
        
        switch (errorType) {
                
            case CarManagerErrorTypeNone:
                
                XMLOG(@"---------开启实时监控失败，为添加车辆---------");
                
                [XMMike addLogs:[NSString stringWithFormat:@"---------开启实时监控失败，为添加车辆---------"]];

                
                break;
                
            case CarManagerErrorTypeNotActive:
                
                XMLOG(@"---------开启实时监控失败，车辆为激活---------");
                
                [XMMike addLogs:[NSString stringWithFormat:@"---------开启实时监控失败，车辆为激活---------"]];

                
                break;
            case CarManagerErrorTypeDisconnect:
                
                XMLOG(@"---------开启失败，无网络---------");
                
                [XMMike addLogs:[NSString stringWithFormat:@"---------开启失败，无网络---------"]];

                
                break;
                
            case CarManagerErrorTypeOther:
                
                XMLOG(@"---------开启失败，失败原因是%@---------",errorInfo);
                
                [XMMike addLogs:[NSString stringWithFormat:@"---------开启失败，失败原因是%@---------",errorInfo]];

                break;
                
            default:
                break;
        }
        
        
    }];
    
}

 

//!< 检测是否需要更新用户的registrationid
- (void)updatePushID
{
    //-- 如果是企业用户是否可以考虑不更新registrationID
    XMUser *user = [XMUser user];
    
    //!< 判断是否需要更新用户registrationID
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        
        
        XMLOG(@"极光推送：最新极光registrationID == %@",registrationID);
        
        [XMMike addLogs:[NSString stringWithFormat:@"极光推送：最新极光registrationID == %@",registrationID]];

//        //!< 检测到极光id和服务器id一直 不需要修改
//        if ([user.registrationid isEqualToString:registrationID])
//        {
//        
//            XMLOG(@"---------极光推送：检测到极光id与服务求id一致，不需要更新---------");
//            
//            return;
//        
//        }
        
           
        
        //!< 如果用户id和现在获取的不一样就更新用户注册的id
        NSString *urlStr = [mainAddress stringByAppendingFormat:@"updatepushid&Userid=%lu&Registrationid=%@",(long)user.userid,registrationID];
        
        [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if ([result isEqualToString:@"1"])
            {
                XMLOG(@"极光推送： 更新用户pushid成功");
                
                [XMMike addLogs:[NSString stringWithFormat:@"极光推送： 更新用户pushid成功"]];

                
                //!< 重新保存用户信息
                user.registrationid = registrationID;
                
                [XMUser save:user whenUserExist:YES];
                
            }else
            {
                XMLOG(@" 极光推送： 更新用户pushid失败");
                
                [XMMike addLogs:[NSString stringWithFormat:@" 极光推送： 更新用户pushid失败"]];

                
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            XMLOG(@" 极光推送：更新用户registrationID失败，网络原因");
            
            [XMMike addLogs:[NSString stringWithFormat:@" 极光推送：更新用户registrationID失败，网络原因"]];

            
        }];
        
    }];
    
    
}

#pragma mark ------- 监听通知

- (void)ADDidFinishLaunch:(NSNotification *)noti
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        //!< 检测新版本
        self.checker = [[XMVersionChecker alloc]initWithDelegate:self];
        
    });
    
    
}



#pragma mark ------- net option
-(void)networkResume
{

    //!< 重新获取车辆信息
//    [self getUserAllCars];
    
    [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
    [self getDefaultCarInfo];

}



- (void)defaultCarDidClick
{
    
    [self getDefaultCarInfo];
    
}


#pragma mark ------- XMCheckingViewControllerDelegate

- (void)checkingVCWillDisAppear:(XMCheckingViewController *)vc
{
    [self.scoreLabel animateToScore:vc.resultScore duration:1];

    [self.pathView animateWithDuration:1 percent:vc.resultScore/100.0];
    
    //!< 保存当前分数到本地
    [XMDataTool saveCurrentScore:vc.resultScore];
    
    
    if(vc.resultData)
    {
        //!< 检测到问题项
        self.troubleArray = vc.resultData;
        
        BOOL one = NO,two = NO,three = NO,four = NO;
        
        for (NSDictionary *dic in vc.resultData)
        {
            NSString *code = dic[@"code"];
            
            if ([code hasPrefix:@"P"])
            {
                one = YES;
            }
            
            if ([code hasPrefix:@"B"])
            {
                two = YES;
            }
            
            if ([code hasPrefix:@"C"])
            {
                three = YES;
            }
            
            if ([code hasPrefix:@"U"])
            {
                four = YES;
            }
         }
            
            if (one)
            {
                UIButton *btn_one = [self.view viewWithTag:101];
                
                btn_one.enabled = YES;
                
                btn_one.selected = YES;
            }
        
        if (two)
        {
            UIButton *btn_two = [self.view viewWithTag:102];
            
            btn_two.enabled = YES;
            
            btn_two.selected = YES;
        }
        if (three)
        {
            UIButton *btn_three = [self.view viewWithTag:103];
            
            btn_three.enabled = YES;
            
            btn_three.selected = YES;
        }
        if (four)
        {
            UIButton *btn_four = [self.view viewWithTag:104];
            
            btn_four.enabled = YES;
            
            btn_four.selected = YES;
        }

    
    }
    
}

#pragma mark ------- carManagerDelegate

-(void)carManager:(CarManager *)manager didUpdateRealtimeData:(NSDictionary *)data
{

    if (_scrollView)
    {
        [_scrollView setData:data];
    }

}


#pragma mark ------- UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //!< 判断偏移量
    float offset_x = scrollView.contentOffset.x;
    
    
    offset_x += (mainSize.width * 0.5);
    
    int index = offset_x / mainSize.width;
    
    self.pageControl.currentPage = index;


}
#pragma mark ------- XMVersionCheckerDelegate

- (void)checkerDidFinishVersionChecker:(XMVersionChecker *)checker
{
    
    if(self.viewLoaded && self.view.window)
    {
        //!< 如果页面已经加载，并且当前停留在此页面，直接提示用户
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:JJLocalizedString(@"检测到新版本，是否更新", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"否", nil) otherButtonTitles:JJLocalizedString(@"是", nil), nil];
        
        alert.tag = 111;
        
        [alert show];
    
    }else
    {
        
        //!< 不在当前页面，等页面显示的时候再进行提示
        //!< 有新版本
        self.hasNewVersion = YES;

    
    }
    
    
}


- (void)checkerFinishCheckUserStateJumpToLoginVC:(XMVersionChecker *)checker
{
    //!< 跳转到登录控制器
    //!< 跳转页面 设置主窗口
//    UITabBarController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"XMMainTabBarController"];
//    
//    [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
    if (self.viewLoaded && self.view.window)
    {
         self.checker.pwdError = NO;
        
        [[NSFileManager defaultManager] removeItemAtPath:ACCOUNTPATH error:nil];
        
//        [MBProgressHUD showError:JJLocalizedString(@"请重新验证账户", nil)];
        
        [XMUser clearAccount];
        
        [UIApplication sharedApplication].keyWindow.rootViewController = [[XMLoginNaviController alloc]initWithRootViewController:[XMLoginViewController new]];
        
       
       
    }


}

#pragma mark ------- UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //!< 检测新版本
    if(alertView.tag == 111)
    {
        if (buttonIndex == 1)
        {
            //!< 用户点击更新，跳转到appstore
            //    1273634634 DashPal Appid  testID:1185454831
            
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1185454831"]];
        }
    }
    
    if(alertView.tag == 999)
    {
    
        if(buttonIndex == 0)return;
        //!< 有一个标记，标记第四个界面加载完毕推出车辆管理解密
        
        XMUser *user = [XMUser user];
        
        user.role_id = 999;
        
        [XMUser save:user whenUserExist:YES];
        
        
        XMMainTabBarController *tabVC = (XMMainTabBarController *)self.tabBarController;
        
        [tabVC setSelectItem:3];
        
        //!< 执行添加车辆操作
        self.tabBarController.selectedIndex = 3;
        
        
    
    }
    
  

}

/**
 *  48号用户修改车辆
 */
- (void)carInfoDidUpdate:(NSNotification *)noti
{
    NSString *changMode = noti.userInfo[@"mode"];//!< 默认车辆发生变化还是全部车辆
    
    id object = noti.userInfo[@"result"];//!< 改变的结果
    
    if([changMode isEqualToString:@"car"])
    {
  
        self.defaultCar = (XMDefaultCarModel *)object;
        
        
        XMUser *user = [XMUser user];
        //!< 更新本地存储的用户数据
        user.qicheid = self.defaultCar.qicheid;
        
        user.chepaino = self.defaultCar.chepaino;
        
        user.imei = self.defaultCar.imei;
        
        user.tboxid = self.defaultCar.tboxid;
        
        user.carbrandid = self.defaultCar.carbrandid;
        
        [XMUser save:user whenUserExist:YES];
         
        self.manager.defaultCar = self.defaultCar;
        
        [self startMonitor];//!< 开始监控
        
        
    }
    
    
}


- (void)dealloc
{


    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

@end
