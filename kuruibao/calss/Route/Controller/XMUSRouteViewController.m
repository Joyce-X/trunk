//
//  XMUSRouteViewController.m
//  kuruibao
//
//  Created by x on 17/8/10.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMUSRouteViewController.h"
#import "XMCreater.h"
#import "XMGGMapCell.h"
#import "XMDefaultCarModel.h"
#import "NSDictionary+convert.h"
//#import "XMGoogleMapEnlargeViewController.h"
#import "XMDateChooseView.h"
#import "XMTrackAverageStateModel.h"
#import "XMMiddleShowViewController.h"
#import "XMDateManager.h"

#import "XMActiveManager.h"

 @interface XMUSRouteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,XMGGMapCellDelegate,XMDateChooseViewDelegate>

@property (strong, nonatomic) UILabel *monthLabel;//!< show month
@property (strong, nonatomic) UILabel *dayLabel;//!< show day
@property (strong, nonatomic) UILabel *yearLabel;//!< show year
@property (strong, nonatomic) UILabel *startTimeLabel;//!< show start time
@property (strong, nonatomic) UILabel *endTimeLabel;//!< show end time
@property (strong, nonatomic) UILabel *totalDistanceLabel;//!< show total distance
@property (strong, nonatomic) UILabel *totalTimeLabel;//!< show total time
@property (strong, nonatomic) UILabel *totalOilLabel;//!< show total oil used

@property (copy, nonatomic) NSString *currentTimeStr;//!< current time string 带英文的格式


@property (weak, nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) XMDefaultCarModel *defaultCar;

@property (strong, nonatomic) XMUser *user;

@property (assign, nonatomic) BOOL flag;//!< 标识是否应该甄别数据

//!< 记录有效的时间区间
@property (copy, nonatomic) NSString *str1;//!< 开始时间
@property (copy, nonatomic) NSString *str2;//!< 结束时间



/**
 用户选择完数据，的年月日时间
 */
@property (copy, nonatomic) NSString *recordDate;
@end

@implementation XMUSRouteViewController


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        //!< 监听用户的默认车辆获取成功或全部车辆获取成功的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carInfodidChanged:) name:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
        
        //!< 监听语言变化
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldUpdateText) name:kDashPalWillChangeLanguageNotification object:nil];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupInit];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getAverageDataWithTimeStr:self.recordDate];
    
//    if (self.dataSource.count == 0)
    {
        
        [self getSegmentDataWithTimeStr:self.recordDate];
        
    }


}

