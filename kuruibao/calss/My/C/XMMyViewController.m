//
//  XMMyViewController.m
//  kuruibao
//
//  Created by x on 17/7/18.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMyViewController.h"

#import "XMMeBottomView.h"

#import "XMMeTopView.h"

#import "XMMeMiddleView.h"

#import "XMEditProfileController.h"

#import "XMDefaultCarModel.h"

#import "XMUser.h"

#import "NSDictionary+convert.h"

#import "XMTrackScoreModel.h"

#import "XMSetController.h"

#import "XMManagerCarViewController.h"

#import "XMAboutViewController.h"

#import "XMTrackScoreViewController.h"

#import "XMDefaultCarModel.h"

#import "XMInfoManager.h"

#import "XMRecommendImageCacheManager.h"

#import "XMMikeController.h"

#define middleViewHeight (30 + 30 + (mainSize.width-66)/3)

#define showMiddleKey @"me_showMiddleKey" //bool 类型，是否展示中部视图

@interface XMMyViewController ()<XMMeTopViewDelegate,XMMeMiddleViewDelegate,XMMeBottomViewDelegate>


@property (weak, nonatomic) XMMeTopView *topView;

@property (weak, nonatomic) XMMeMiddleView *middleView;

@property (weak, nonatomic) XMMeBottomView *botView;

/**
 推荐的数据
 */
@property (strong, nonatomic) NSArray *recommandArr;

/**
 用户信息数据
 */
@property (strong, nonatomic) NSDictionary *userInfoDic;

/**
 默认车辆信息
 */
@property (strong, nonatomic) XMDefaultCarModel *defaultCar;//!< 准备监听默认车辆获取成功的通知，保存默认车辆

@property (strong, nonatomic) XMUser *user;

@property (strong, nonatomic) XMTrackScoreModel *travelScoreModel;//!< 驾驶数据

@property (strong, nonatomic) UIImage *carImage;//!< 显示汽车图片

@property (copy, nonatomic) NSString *clickMoreAddress;//!< 点击更多现实的地址

@property (strong, nonatomic) XMInfoManager *manager;//!< 管理用户没有网时候的数据

/**
 屏幕为4s的时候，适配scroll
 */
@property (nonatomic,weak)UIScrollView* scroll;

@end

@implementation XMMyViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        
        //!< 监听主界面获取默认车辆的通知，来设置车牌号码和车辆图标 
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carInfoDidUpdate:) name:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
        
        //!< 监听语言变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateText) name:kDashPalWillChangeLanguageNotification object:nil];

    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupInit];
  
    //!< 获取数据
    [self getData];
   

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if([XMDashPalManager shareManager].carNumber.length > 0)
    {
        self.botView.carNumberLabel.text = [XMDashPalManager shareManager].carNumber;
    }
    
    if(self.defaultCar)
    {
        //-- 默认车辆存在
        //!< 修改当前显示的车牌号码
        if(_defaultCar.chepaino.length > 3)
        {
            
            //-- 默认判定车牌号码长度大于3的时候，就是有车牌号码，否则认为没有
            self.botView.carNumberLabel.text = _defaultCar.chepaino;
            
        }else
        {
            self.botView.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);
            
        }
        
        
        //!< 修改当前的汽车图标
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_defaultCar.carbrandid]];
        
        if (image)
        {
            
            _botView.carImageView.image = image;
            
            self.carImage = image;
            XMLOG(@"---------图片存在---------");
        }else
        {
            
            XMLOG(@"---------图片不存在---------");
            self.carImage = image;
            _botView.carImageView.image = [UIImage imageNamed:@"car_us"];
        }
    
    
    }else
    {
        
        //-- 默认车辆不存在 
        if(self.user.chepaino.length > 0)
        {
            self.botView.carNumberLabel.text = self.user.chepaino;
            
            //!< 显示图片
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.user.carbrandid]];
            
            if (image)
            {
                self.botView.carImageView.image = image;
            }else
            {
                self.botView.carImageView.image = [UIImage imageNamed:@"car_us"];
            }
            
        }else
        {
            
            self.botView.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);
            
            self.botView.carImageView.image = [UIImage imageNamed:@"car_us"];
        }
        
    
    }
    
    
    
    //!< 跳转到添加车辆界面
    XMUser *user = [XMUser user];
    
    if (user.role_id == 999)
    {
        [self bottomViewDidClickCar:nil];
        
        user.role_id = 0;
        
        [XMUser save:user whenUserExist:YES];
    }
    

    //!< 设置得分数据
