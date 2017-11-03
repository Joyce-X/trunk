//
//  XMManagerCarViewController.m
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMManagerCarViewController.h"
#import "XMQRCodeViewController.h"
#import "XMQRCodeWriteInfoViewController.h"
#import "MJRefresh.h"

#import "XMFooterView.h"
#import "XMCar.h"
#import "MJExtension.h"
#import "XMmanageCell.h"

#import "XMAddCarController.h"

#import "XMEditCarController.h"

#import "XMSortManager.h"

#import "XMDefaultCarModel.h"

@interface XMManagerCarViewController ()<UITableViewDelegate,UITableViewDataSource,XMFooterViewDelegate,XMAddCarControllerDelegate,XMQRCodeViewControllerDelegate,XMQRCodeWriteInfoViewControllerDelegate,XMEditCarControllerDelegate>

@property (weak, nonatomic) UITableView *tableView;

@property (strong, nonatomic) XMCar *currentModel;//!< 当前正在操纵的model

/**
 添加车辆按钮
 */
@property (nonatomic,weak)UIButton* addBtn;


/**
 当前用户数据
 */
@property (strong, nonatomic) XMUser *user;


@property (assign, nonatomic) int index;

@end

@implementation XMManagerCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupInit];

    
}



- (void)setupInit
{
    
    self.index = 1;
    
    self.user = [XMUser user];
    
    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"管理车辆", nil);
    
    //!< 创建tableView
    UITableView *tableView = [UITableView new];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = XMClearColor;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.rowHeight = 44;
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [tableView.mj_header beginRefreshing];
    
    [self.view addSubview: tableView];
    
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.view).offset(FITHEIGHT(185));
        
        make.left.bottom.right.equalTo(self.view);
        
    }];
    
    
    UIView *view = [self.view viewWithTag:7778];//!< 返回按钮
    
    
    //!< 添加添加按钮
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [addBtn setBackgroundImage:[UIImage imageNamed:@"add icon"] forState:UIControlStateNormal];
    
     [self.view addSubview:addBtn];
    
    self.addBtn = addBtn;

    
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(25, 25));
        
        make.right.equalTo(self.view).offset(-20);
        
        make.centerY.equalTo(view);
        
    }];
    
    
    //!< 注意，如果用户ID是48的话，就设置添加按钮不可点击，不能编辑车辆信息，点击任何一辆车都设置为默认车辆
    if (_user.userid == 48)
    {
        addBtn.enabled = NO;
        
        
    }

}

#pragma mark ------- tableViewDelegate,datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMmanageCell *cell = [XMmanageCell dequeueResuableCellWithTableView:tableView];
    
    //!< 数据
    XMCar *car = self.dataSource[indexPath.section];
    
    if (indexPath.row == 0)
    {
        cell.showLine = NO;
        
        cell.carImage = [UIImage imageNamed:[NSString stringWithFormat:@"%lu.jpg",(long)car.carbrandid]];
        cell.text1 = car.brandname;
        
        cell.text2 = car.chepaino;
        
        
    }else
    {
        cell.showLine = YES;
        
        cell.carImage = [UIImage imageNamed:@"imei icon F"];
        
        cell.text1 = car.imei;
        
        if (car.tboxid > 0)
        {
            //!< 已绑定
            cell.text2 = JJLocalizedString(@"已绑定", nil);
        }else
        {
            //!< 未绑定
            cell.text2 = JJLocalizedString(@"未绑定", nil);
        
        }
     
    }
    
    //!< 设置默认车辆高亮
    cell.isDefasult = car.isfirst;
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //!< 数据模型
    self.currentModel = self.dataSource[indexPath.section];
    
    //!< 如果是48号用户，就设置默认车辆
    if (_user.userid == 48)
    {
        [self setDefaultCar:self.currentModel];
        
        return;
    }
    
    
    if (indexPath.row == 0)
    {
        //!< 点击汽车，进入编辑车辆界面
        XMEditCarController *vc = [XMEditCarController new];
        
        vc.carModel = self.currentModel;
        
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
        
    }else
    {
        //!< 点击imei，进入imei界面，更新imei号码
        XMQRCodeViewController *vc = [XMQRCodeViewController new];
        
        vc.delegate = self;
        
        __weak typeof(self) wself = self;
        
        vc.writeImeiBlack = ^{
            //!< 手动填写imei的callback  跳转过程：扫描界面 - 当前界面 - XMQRCodeWriteInfoViewController（手动填写界面）
            XMQRCodeWriteInfoViewController *vc = [XMQRCodeWriteInfoViewController new];
            
            vc.delegate = wself;
            
            [wself.navigationController pushViewController:vc animated:NO];
        };
        vc.delegate = self;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    }
    
    
    

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 13;

}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return  [UIView new];

}

/**
 *  设置默认车辆
 */