- (void)setupInit
{
    
    self.user = [XMUser user];
    
    self.view.backgroundColor = [UIColor blackColor];
    //!< 添加背景图
    UIImageView *backIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"背景_us"]];
    
    [self.view addSubview:backIV];
    
    [backIV mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self.view);
        
    }];
    
   //!< create white color label
     self.monthLabel = [XMCreater createLabeWithColor:nil font:24 text:@"    " bold:NO];
     self.dayLabel = [XMCreater createLabeWithColor:nil font:70 text:@"    " bold:YES];
     self.yearLabel = [XMCreater createLabeWithColor:nil font:24 text:@"    " bold:NO];
     self.startTimeLabel = [XMCreater createLabeWithColor:nil font:24 text:@"00:00" bold:NO];
     UILabel *toLabel = [XMCreater createLabeWithColor:nil font:24 text:@"to" bold:NO];
     self.endTimeLabel = [XMCreater createLabeWithColor:nil font:24 text:@"23:59" bold:NO];
    
    [self.view addSubview:self.monthLabel];
    [self.view addSubview:self.dayLabel];
    [self.view addSubview:self.yearLabel];
    [self.view addSubview:self.startTimeLabel];
    [self.view addSubview:toLabel];
    [self.view addSubview:self.endTimeLabel];

    
    [self.monthLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (mainSize.width == 320)
        {
            
            make.top.equalTo(FITHEIGHT(100));
            
        }else
        {
            
            make.top.equalTo(FITHEIGHT(160));
            
        }
        make.left.equalTo(self.view).offset(18);
      
        
        make.size.equalTo(CGSizeZero);
        
    }];
    
    [self.dayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.monthLabel.mas_right).offset(13);
        
        make.bottom.equalTo(self.monthLabel).offset(15);
        
        make.size.equalTo(CGSizeZero);
        
    }];
    
    [self.yearLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.dayLabel.mas_right).offset(13);
        
        make.bottom.equalTo(self.monthLabel);
        
        make.size.equalTo(CGSizeZero);
    }];
    
    [self.startTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.monthLabel);
        
        make.top.equalTo(self.monthLabel.mas_bottom).offset(25);
        
        make.width.equalTo(self.startTimeLabel.tag);
        
        make.height.equalTo(20);
        
    }];
    
    [toLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.startTimeLabel.mas_right).offset(13);
        
        make.bottom.equalTo(self.startTimeLabel.mas_bottom);
        
        make.width.equalTo(toLabel.tag);
        
        make.height.equalTo(20);
        
    }];
    
    [self.endTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(toLabel.mas_right).offset(13);
        
        make.bottom.equalTo(self.startTimeLabel.mas_bottom);
        
        make.width.equalTo(self.endTimeLabel.tag);
        
        make.height.equalTo(20);
        
    }];
    
    self.currentTimeStr = [XMDateManager getCurrentDateString];
    
    //!< 设置点击选则时间的区域
    UIButton *chooseDateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [chooseDateBtn addTarget:self action:@selector(chooseDateBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:chooseDateBtn];
    
    [chooseDateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.monthLabel);
        
        make.top.equalTo(self.dayLabel);
        
        make.right.equalTo(self.yearLabel);
        
        make.bottom.equalTo(self.startTimeLabel);
        
        
    }];
    
    
    //!< create gray color label and IV
    
    UIImageView *iv1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Tracelling icon"]];
    
    [self.view addSubview:iv1];
    
    [iv1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(20, 20));
        
        make.left.equalTo(self.startTimeLabel);
        
        make.top.equalTo(self.startTimeLabel.mas_bottom).offset(25);
        
    }];
    
    UILabel *label1 = [XMCreater createLabeWithColor:XMGrayColor font:18 text:JJLocalizedString(@"行驶里程", nil) bold:NO];
    
    
    CGSize size1 = [JJLocalizedString(@"行驶里程", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    label1.tag = 11;
    
    [self.view addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(iv1.mas_right).offset(13);
        
        make.centerY.equalTo(iv1);
        
        make.size.equalTo(CGSizeMake(size1.width + 3, 20));
        
    }];
    
    
    self.totalDistanceLabel = [XMCreater createLabeWithColor:XMGrayColor font:18 text:@"--mile" bold:NO];
    
    [self.view addSubview:self.totalDistanceLabel];
    
    [self.totalDistanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(label1.mas_right).offset(13);
        
        make.centerY.equalTo(iv1);
        
        make.size.equalTo(CGSizeMake(200, 20));
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    
    UIImageView *iv2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Driving time icon"]];
    
    [self.view addSubview:iv2];
    
    [iv2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(20, 20));
        
        make.left.equalTo(self.startTimeLabel);
        
        make.top.equalTo(iv1.mas_bottom).offset(13);
        
    }];
    
    UILabel *label2 = [XMCreater createLabeWithColor:XMGrayColor font:18 text:JJLocalizedString(@"行驶时间", nil) bold:NO];
    
    CGSize size2 = [JJLocalizedString(@"行驶时间", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    label2.tag = 12;
    
    [self.view addSubview:label2];
    
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iv2.mas_right).offset(13);
        
        make.centerY.equalTo(iv2);
        
        make.size.equalTo(CGSizeMake(size2.width + 3, 20));
        
    }];
    
    
    self.totalTimeLabel = [XMCreater createLabeWithColor:XMGrayColor font:18 text:@"--" bold:NO];
    
    [self.view addSubview:self.totalTimeLabel];
    
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label2.mas_right).offset(13);
        
        make.centerY.equalTo(iv2);
        
        make.size.equalTo(CGSizeMake(200, 20));
        
    }];
    
    UIImageView *iv3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Fuel used icon"]];
    
    [self.view addSubview:iv3];
    
    [iv3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(20, 20));
        
        make.left.equalTo(iv2);
        
        make.top.equalTo(iv2.mas_bottom).offset(13);
        
    }];
    
    UILabel *label3 = [XMCreater createLabeWithColor:XMGrayColor font:18 text:JJLocalizedString(@"总油耗", nil) bold:NO];
    [self.view addSubview:label3];
    
    CGSize size3 = [JJLocalizedString(@"总油耗", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    label3.tag = 13;
    
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(iv3.mas_right).offset(13);
        
        make.centerY.equalTo(iv3);
        
        make.size.equalTo(CGSizeMake(size3.width + 3, 20));
        
    }];
    
    
    self.totalOilLabel = [XMCreater createLabeWithColor:XMGrayColor font:18 text:@"--gallon" bold:NO];
    
    [self.view addSubview:self.totalOilLabel];
    
    [self.totalOilLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(label3.mas_right).offset(13);
        
        make.centerY.equalTo(iv3);
        
        make.size.equalTo(CGSizeMake(200, 20));
        
    }];
    
    //!< add collection view
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(FITWIDTH(598/2), FITHEIGHT(166));
    
    layout.minimumInteritemSpacing = 13;
    
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
    
    collectionView.contentInset = UIEdgeInsetsMake(0, 18, 0, 18);
    
    collectionView.alwaysBounceHorizontal = YES;
    
    collectionView.showsHorizontalScrollIndicator = NO;
    
    collectionView.delegate = self;
    
    collectionView.dataSource = self;
    
    [collectionView registerClass:[XMGGMapCell class] forCellWithReuseIdentifier:@"mapCell"];
    
    collectionView.backgroundColor = XMClearColor;
    
    
    [self.view addSubview:collectionView];
    
    self.collectionView  = collectionView;
    
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        if (mainSize.width == 320)
        {
            make.top.equalTo(label3.mas_bottom).offset(FITHEIGHT(10));

        }else
        {
            make.top.equalTo(label3.mas_bottom).offset(FITHEIGHT(66));

        }
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(FITHEIGHT(166));
        
    }];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //!< 设置AFN的缓存策略
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    
//    serializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
//    
//    serializer.timeoutInterval = 10;
//    
//    self.session.requestSerializer = serializer;
    
    //!< 获取分段数据
    [self getSegmentDataWithTimeStr:nil];
    
    //!< 获取平均数据
    [self getAverageDataWithTimeStr:nil];
    
    
}