//    _topView.model = self.travelScoreModel;

}

- (void)setupInit
{
    
    self.showBackgroundImage = YES;
    
    UIView *view = self.view;
    
    if(mainSize.height == 480)
    {
    
        UIScrollView *scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height - 49)];
        
        scroll.showsVerticalScrollIndicator = NO;
        
        scroll.contentSize = CGSizeMake(0, 426);
        
        [self.view addSubview:scroll];
        
        self.scroll = scroll;
    
        view = scroll;
    }
    
    //!< 顶部
    XMMeTopView *topView = [[NSBundle mainBundle] loadNibNamed:@"XMMeTop" owner:nil options:nil].firstObject;
    
    topView.delegate = self;
    
    [view addSubview:topView];
    
    
    self.topView = topView;
    
    topView.frame = CGRectMake(0, 0, mainSize.width, 200);
 
    
    //!< 中部
    XMMeMiddleView *middleView = [XMMeMiddleView new];
    
    middleView.hidden = YES;
    
    middleView.delegate = self;
    
    [view addSubview:middleView];
    
    self.middleView = middleView;
    
    middleView.frame = CGRectMake(0, 200 + 13, mainSize.width, 0);
    
    
    
    //!< 底部
     XMMeBottomView *botView = [[NSBundle mainBundle] loadNibNamed:@"XMMeBottom" owner:nil options:nil].firstObject;
    
   
    botView.delegate = self;
    
    [view addSubview:botView];
    
    self.botView = botView;
    
    botView.frame = CGRectMake(0, CGRectGetMaxY(_middleView.frame) + 13, mainSize.width, 200);
    
    XMUser *user = [XMUser user];
    
    if (user.tboxid.intValue > 0)
    {
        //!< 已绑定
        botView.linkState = YES;
        
    }else
    {
        //!< 未绑定
        botView.linkState = NO;
        
        
    }
    
    if (self.defaultCar == nil)
    {
        //!< 没有获取到默认车辆数据
        
        if(self.user.chepaino.length > 0)
        {
            self.botView.carNumberLabel.text = self.user.chepaino;
            
            //!< 显示图片
            UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",self.user.carbrandid]];
            
            if (image)
            {
                self.botView.carImageView.image = image;
            }else
            {
                 self.botView.carImageView.image = [UIImage imageNamed:@"car_us"];
            }
            
        }else
        {
        
            self.botView.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);
        
            self.botView.carImageView.image = [UIImage imageNamed:@"car_us"];
        }
        
    }else
    {
        //!< 获取数据成功
        self.botView.carNumberLabel.text = _defaultCar.chepaino;
    
        if (self.carImage)
        {
            
            botView.carImageView.image = self.carImage;
            
        }else
        {
             self.botView.carImageView.image = [UIImage imageNamed:@"car_us"];
        }
    
    }
    
    // 设置是否显示中间视图
    [self setupMiddleView];
    
    //!< 添加长按手势
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
    
    longPress.numberOfTapsRequired = 4;
    
    [self.view addGestureRecognizer:longPress];

    
}

 


- (void)longPress
{
    
    XMMikeController *vc = [XMMikeController new];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}

#pragma mark ------- lazy

-(XMUser *)user
{
    if (!_user)
    {
        _user = [XMUser user];
    }

    return _user;

}

- (XMInfoManager *)manager
{

    if (!_manager)
    {
        _manager = [XMInfoManager new];
    }

    return _manager;
}

#pragma mark ------- 加载数据

- (void)getData
{
    [self getRecommandData];
    
    [self getDriveScoreData];
    
    [self getuserInfoData];
}


/**
 *  获取推荐数据
 */
