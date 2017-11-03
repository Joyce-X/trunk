//
//  XMMessageViewController.m
//  kuruibao
//
//  Created by x on 16/9/13.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//


/**********************************************************
 class description:用来显示历史推送消息的界面
 
 **********************************************************/

#import "XMMessageViewController.h"

#import "MJRefresh.h"

#import "AFNetworking.h"

#import "XMUser.h"

#import "XMMonitorPushMessageCell.h"

#import "JPUSHService.h"

#import "XMMessageModel.h"

#define KEY @"pushmessage"

#import "MJExtension.h"

#import "XMSystemMessageModel.h"
#import "XMWebViewController.h"
#import "XMSystemMessageCell.h"

@interface XMMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (assign, nonatomic) int index;//!< 标记当前页码

@property (assign, nonatomic) int index1;//!< 标记第二张表页码

@property (nonatomic,weak)UITableView* tableView;

@property (weak, nonatomic) UIButton *btn_1;

@property (weak, nonatomic) UIButton *btn_2;

/**
 服务器消息的数据源
 */
@property (strong, nonatomic) NSArray *dataSource_2;

@end

@implementation XMMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self creatSubViews];
    
 }

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    [JPUSHService setBadge:0];

}

- (void)creatSubViews
{
    self.index = 1;
    
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
    
    btn_2.enabled = NO;
    
    [self.view addSubview:btn_2];
    
    self.btn_2 = btn_2;
    
    [btn_2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(btn_1.mas_right).offset(13);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(186));
        
        make.size.equalTo(CGSizeMake(112, 26));
        
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn_2.enabled = YES;
    });
    
    //!< 添加tableView
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
  
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.showsVerticalScrollIndicator = NO;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    
    [tableView.mj_footer beginRefreshing];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(self.view);
        
        make.top.equalTo(btn_1.mas_bottom).offset(13);
        
    }];
    
    
//    [self refreshData];//!< 刷新数据
}



#pragma mark -------------- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    if(_btn_1.selected)
    {
        return self.dataSource.count;
     
    }else
    {
    
        return self.dataSource_2.count;
    }
    

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(_btn_1.selected)
    {
        XMMonitorPushMessageCell *cell = [XMMonitorPushMessageCell dequeueReuseableCellWithTableView:tableView];
        
        cell.model = self.dataSource[indexPath.row];
        
        return cell;
        
    }else
    {
        XMSystemMessageModel *model = self.dataSource_2[indexPath.row];
        
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
            
            cell.messageLabel.text = model.pushmessage;
            
            cell.type = YES;
            
            return cell;
            
        }
    }
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    if(_btn_1.selected)
    {
        NSString *text = [self.dataSource[indexPath.row] message];
        
        CGFloat width = tableView.bounds.size.width - 18 - 26 - 13;
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
        
        return rect.size.height + 13 + 20 + 13 + 8 + 13;
        
    }else
    {
        
        XMSystemMessageModel *model = self.dataSource_2[indexPath.row];
        
        //!< 判断图片地址手否有值
        if (model.imgUrl.length > 5)
        {
            //!< 有图片
            return 116;
            
        }else
        {
            //!< 没有图片，只返回文字高度就可以
            NSString *text = model.pushmessage;
            
            CGFloat width = tableView.bounds.size.width - 18 - 26 - 13;
            
            CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]} context:nil];
            
            return rect.size.height + 13 + 20 + 13 + 8 + 13;

        }
       
    }

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.btn_1.selected == YES)
    {
        return;
    }
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMSystemMessageModel *model = self.dataSource_2[indexPath.row];
    
    XMWebViewController *vc = [XMWebViewController new];
    
    vc.toUrl = model.ToUrl;
    
    [self.navigationController pushViewController:vc animated:YES];
    
    
    


}


#pragma mark -------------- 刷新数据

//!< 刷新数据的方法
- (void)refreshData
{
    
    if(self.btn_1.selected == YES)
    {
    
   
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"pushmessageget&Userid=%lu&Readstatus=0&Messagetype=0&Page=%d&Pagesize=20",[XMUser user].userid,self.index];
    
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         [_tableView.mj_footer endRefreshing];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([result isEqualToString:@"0"])
        {
            //!< 没有推送数据
            
            if (self.btn_1.selected)
            {
                [MBProgressHUD showError:@"没有更多数据"];
                
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
                    [MBProgressHUD showError:@"没有更多数据"];
                    
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
            
            if (self.btn_2.selected)
            {
                //!< 如果当前已经选中系统消息，就返回不刷新
                return;
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
             [MBProgressHUD showError:@"Net Error!"];
            
        }
       
        
        [_tableView.mj_footer endRefreshing];
        
    }];
         }else
         {
             //!< 第二个表格的刷新方法
             
             [self reloadSystemMessage];
         
         }
    
}

/**
 *  刷新系统消息
 */
- (void)reloadSystemMessage
{
    //!< 刷新回来这里
    //!< 不牵扯分页，应该是一次性返回所有的数据给客户端
    NSString *urlStr = [mainAddress stringByAppendingString:@"systemmessage"];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
         [self.tableView.mj_header endRefreshing];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.integerValue == 0 && result.length == 1)
        {
            //!< 没有推送数据
            [MBProgressHUD showError:@"No message"];
            
        }else if (result.integerValue == -1)
        {
            //!< 参数或网络错误
        
        }else
        {
            //!< 请求成功
            
            self.dataSource_2 = [XMSystemMessageModel mj_objectArrayWithKeyValuesArray:responseObject];
            
            if (self.btn_1.selected)
            {
                return ;//!< 如果当前选中的是第一个就不刷新
            }
            [self.tableView reloadData];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_header endRefreshing];
        
        [MBProgressHUD showError:@"Failure"];
        
        
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
//         [self.tableView reloadData];
        self.dataSource = nil;
        self.index = 1;
        [self.tableView.mj_footer beginRefreshing];
    }
    
    if (sender == _btn_2)
    {
        _btn_1.selected = NO;
        _btn_2.selected = YES;
        
//        [_tableView reloadData];
         self.dataSource_2 = nil;
        [self.tableView.mj_footer beginRefreshing];//!< 开始刷新
    }
    
   
    
}


#pragma mark -------------- system

- (UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;

}


@end