#pragma mark ------- setter

- (void)setCurrentTimeStr:(NSString *)currentTimeStr
{
    _currentTimeStr = currentTimeStr;
    
    NSArray *arr = [currentTimeStr componentsSeparatedByString:@"-"];
    
    NSString *year = arr.firstObject;
    NSString *month = arr[1];
    NSString *day = arr.lastObject;
    
    CGSize sizeM = [month sizeWithAttributes:@{NSFontAttributeName:self.monthLabel.font}];
    sizeM.width = ceil(sizeM.width);
    sizeM.height = ceil(sizeM.height);
    self.monthLabel.text = month;
    [self.monthLabel updateConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(sizeM);
        
    }];
    
    CGSize sizeD = [day sizeWithAttributes:@{NSFontAttributeName:self.dayLabel.font}];
    sizeD.width = ceil(sizeD.width);
    sizeD.height = ceil(sizeD.height);
    self.dayLabel.text = day;
    [self.dayLabel updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(sizeD);
        
    }];
    
    CGSize sizeY = [year sizeWithAttributes:@{NSFontAttributeName:self.yearLabel.font}];
    sizeY.width = ceil(sizeY.width);
    sizeY.height = ceil(sizeY.height);
    self.yearLabel.text = year;
    [self.yearLabel updateConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(sizeY);
        
    }];
    


    
}

