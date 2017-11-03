//
//  XMMsgController.m
//  kuruibao
//
//  Created by x on 17/8/23.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 设计两个tableview分别对汽车推送消息和系统推送消息进行展示，混淆在一个table中比较容易出问题
 
 一个设计为上拉加载，一个设计为下拉刷新，用一个scroll来管理
 
 ************************************************************************************************/

#import "XMMsgController.h"

#import "JPUSHService.h"

#import "MJRefresh.h"

#import "XMMonitorPushMessageCell.h"

#import "XMMessageModel.h"

#define KEY @"pushmessage"

#import "MJExtension.h"

#import "XMSystemMessageModel.h"

#import "XMWebViewController.h"

#import "XMSystemMessageCell.h"

@interface XMMsgController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int index;//!< 标记当前页码,获取汽车推送消息是进行分页
@property (assign, nonatomic) int index1; //-- 系统消息的页码标记


@property (nonatomic,weak)UITableView* tableView;//!< 负责展示汽车消息

@property (nonatomic,weak)UITableView* tableView2;//!< 负责展示系统消息

@property (weak, nonatomic) UIScrollView *scroll;//!< 负责存放两张表

@property (strong, nonatomic) NSMutableArray *dataSource2;//!< 第二张表的数据源

@property (weak, nonatomic) UIButton *btn_1;

@property (weak, nonatomic) UIButton *btn_2;

@end

@implementation XMMsgController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self creatSubViews];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //!< 进入到消息界面之后，就清空应用程序角标和极光服务器存储的角标数
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [JPUSHService setBadge:0];
    
}

- (void)creatSubViews
{
    self.index = 1;
    
    self.index1 = 1;
    
    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"消息", nil);
    
    //!< 添加两个按钮
    UIButton *btn_1 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_1 setImage:[UIImage imageNamed:@"us_home_message_btn_car_normal"] forState:UIControlStateNormal];
    
    [btn_1 setImage:[UIImage imageNamed:@"us_home_message_btn_car_selelcted"] forState:UIControlStateSelected];
    
    [btn_1 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_1.selected = YES;
    
    btn_1.tag = 1;
    
    [self.view addSubview:btn_1];
    
    self.btn_1 = btn_1;
    
    [btn_1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view).offset(25);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(186));
        
        make.size.equalTo(CGSizeMake(112, 26));
        
    }];
    
    UIButton *btn_2 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn_2 setImage:[UIImage imageNamed:@"us_home_message_btn_service_normal"] forState:UIControlStateNormal];
    
    [btn_2 setImage:[UIImage imageNamed:@"us_home_message_btn_service_selelcted"] forState:UIControlStateSelected];
    
    [btn_2 addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    btn_2.tag = 2;
    
    [self.view addSubview:btn_2];
    
    self.btn_2 = btn_2;
    
    [btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(btn_1.mas_right).offset(13);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(186));
        
        make.size.equalTo(CGSizeMake(112, 26));
        
    }];
    
    //!< 添加scroll
    UIScrollView *scroll = [[UIScrollView alloc]init];
    
    scroll.showsHorizontalScrollIndicator = NO;
    
    scroll.bounces = NO;
    
    scroll.scrollEnabled = NO;
    
    float height = mainSize.height- FITHEIGHT(186)- 39;
    
    scroll.contentSize = CGSizeMake(mainSize.width * 2, height);
    
    scroll.frame = CGRectMake(0, FITHEIGHT(186 ) + 39, mainSize.width, height);
    
    [self.view addSubview:scroll];
    
    self.scroll = scroll;
 
    
    
    //!< 添加tableView(表一)
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [tableView.mj_footer beginRefreshing];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.frame = CGRectMake(0, 0, mainSize.width, CGRectGetHeight(scroll.bounds));
    
    [scroll addSubview:tableView];
    
    self.tableView = tableView;
 
    
    
    
    //!< 添加tableView(表二)
    UITableView *tableView2= [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    tableView2.delegate = self;
    
    tableView2.dataSource = self;
    
    tableView2.tableFooterView = [UIView new];
    
    tableView2.backgroundColor = [UIColor clearColor];
    
    tableView2.showsVerticalScrollIndicator = NO;
    
    tableView2.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(reloadSystemMessage)];
    
    tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView2.frame = CGRectMake(mainSize.width,0, mainSize.width, CGRectGetHeight(scroll.bounds));
    
    [tableView2.mj_footer beginRefreshing];
    
    [scroll addSubview:tableView2];
    
    self.tableView2 = tableView2;
  
}