- (void)getRecommandData
{
    
    if (!connecting)
    {
        //--没有网的时候，加载缓存数据
        NSArray *images = [XMRecommendImageCacheManager recommendImageCache];
        
        if (images)
        {
            _middleView.disconnectImages = images;
            
            
        }
        
        return;
    }
    
    //!< 1 获取推荐的数据
    
    NSString *urlStr = [mainAddress stringByAppendingString:@"hotitems"];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (resultStr.integerValue == 0 && resultStr.length < 2)
        {
            //!< 没有数据
            XMLOG(@"---------没有推荐数据---------");
            
        }else if(resultStr.integerValue == -1 && resultStr.length < 2)
        {
            //!< 参数或者网络错误
        
            XMLOG(@"---------获取推荐数据，参数或者网络错误---------");
        }else
        {
            //!< 请求成功
            NSDictionary *result = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            self.recommandArr = [result objectForKey:@"rows"];
            
            self.clickMoreAddress = [result objectForKey:@"total"];
            
            //!< 设置数据
            _middleView.recommandArr = self.recommandArr;
            
            //-- 在这里需要设置缓存的数据，每次请求成功就设置缓存数据，在模型内部进行判定是否存在缓存数据
            [XMRecommendImageCacheManager updateRecommendImageCache:_recommandArr];
            
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        //!< 网络连接超时，不进行处理
        
    }];
    
    
}

/**
 *  获取用户信息数据
 */
- (void)getuserInfoData
{
    //!< 2 获取用户和信息数据，设置昵称和头像
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"getuserinfo&Mobil=%@",self.user.mobil];
    
    if (!connecting)
    {
        //!< 没有网的时候
      NSCachedURLResponse *res = [[NSURLCache sharedURLCache] cachedResponseForRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
        
//        self.session.requestSerializer 
        
        if (res)
        {
            XMLOG(@"---------缓存存在-，不用加载备用数据--------");
        }else
        {
        
            XMLOG(@"---------缓存不存在，准备加载备用数据---------");
            if (self.manager.flag == NO)
            {
                XMLOG(@"---------本地没有存储数据，无法加载---------");
            }else
            {
            
                XMLOG(@"---------本地有备用用户数据---------");
                _topView.manager = self.manager;//!< 设置数据
                            
            }
            
            return;
        
        }
        
    }
    
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //!< 请求用户信息成功
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        dic = [NSDictionary nullDic:dic];//!< 出去NSNUll
        
        //!< 设置数据
        _topView.userDic = dic;
        
        self.userInfoDic = dic;//!< 保存用户数据，下一界面要用到
        
        //!< 每次请求成功都更新一次本地数据
        [self.manager updateUserInfo:dic];
        
        //!<
        if([dic[@"data"] isKindOfClass:[NSString class]])
        {
            
            return ;
            
        }
        
        NSArray *arr = dic[@"data"];
        
        XMUser *user = [XMUser user];
        
        if ([arr.firstObject isKindOfClass:[NSDictionary class]])
        {
            user.vin = [arr.firstObject objectForKey:@"nickname"];
        }
        
        
        [XMUser save:user whenUserExist:YES];

        
        
        XMLOG(@"---------获取用户信息成功---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------获取用户信息成功---------"]];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //!< 请求用户信息失败
        XMLOG(@"---------请求用户信息失败---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------请求用户信息失败---------"]];

        
    }];
    
}

/**
 *  获取驾驶得分数据
 */
- (void)getDriveScoreData
{
    
    
    if (self.user.qicheid.integerValue < 1)
    {
        XMLOG(@"---------用户没有车辆信息,请求分数信息被终止---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------用户没有车辆信息,请求分数信息被终止---------"]];

        return;
        
    }
    
    if (self.user.tboxid.integerValue < 1)
    {
        XMLOG(@"---------用户车辆未激活，请求分数信息被终止---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------用户车辆未激活，请求分数信息被终止---------"]];

    }
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_score_get&Userid=%lu&Qicheid=%@",(long)self.user.userid,self.user.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *resultStr = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([resultStr isEqualToString:@"0"])
        {
            XMLOG(@"---------没有得分数据---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------没有得分数据---------"]];

            
            
        }else if([resultStr isEqualToString:@"1"])
        {
            XMLOG(@"---------网络连接超时---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------网络连接超时---------"]];

            
        }else
        {
            //!< 获取数据成功之后 在界面进行展示
            
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *dic = [NSDictionary nullDic:[resultArr firstObject]];
            
             XMTrackScoreModel *model = [[XMTrackScoreModel alloc]initWithDic:dic];
            
            self.travelScoreModel = model;
            //!< 设置数据
            _topView.model = model;
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
//        [MBProgressHUD showError:@"网络连接超时"];
        
    }];
    
}