#pragma mark ------- UICollectionViewDelegate,UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{

    return self.dataSource.count;

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMGGMapCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mapCell" forIndexPath:indexPath];
    
//    cell.delegate = self;
    
    XMTrackSegmentStateModel *model = self.dataSource[indexPath.row];
    
    cell.qicheid = self.user.qicheid;
    
    cell.segmentData = model;
    
    
    
    return cell;


}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    XMLOG(@"---------000000000---------");
    //!< 获取下标
//    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    XMGGMapCell *cell = (XMGGMapCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    //!< 判断是否有位置信息
    if (!cell.hasLocationPoints) {
        
        [MBProgressHUD showError:JJLocalizedString(@"没有定位信息", nil)];
        
        return;
        
        
    }
     
    XMTrackSegmentStateModel *model = self.dataSource[indexPath.row];
    
    XMMiddleShowViewController * vc = [XMMiddleShowViewController new];//!< 显示谷歌地图
    
    vc.segmentData = model;
    
    vc.qicheid = [XMUser user].qicheid;//self.defaultCar.qicheid;
    
    vc.hidesBottomBarWhenPushed = YES;
    
    //    vc.coor = cell.coor;
    
    [self.navigationController pushViewController:vc animated:YES];


}

#pragma mark ------- XMGGMapCellDelegate

- (void)mapCellDidSelectCell:(XMGGMapCell *)cell
{

    XMLOG(@"---------000000000---------");
    //!< 获取下标
    NSIndexPath *indexPath = [self.collectionView indexPathForCell:cell];
    
    XMTrackSegmentStateModel *model = self.dataSource[indexPath.row];
    
    XMMiddleShowViewController * vc = [XMMiddleShowViewController new];//!< 显示谷歌地图
    
    vc.segmentData = model;
    
    vc.qicheid = self.defaultCar.qicheid;
    
    vc.hidesBottomBarWhenPushed = YES;
    
//    vc.coor = cell.coor;
    
    [self.navigationController pushViewController:vc animated:YES];

}

#pragma mark ------- XMDateChooseViewDelegate
- (void)chooseViewDidSelectDate:(NSString *)date start:(NSString *)start end:(NSString *)end
{
    
    //!< 记录选择的日期，在更换默认车辆的时候，重新加载新数据使用
    self.recordDate = date;
    
    BOOL result = [XMCreater judgeString:start earlierThanString:end];
    
    if (!result)
    {
        [MBProgressHUD showError:JJLocalizedString(@"无效的时间区间", nil)];
        
        return;
    }
    
    //!< 请求数据
//    [MBProgressHUD showMessage:nil];
    
    //!< 记录时间区间
    self.str1 =  start;
    
    self.str2 = end;
    
    self.flag = YES;
    //!< 设置显示的时间
    self.startTimeLabel.text = start;
    
    self.endTimeLabel.text = end;
    
    self.currentTimeStr = [XMCreater getCurrentDateWitgTimeType:XMTimeTypeAll timeStr:date];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    //!< 请求当天平均数据
    [self getAverageDataWithTimeStr:date];
    //!< 请求当天的分段数据
     [self getSegmentDataWithTimeStr:date];

    XMLOG(@"---------%@\n%@\n%@---------",date,start,end);
   


}