#pragma mark ------- lazy

- (NSMutableArray *)dataSource2
{
    if (!_dataSource2)
    {
        _dataSource2 = [NSMutableArray array];
    }
    
    return _dataSource2;
    
}

#pragma mark -------------- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(tableView == self.tableView)
    {
        return self.dataSource.count;
        
    }else
    {
        
        return self.dataSource2.count;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tableView)
    {
        XMMonitorPushMessageCell *cell = [XMMonitorPushMessageCell dequeueReuseableCellWithTableView:tableView];
        
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
        
    }else
    {
        XMSystemMessageModel *model = self.dataSource2[indexPath.row];
        
        //!< 判断图片地址手否有值
        if (model.imgUrl.length > 5)
        {
            //!< 有图片
            XMSystemMessageCell *cell = [XMSystemMessageCell dequeueReuseableCellWithTableView:tableView];
            
            cell.model = model;
            
            return cell;
            
        }else
        {
            XMMonitorPushMessageCell *cell = [XMMonitorPushMessageCell dequeueReuseableCellWithTableView:tableView];
            
            cell.timeLabel.text = model.createtime;
            
            
            cell.messageLabel.text = [model.pushmessage stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            cell.type = YES;
            
            return cell;
            
        }
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(tableView == self.tableView)
    {
        NSString *text = [self.dataSource[indexPath.row] message];
        
        CGFloat width = tableView.bounds.size.width - 18 - 26 - 13;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        return rect.size.height + 13 + 20 + 13 + 8 + 13 + 10;
        
    }else
    {
        
        XMSystemMessageModel *model = self.dataSource2[indexPath.row];
        
        //!< 判断图片地址手否有值
        if (model.imgUrl.length > 5)
        {
            //!< 有图片
            return 116;
            
        }else
        {
            //!< 没有图片，只返回文字高度就可以
            NSString *text = model.pushmessage;
            
            text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
            
            CGFloat width = tableView.bounds.size.width - 18 - 26 - 13;
            
            CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            return rect.size.height + 13 + 20 + 13 + 8 + 13;
            
        }
        
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == self.tableView)
    {
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMSystemMessageModel *model = self.dataSource2[indexPath.row];
    
    XMWebViewController *vc = [XMWebViewController new];
    
    vc.toUrl = model.ToUrl;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    
    
    
}


#pragma mark -------------- 刷新数据

//!< 刷新数据的方法
- (void)refreshData
{
    
     NSString *urlStr = [mainAddress stringByAppendingFormat:@"pushmessageget&Userid=%ld&Readstatus=0&Messagetype=0&Page=%d&Pagesize=20",(long)[XMUser user].userid,self.index];
        
         [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [_tableView.mj_footer endRefreshing];
            
            NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            
            if ([result isEqualToString:@"0"])
            {
                //!< 没有推送数据
                
                if (self.btn_1.selected)
                {
                      [MBProgressHUD showError:JJLocalizedString(@"没有数据", nil)];
                }
              
                XMLOG(@"---------没有推送数据---------");
                
            }else if([result isEqualToString:@"-1"])
            {
                //!< 参数或者是网络错误
                XMLOG(@"---------参数或者网络错误---------");
            }else
            {
                //!< 请求数据成功
                
                //!< 页码加一
                self.index ++;
                
                NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
                
                NSArray *resultArr = resultDic[@"rows"];
                
                if (resultArr.count == 0)
                {
                    
                    if (self.btn_1.selected)
                    {
                         [MBProgressHUD showError:JJLocalizedString(@"没有更多数据", nil)];
                    }
                   
                    
                    return ;
                }
                
                NSInteger count = self.dataSource.count;
                
                for (NSDictionary *dic in resultArr)
                {
                    
                    XMMessageModel *model = [XMMessageModel new];
                    
                    NSString *message = dic[KEY];
                    
                    NSString *happenTime = dic[@"happentime"];
                    
                    if ([happenTime isKindOfClass:[NSNull class]])
                    {
                        model.happentime = [[dic[@"createtime"] stringByReplacingOccurrencesOfString:@"T" withString:@" "] stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                    }else
                    {
                        
                        model.happentime = happenTime;
                        
                    }
                    
                    model.message = message;
                    
                    [self.dataSource addObject:model];
                }
                
                
                //!< 刷新表格
                
                NSMutableArray *indexPaths = [NSMutableArray array];
                
                for (int i = 0; i<resultArr.count; i++)
                {
                    NSInteger row = count + i;
                    
                    NSIndexPath *ip = [NSIndexPath indexPathForRow:row inSection:0];
                    
                    [indexPaths addObject:ip];
                }
                
                //!< 插入新请求到的数据
                [_tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
                
                //!< 将最新请求到的数据滚动到屏幕最顶端
                [_tableView scrollToRowAtIndexPath:indexPaths.firstObject atScrollPosition:UITableViewScrollPositionTop animated:YES];
                
            }
            
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            //!< 请求数据失败
            if (self.btn_1.selected)
            {
              [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
            }
            
            
            
            [_tableView.mj_footer endRefreshing];
            
        }];
    
    
   
}

/**
 *  刷新系统消息
 */
- (void)reloadSystemMessage
{
    //!< 刷新回来这里
    //!< 不牵扯分页，应该是一次性返回所有的数据给客户端
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"systemmessage&page=%d&pagesize=10&userid=%ld",self.index1,[XMUser user].userid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.tableView2.mj_footer endRefreshing];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.integerValue == 0 && result.length == 1)
        {
            //!< 没有推送数据
            if (self.btn_2.selected) {
                
                 [MBProgressHUD showError:JJLocalizedString(@"没有数据", nil)];
            }
            
            
        }else if (result.integerValue == -1)
        {
            //!< 参数或网络错误
            
        }else
        {
            //!< 请求成功
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSMutableArray *arr = [XMSystemMessageModel mj_objectArrayWithKeyValuesArray:dic[@"rows"]];
            
            //-- 记录将要滚动表格的位置
            NSInteger location = self.dataSource2.count;
            
            [self.dataSource2 addObjectsFromArray:arr];//将新数据拼接在数组最后
            
            [self.tableView2 reloadData];
            
            //-- 滚动到最新的位置
            if (self.dataSource2.count < 8)
            {
                //!< 滚回到顶部
                [self.tableView2 setContentOffset:CGPointZero];
                
            }else
            {
                [self.tableView2 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:location inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];

            }
            
            self.index1++;//页码加1
            
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView2.mj_footer endRefreshing];
        
        if (self.btn_2.selected) {
            
            [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
        }
        
       
        
        
    }];
    
    
}


#pragma mark ------- 按钮的点击事件
- (void)btnClick:(UIButton *)sender
{
    
    if (sender.selected) return;

    if (sender == _btn_1)
    {
        _btn_1.selected = YES;
        _btn_2.selected = NO;
        
        //!< 设置scroll偏移量
        [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
        
    }
    
    if (sender == _btn_2)
    {
        _btn_1.selected = NO;
        
        _btn_2.selected = YES;
        
        //!< 设置scroll偏移量
        [self.scroll setContentOffset:CGPointMake(mainSize.width, 0) animated:YES];
        
     }
 
    
    
}


#pragma mark -------------- system

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
    
}


@end