- (void)setDefaultCar:(XMCar*)car
{
    [MBProgressHUD showMessage:nil];
    
     XMDefaultCarModel * dcar = [XMDefaultCarModel new];
    
     dcar.tboxid = [NSString stringWithFormat:@"%ld",car.tboxid];
    
     dcar.qicheid = [NSString stringWithFormat:@"%ld",car.qicheid];
    
     dcar.imei =  car.imei;
    
     dcar.carbrandid =  [NSString stringWithFormat:@"%ld",car.carbrandid];
    
     dcar.chepaino = car.chepaino;
    
    
    //!< 将车牌号码保存到用户模型中
    XMUser *user = [XMUser user];
    
    user.chepaino = car.chepaino;
    
    user.qicheid = dcar.qicheid;
    
    [XMUser save:user whenUserExist:YES];
    
    
    //!< 返回上一界面
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUD];
        
        [self.navigationController popViewControllerAnimated:YES];
        
    });
    
    //!< 发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil userInfo:@{@"mode":@"car",@"result":dcar}];
    
    
    /*
    //!< 点击确认设置默认车辆
    //!< 判断网络
    if (!connecting)
    {
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];return;
    }
    
    //!< 设置默认车辆
    [MBProgressHUD showMessage:nil];
    
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_setfirst&Userid=%lu&Qicheid=%ld",user.userid,qicheID];
    
    //!< 转码
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        int result = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
        
        switch (result)
        {
            case 0:
                
                [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];//网络异常，请稍后再试
                
                break;
                
            case 1:
                
                
                [MBProgressHUD showSuccess:JJLocalizedString(@"设置成功", nil)];
                
                //!< 发送通知，通知相关界面，默认车辆已经修改成功
                [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserSetDefaultCarSuccessNotification object:nil];
                
                //!< 监控主界面刷信息
                [[NSNotificationCenter defaultCenter] postNotificationName:kCheXiaoMiUserDidUpdateCarInfoNotification object:nil];
                
                XMLOG(@"设置默认车辆成功");
            {
                //!< 返回上一界面
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }
                break;
                
            case -1:
                
                [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
                
                break;
                
            default:
                
                break;
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"设置失败", nil)];
        
        XMLOG(@"设置默认车辆失败");
        
        [XMMike addLogs:@"设置默认车辆失败"];
        
    }
     ];
    */
    
}



#pragma mark ------- XMEditCarControllerDelegate

/**
 刷新数据
 */
- (void)shouldUpdateData
{
    [self.tableView.mj_header beginRefreshing];

    
}

#pragma mark ------- XMFooterViewDelegate

- (void)footerAddButtonClick
{
    
    //!< 和点击加号执行相同的操作
    [self addBtnClick];


}
#pragma mark ------- XMAddCarControllerDelegate

- (void)shouldRefresh
{
    [self.tableView.mj_header beginRefreshing];

}

#pragma mark ------- XMQRCodeWriteInfoViewControllerDelegate
- (void)finishWrite:(NSString *)result{

    [self qrcodeFinishScan:result];

}

#pragma mark ------- XMQRCodeViewControllerDelegate
- (void)qrcodeFinishScan:(NSString *)result
{
    //!< 扫描二维码完成，准备更新imei数据 更新完成后，刷新数据
    XMUser *user = [XMUser user];
    
    [MBProgressHUD showMessage:nil];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Rebind&Userid=%lu&IMEI=%@&Qicheid=%lu",user.userid,result,(long)self.currentModel.qicheid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         [MBProgressHUD hideHUD];
        
        NSString *str = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (str.integerValue == 1)
        {
            //!< 更新成功
            [self.tableView.mj_header beginRefreshing];
        }else
        {
             //!< 更新失败
             [MBProgressHUD showError:JJLocalizedString(@"更新失败", nil)];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"更新失败，请检查网络", nil)];
        
    }];
    
    
}
/**
 *  刷新数据
 */
- (void)refreshData
{
    
    
    
    //    用户编号
    XMUser *user = [XMUser user];
    
    if (user.userid == 48)
    {
        [self getCompanyCars];
        
        return;
        
    }
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"qiche_list&Userid=%ld",(long)user.userid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        NSString *result =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"-1"])
        {
            //!< 网络异常
            [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
            
         }else if([result isEqualToString:@"0"])
        {
            [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil)];

            
        }else
        {
            //!< 返回车辆列表信息  数据转模型进行处理
            NSMutableArray *arr = [XMCar mj_objectArrayWithKeyValuesArray:responseObject];
            
            self.dataSource = [XMSortManager sortCar:arr];//!< 数组排序
            
            //!< 需要对数组进行排序
            
            if (self.dataSource.count > 0)
            {
                self.tableView.tableFooterView = [UIView new];
                
                //!< 更新本地数据
                [XMUser updateLocalUserModel:self.dataSource];
                
            }else
            {

                
             }
            
            [self.tableView reloadData];//!< 刷新数据
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        
    }];
}


/**
 *  刷新数据
 */
- (void)getCompanyCars
{
    //    用户编号
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"c_qiche_list&companyid=%ld&Page=%d&Pagesize=10",user.companyid,self.index];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView.mj_header endRefreshing];
        
        NSString *result =  [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"-1"])
        {
            //!< 网络异常
            [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
            
        }else if([result isEqualToString:@"0"])
        {
            [MBProgressHUD showError:JJLocalizedString(@"未添加车辆", nil)];
            
            
        }else
        {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            //!< 返回车辆列表信息  数据转模型进行处理
            NSMutableArray *arr = [XMCar mj_objectArrayWithKeyValuesArray:dic[@"rows"]];
            
            [self.dataSource addObjectsFromArray:[XMSortManager sortCar:arr]];//!< 数组排序
            
            //!< 需要对数组进行排序
            
            if (self.dataSource.count > 0)
            {
                self.tableView.tableFooterView = [UIView new];
                
                //!< 更新本地数据
//                [XMUser updateLocalUserModel:self.dataSource];
                
            }
            
            [self.tableView reloadData];//!< 刷新数据
            
            self.index++;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD showError:JJLocalizedString(@"请检查网络连接", nil)];
        
    }];
}



#pragma mark ------- 按钮的点击事件

/**
 点击添加车辆按钮
 */
- (void)addBtnClick
{
    XMLOG(@"---------addBtnClick---------");
    
    XMAddCarController *vc = [XMAddCarController new];
    
    vc.delegate = self;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