#pragma mark ------- 请求数据
//!< 获取当天分段数据
- (void)getSegmentDataWithTimeStr:(NSString *)timeStr
{

    if (self.defaultCar && self.defaultCar.qicheid.integerValue < 1 && self.defaultCar.tboxid.integerValue < 1) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil) toView:self.view];
        return;
        
    }
    
    if (self.defaultCar && self.defaultCar.tboxid.integerValue < 1)
    {
        //!< 有网络，但是车辆没有激活
//        XMLOG(@"---------车辆没有激活，请求当天分段数据被终止---------");
//        
//        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆没有激活，请求当天分段数据被终止---------"]];
//
//        
//        //!< 尝试激活
////        [XMActiveManager activeCarWithQicheid:self.defaultCar.qicheid];
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showError:JJLocalizedString(@"车辆未激活", nil) toView:self.view];
//        return;
        
        XMLOG(@"---------车辆未激活，但是已经跳过判定，直接获取分段数据---------");
        
        //!< 如果没有激活的话，就在这里尝试重新激活，
        [XMActiveManager activeCarWithQicheid:self.defaultCar.qicheid];
        
    }
    
    if (self.defaultCar == nil && self.user.tboxid.integerValue < 1)
    {
        XMLOG(@"---------获取默认车辆失败，无网络，且车辆未激活，请求分段数据被终止---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------获取默认车辆失败，无网络，且车辆未激活，请求分段数据被终止---------"]];

        [MBProgressHUD hideHUDForView:self.view];
        return;
        
    }
    
    if (timeStr == nil)
    {
        //!< 没有传时间，默认为当前时间
        timeStr = [XMCreater getCurrentDateWitgTimeType:XMTimeTypeFormatter timeStr:nil];
    }
 
    [self setCachePolicyWithTime:timeStr];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_xc_bytime&Userid=%ld&qicheid=%@&Starttime=%@",(long)_user.userid,_user.qicheid,timeStr];
    
    
    
    XMLOG(@"-----对应日期：%@----当前缓存策略：Joyce,%lu---------",timeStr,(unsigned long)self.session.requestSerializer.cachePolicy);
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD hideHUDForView:self.view];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"0"])
        {
            
            //!< 没有分段数据
            if(self.isViewLoaded)
            {
                [MBProgressHUD showError:JJLocalizedString(@"没有行程信息", nil) toView:self.view];//当天没有行程数据
                
                 self.dataSource = nil;
                
                [self.collectionView reloadData];
              }
            
         }else if([result isEqualToString:@"-1"])
        {
            //!< 网络错误
            if(self.viewLoaded && self.defaultCar.chepaino.length < 5)
            {
                [MBProgressHUD  showError:JJLocalizedString(@"未添加车辆", nil)];
                
            }else
            {
//                [MBProgressHUD  showError:JJLocalizedString(@"网络异常", nil)];//网络错误
                
            }
            
        }else
        {
             //!< 获取成功
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            //!< 设置数据
            [self setSegmentDataWithArray:resultArr];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
         [MBProgressHUD hideHUDForView:self.view];
        //!< 获取失败
        if(self.viewLoaded)
        {
            [MBProgressHUD  showError:JJLocalizedString(@"请检查网络连接", nil) toView:self.view];
            
        }
       
        
    }];
    
    
}


//!< 设置分段数据
- (void)setSegmentDataWithArray:(NSArray *)array
{
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:array.count];
    
    for (NSDictionary *dic in array)
    {
        NSDictionary * newDic = [NSDictionary nullDic:dic];
        
         XMTrackSegmentStateModel *model = [[XMTrackSegmentStateModel alloc]initWithDictionary:newDic];
        
        if(self.flag)
        {
            //!< 需要选出在指定区域内的数据，加载适合数据
            //!< 对时间进行判定
            BOOL result = [XMCreater judgeString:model.starttime withinStr:self.str1 andStr:self.str2];
            
            if (result)
            {
                //!< 符合规则
                [arrM addObject:model];

            }else
            {
            
                XMLOG(@"---------与目标时间段不同---------");
                
                [XMMike addLogs:[NSString stringWithFormat:@"---------与目标时间段不同---------"]];

            
            }
            
        }else
        {
            //!< 加载所有数据
            [arrM addObject:model];

            
        }
    }
    
    self.flag = NO;
    
    self.dataSource = [arrM copy];
    
    [self.collectionView reloadData];
    
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    
    if(self.dataSource.count == 0)
    {
//        [MBProgressHUD showError:@"未发现相匹配的数据"];
        
        //!< 清空显示数据
        self.totalDistanceLabel.text = JJLocalizedString(@"---", nil);
        
        self.totalOilLabel.text = JJLocalizedString(@"---", nil);
        
        self.totalTimeLabel.text = JJLocalizedString(@"---", nil);
    
    }
    
    
}