#pragma mark ------- 响应通知
- (void)carInfoDidUpdate:(NSNotification *)noti
{
    //!< 收到通知就说明请求默认车辆成功，，没有收到通知车牌号码就显示为空
    NSDictionary *dic = noti.userInfo;
    
    if ([dic[@"mode"] isEqualToString:@"car"])
    {
        //!< 请求到默认车辆发送的通知
        XMDefaultCarModel *model = dic[@"result"];

         self.defaultCar = model;
        
        //!< 修改当前显示的车牌号码
        if(model.chepaino.length > 3)
        {
        
            //-- 默认判定车牌号码长度大于3的时候，就是有车牌号码，否则认为没有
            self.botView.carNumberLabel.text = model.chepaino;

        }else
        {
            self.botView.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);

        }
        
        //!< 修改当前的汽车图标
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",_defaultCar.carbrandid]];
        
        if (image)
        {
            
            _botView.carImageView.image = image;
            
            self.carImage = image;
            XMLOG(@"---------图片存在---------");
        }else
        {
        
            XMLOG(@"---------图片不存在---------");
            
            self.carImage = image;
            
            _botView.carImageView.image = [UIImage imageNamed:@"car_us"];
            
        }
        
        //!< 设置绑定状态
        if (self.defaultCar.tboxid.intValue > 0)
        {
            //!< 已绑定
            _botView.linkState = YES;
            
        }else
        {
            //!< 未绑定
            _botView.linkState = NO;
            
            
        }

    }
    
}

#pragma mark ------- XMMeTopViewDelegate

/**
 个人中心头像被点击
 
 @param topView trigger
 */
- (void)topViewProfileDidClick:(XMMeTopView *)topView
{

    XMEditProfileController *vc = [XMEditProfileController new];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.manager = self.manager;
    
    __weak typeof(self) wself = self;
  
    //!< 上传成功的话修改本界面头像
    vc.callBack = ^(id data){
        
        if ([data isKindOfClass:[UIImage class]])
        {
            
            wself.topView.headerImage = (UIImage *)data;
        
        }else
        {
            wself.topView.nickName = (NSString *)data;
            
        }
        
      };
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 正五边形被点击
 
 @param topView taigger
 */
- (void)topViewPentagonDidClick:(XMMeTopView *)topView
{

    XMTrackScoreViewController *vc = [XMTrackScoreViewController new];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    vc.model = self.travelScoreModel;
    
     
    [self.navigationController pushViewController:vc animated:YES];
    
    
}


#pragma mark -------  XMMeMiddleViewDelegate

/**
 点击XMMeMiddleView的更多按钮
 
 @param middleView trigger
 */
- (void)middleViewDidClickMore:(XMMeMiddleView *)middleView
{
    
    if (self.clickMoreAddress.length > 0)
    {
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_clickMoreAddress]];
        
    }else
    {
    
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
    
    }
    
    

}

/**
 点击第几张推荐的图片
 
 @param middleView trigger
 @param index 图片下标
 */
- (void)middleViewDidClicImage:(XMMeMiddleView *)middleView atIndex:(NSInteger)index
{
    if(!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
         return;
     }

    if (self.recommandArr == nil)
    {
        //!< 没有请求到数据，提示无数据
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
         return;
    }
    
    if(self.recommandArr.count < 3) return;//!< 数组长度不足
    
    //!< 取出对应的url 101:点击第一个，102：点击第2个 103 点击第3个
    NSDictionary *dic = self.recommandArr[index - 101];
    
    NSURL *url = [NSURL URLWithString:dic[@"ToUrl"]];
    
    [[UIApplication sharedApplication] openURL:url];;
    

}



#pragma mark -------  XMMeBottomViewDelegate

/**
 点击车标一栏
 
 @param bottomView trigger
 */
- (void)bottomViewDidClickCar:(XMMeBottomView *)bottomView
{
    
    XMManagerCarViewController *vc = [[XMManagerCarViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];

    

}

/**
 点击底部设置
 
 @param bottomView trigger
 */
- (void)bottomViewDidClickSetting:(XMMeBottomView *)bottomView
{
    XMSetController *vc = [[XMSetController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];


}

/**
 点击底部的关于
 
 @param bottomView trigger
 */
- (void)bottomViewDidClickAbout:(XMMeBottomView *)bottomView
{
    XMAboutViewController *vc = [[XMAboutViewController alloc]init];
    
    vc.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:vc animated:YES];
    


}

- (void)setupMiddleView
{
    //配置中间视图
    
    BOOL flag = [[NSUserDefaults standardUserDefaults] boolForKey:showMiddleKey];
    
    if (flag)
    {
        [self addjustMiddleViewHeight];//-- 更新约束
        
        XMLOG(@"本地数据为YES，需要显示中部视图");
        
        [XMMike addLogs:[NSString stringWithFormat:@"本地数据为YES，需要显示中部视图"]];


    }else
    {
        if(connecting)
        {
            XMLOG(@"有网络，本地无标志位，准备请求服务器，是否显示中间视图");
            
            [XMMike addLogs:[NSString stringWithFormat:@"有网络，本地无标志位，准备请求服务器，是否显示中间视图"]];

            
            /*
            //-- 模拟请求，0 请求成功，1 请求失败
            int a = 0;
            
            if (a)
            {
                //-- 请求失败，
                XMLOG(@"请求失败，无法确认是否显示中部视图，默认不显示");
                
            }else
            {
                
                XMLOG(@"请求成功，显示中间视图，更新本地标志位");
                [self addjustMiddleViewHeight];
                
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showMiddleKey];
                
            }
             */
            
            //!< 请求
            NSString *urlStr = [mainAddress stringByAppendingString:@"isusing"];
            
            [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSString *res = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                if (res.integerValue == 1)
                {
                    XMLOG(@"请求成功，显示中间视图，更新本地标志位");
                    
                    [XMMike addLogs:[NSString stringWithFormat:@"请求成功，显示中间视图，更新本地标志位"]];

                    [self addjustMiddleViewHeight];
                    
                    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:showMiddleKey];
                    
                }else
                {
                    XMLOG(@"---------请求成功，结果为不显示模式---------");
                    
                    [XMMike addLogs:[NSString stringWithFormat:@"---------请求成功，结果为不显示模式---------"]];

                
                
                }
                
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //-- 请求失败，
                XMLOG(@"请求失败，无法确认是否显示中部视图，默认不显示");
                
                [XMMike addLogs:[NSString stringWithFormat:@"请求失败，无法确认是否显示中部视图，默认不显示"]];

                
            }];
            
            
        }else
        {
            
            XMLOG(@"没有网络，且本地无数据，无法确认是否显示中间视图，默认不显示");
            
            [XMMike addLogs:[NSString stringWithFormat:@"没有网络，且本地无数据，无法确认是否显示中间视图，默认不显示"]];

            
        }
    
    
    }

}

- (void)addjustMiddleViewHeight
{
    
    _middleView.hidden = NO;
    
    if (mainSize.height > 480)
    {
        // 更新约束
        _middleView.frame = CGRectMake(0, 200 + 13, mainSize.width, middleViewHeight);
        
        _botView.frame = CGRectMake(0, CGRectGetMaxY(_middleView.frame) + 13 , mainSize.width, 200);
        
    }else
    {
        //-- 适配4s
        _scroll.contentSize = CGSizeMake(0, 426 + middleViewHeight);
        
        _middleView.frame = CGRectMake(0, 200 + 13, mainSize.width, middleViewHeight);
        
        _botView.frame = CGRectMake(0, CGRectGetMaxY(_middleView.frame) + 13, mainSize.width, 200);
        
        [_scroll setNeedsLayout];
    
    }
    
}

#pragma mark ------- 网络恢复
- (void)networkResume
{
    [super networkResume];
    
    //!< 重新获取数据
    [self getData];
    
}
    


/**
 *  更新文字内容
 */
- (void)shouldUpdateText
{
    [self.middleView shouldUpdateText];
    
    [self.botView shouldUpdateText];
    
    if(self.user.chepaino.length == 0)
    {
        self.botView.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);
        
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