//!< 获取当天平均数据
- (void)getAverageDataWithTimeStr:(NSString *)timeStr
{
    
    if (self.defaultCar && self.defaultCar.qicheid.integerValue < 1 && self.defaultCar.tboxid.integerValue < 1) {
        
//        [MBProgressHUD hideHUDForView:self.view];
//        [MBProgressHUD showError:@"未添加车辆" toView:self.view];
        return;
        
    }
    //!< 如果车辆未激活的话，就不去请求平均数据
    
    if (self.defaultCar && self.defaultCar.tboxid.integerValue < 1)
    {
        //!< 有网络，但是车辆没有激活
        XMLOG(@"---------车辆没有激活，请求当天平均数据被终止---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆没有激活，请求当天平均数据被终止---------"]];

        
        //!< 尝试激活
//        [XMActiveManager activeCarWithQicheid:self.defaultCar.qicheid];
//        
//        return;
        
        //!< 不进行激活判定
        
    }
    
    if (self.defaultCar == nil && self.user.tboxid.integerValue < 1)
    {
        XMLOG(@"---------获取默认车辆失败，无网络，且车辆未激活，请求平均数据被终止---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------车辆没有激活，请求当天平均数据被终止---------"]];

        
         return;
        
    }

    if (timeStr == nil)
    {
        //!< 如果没有传时间就默认当天时间
        timeStr = [XMCreater getCurrentDateWitgTimeType:XMTimeTypeFormatter timeStr:nil];
    }
    
    [self setCachePolicyWithTime:timeStr];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"getstatisticsbyday&qicheid=%@&Starttime=%@",_user.qicheid,timeStr];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"0"])
        {
            //!< 没有获取全部行程数据
            self.totalDistanceLabel.text = @"--mile";
            
            self.totalTimeLabel.text = @"--";
            
            self.totalOilLabel.text = @"--gallon";
            
        }else if ([result isEqualToString:@"-1"])
        {
            //!< 网络错误
            
        }else
        {
            //!< 获取行程数据成功
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *resultDic = [NSDictionary nullDic:[resultArr firstObject]];
            
            [self setAverageDataWithDic:resultDic];
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if(self.viewLoaded  && self.view.window)
        {
//            [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        }
        
    }];
    
    
}


//!< 获取当天行程数据成功后设置数据
- (void)setAverageDataWithDic:(NSDictionary *)dic
{
    XMTrackAverageStateModel *model = [[XMTrackAverageStateModel alloc]initWithDictionary:dic];
    
     if (self.viewLoaded)
    {
        self.totalDistanceLabel.text = model.totallicheng;
        
        self.totalOilLabel.text = model.totalpenyou;
        
        self.totalTimeLabel.text = model.totalxingshitime;
    }
    
    
    
}


#pragma mark ------- 响应通知
/*!
@brief 监听用户更换默认车辆 || 获取全部车辆信息成功的通知
*/
- (void)carInfodidChanged:(NSNotification *)noti
{
    
    NSString *changMode = noti.userInfo[@"mode"];//!< 默认车辆发生变化还是全部车辆
    
    id object = noti.userInfo[@"result"];//!< 改变的结果
    
    if([changMode isEqualToString:@"car"])
    {
        XMDefaultCarModel *model = (XMDefaultCarModel *)object;
        
        self.user = [XMUser user];//!< 更新user模型
        
        //!< 默认车辆变化
        self.defaultCar = model;
        
        if (self.viewLoaded)
        {
            self.recordDate = nil;
            
            self.currentTimeStr = [XMDateManager getCurrentDateString];
        }
        
        [self getAverageDataWithTimeStr:self.recordDate];
        
        [self getSegmentDataWithTimeStr:self.recordDate];
        
        
    }
}

#pragma mark ------- 按钮的点击事件

- (void)chooseDateBtnClick
{
    
    XMDateChooseView *view = [[NSBundle mainBundle] loadNibNamed:@"XMDateChooseView" owner:nil options:nil].firstObject;
    
    view.date1 = [XMDateManager convertStringToDate:self.currentTimeStr];
    
    view.date2 = [XMDateManager convertStartTimeString:self.startTimeLabel.text];
    
    view.date3 = [XMDateManager convertStartTimeString:self.endTimeLabel.text];
    
    view.delegate = self;
    
    [view show];
    
}

//!< 根据时间设置缓存策略
- (void)setCachePolicyWithTime:(NSString *)timeStr
{
    NSDateFormatter *df = [[NSDateFormatter alloc]init];
    
    df.dateFormat = @"yyyy-MM-dd";
    
    //!< 当前的时间
    NSDate *current = [NSDate date];
    
    //!< 当天时间的字符串格式
    NSString *cuStr = [df stringFromDate:current];
    
    //!< 如果传进来的时间是当天的时间，就设置缓存策略为加载新数据 忽略缓存
    //!< 注意： 新需求，如果是当前时间的前一天，也设置为加载新数据
    
    //!< 进来的时间
    NSDate *date_in = [df dateFromString:timeStr];
    
    NSString *curDayStr = [df stringFromDate:current];//!< 当前时间转换成字符串
    
    NSDate *date_now = [df dateFromString:curDayStr];//!< 字符串转为0点的标准UTC
    
    
   NSTimeInterval interval =  [date_now timeIntervalSinceDate:date_in];
    
    //!< 如何判断谁是谁的前一天呢
    BOOL compare = interval == 60 * 60 * 24;//!< 比较的结果
    
    if ([timeStr isEqualToString:cuStr] || compare)
    {
        //!< 时间是当前时间,或者当前时间的前一天
        if (connecting)
        {
            [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];//!< 设置缓存策略为加载新数据
        }
        
    }else
    {
    
        [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];//!< 有缓存加载，没有请求新数据

    }
    
}

/**
 *  更新文字内容
 */
- (void)shouldUpdateText
{
    
    UILabel *label1 = [self.view viewWithTag:11];
    
    UILabel *label2 =[self.view viewWithTag:12];
    
    UILabel *label3 = [self.view viewWithTag:13];
    
    CGSize size1 = [JJLocalizedString(@"行驶里程", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    CGSize size2 = [JJLocalizedString(@"行驶时间", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    CGSize size3 = [JJLocalizedString(@"总油耗", nil) sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:18]}];
    
    label1.text = JJLocalizedString(@"行驶里程", nil);
    
    label2.text = JJLocalizedString(@"行驶时间", nil);
    
    label3.text = JJLocalizedString(@"总油耗", nil);
    
    
    [label1 updateConstraints:^(MASConstraintMaker *make) {
        
        
        make.size.equalTo(CGSizeMake(size1.width + 3, 20));
        
    }];
    
  
   
    [label2 updateConstraints:^(MASConstraintMaker *make) {
        
         make.size.equalTo(CGSizeMake(size2.width + 3, 20));
        
    }];
 
    
    [label3 updateConstraints:^(MASConstraintMaker *make) {
        
       
        
        make.size.equalTo(CGSizeMake(size3.width + 3, 20));
        
    }];
 
    
}

@end
