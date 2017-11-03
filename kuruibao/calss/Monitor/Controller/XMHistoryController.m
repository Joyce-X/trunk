//
//  XMHistoryControllerViewController.m
//  kuruibao
//
//  Created by x on 17/7/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMHistoryController.h"
#import "MJRefresh.h"
#import "XMUser.h"
#import "XMHistoryModel.h"
#import "XMHistoryCell_us.h"
@interface XMHistoryController ()<UITableViewDelegate,UITableViewDataSource>

/**
 对字典的key进行排序
 */
@property (strong, nonatomic) NSArray *sortArr;

@property (weak, nonatomic) UITableView *tableView;

@property (assign, nonatomic) int pageIndex;

/**
 数据源
 */
@property (strong, nonatomic) NSMutableDictionary *dictionary;

@end

@implementation XMHistoryController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupInit];

}

- (void)setupInit
{
    
    self.dictionary = [NSMutableDictionary dictionary];
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.showBackgroundImage = YES;
    
    self.Title = JJLocalizedString(@"历史故障", nil);
    
    self.pageIndex = 1;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.backgroundColor = XMClearColor;
    
    tableView.allowsSelection = NO;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(updateData)];
    
    tableView.contentOffset = CGPointMake(0, 0);
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    [tableView.mj_footer beginRefreshing];
    
    UIView *view = [self.view viewWithTag:7779];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(self.view);
        
        make.top.equalTo(view.mas_bottom).offset(FITHEIGHT(94));
        
    }];
    
}



#pragma mark ------- UITableViewDelegate,UITableViewDataSource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dictionary.allKeys.count;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    
    NSString *key = _sortArr[section];
    
    NSMutableArray *arr = _dictionary[key];
    
    return arr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    XMHistoryCell_us *cell = [XMHistoryCell_us dequeueReusedCellWithTableView:tableView];
    
    NSString *key = _sortArr[indexPath.section];
    
     NSMutableArray *arr = _dictionary[key];
    
    //!< 取出对应的数据
    NSDictionary *dic = arr[indexPath.row];
    

     //!< 显示数据
    cell.data = dic;
    
    return cell;
    
}



-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
//    UITableViewHeaderFooterView *
    UILabel *label = [UILabel new];
    label.textColor = XMWhiteColor;
    label.font = [UIFont systemFontOfSize:20];
    
    label.text = [NSString stringWithFormat:@"    %@",self.sortArr[section]];
    
    return label;
    


}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *key = _sortArr[indexPath.section];
    
    NSMutableArray *arr = _dictionary[key];
    
    //!< 取出对应的数据
    NSDictionary *dic = arr[indexPath.row];
    
    NSString *errorCode = dic[@"errorcodeindex"];
    
    NSString *str = [errorCode stringByAppendingFormat:@":%@",dic[@"codecontent"]];
  
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(mainSize.width - 80 - 26 - 20, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil];

    XMLOG(@"---------%f---------",rect.size.height);
    return rect.size.height + 20 + 18;

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 30;
}

#pragma mark ------- 刷新

//!< 请求数据
- (void)updateData
{
    
    
    if (!connecting)
    {
        
        [self.tableView.mj_footer endRefreshing];
        
        [MBProgressHUD showError:JJLocalizedString(@"网络未连接", nil)  toView:self.view];
    }
    
    XMUser *user = [XMUser user];
    
    //!< 请求历史数据
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"getcommandhistory&Userid=%ld&qicheid=%@&Page=%d&Pagesize=20",user.userid,user.qicheid,self.pageIndex];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        self.pageIndex++;
        
        [self.tableView.mj_footer endRefreshing];
        
        //!< 解析数据
        [self parseData:responseObject];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self.tableView.mj_footer endRefreshing];
        
        [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil) toView:self.view];
        
    }];
    
    
}

//!< 解析数据
- (void)parseData:(id)data
{
    NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (str == nil || str.length < 2)
    {
        //!< 没有数据或者网络错误
        [MBProgressHUD showError:JJLocalizedString(@"没有更多数据", nil) toView:self.view];
        
        return;
    }
    
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    //!< 存放记录的数组
    NSArray *result = dic[@"rows"];
    
    for (NSDictionary *recordDic in result)
    {
        
        id obj = recordDic[@"errorcodeindex"];
        
        if ([obj isKindOfClass:[NSNull class]])
        {
            continue;
        }
        
        if ([obj isKindOfClass:[NSString class]])
        {
            if ([(NSString *)obj  isEqualToString:@""])
            {
                continue;
            }
        }
        
        //!< 取出当前这条记录的时间
        NSString *time = [recordDic[@"createtime"] substringToIndex:4];
        
        BOOL contain = NO;
        
        //!< 判断字典中是否存在key于time相等
        for (NSString *key in _dictionary.allKeys)
        {
            if ([key isEqualToString:time])
            {
                
                contain = YES;
//                break;
            }
        }
        
        if(contain)
        {
            //!< 存在key，直接将当前数据添加到key对应的数组
            NSMutableArray *arrM = _dictionary[time];
            
            [arrM addObject:recordDic];
            
        }else
        {
            //!< 不存在以当前时间为key，创建并添加数据
            _dictionary[time] = [NSMutableArray array];
        
            [_dictionary[time] addObject:recordDic];
        
        }
        
    
        
    }
    
    //!< 这里对数据进行处理，要有分组标题
    
    //!< 对key排序
    self.sortArr = [_dictionary.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return NSOrderedDescending;
    }];
    
    /*
    //!< 测试数据
    self.sortArr = @[@"2017"];
    
  
     NSString *errorCode = data[@"errorcodeindex"];
     
     NSString *str = [errorCode stringByAppendingFormat:@" %@",data[@"codecontent"]];
     
     self.contentLabel.text = str;
     
     //!< 在显示事件的时候需要对时间字符串进行处理
     NSString *time = data[@"createtime"];
     
    
    NSDictionary *temDic = @{@"createtime":@"2017-09-20T16:32:15",@"errorcodeindex":@"P2545",@"codecontent":@"Torque Management Request Input Signal \"A\" Range/Performance"};
    
     NSDictionary *temDic1 = @{@"createtime":@"2017-09-19T16:32:15",@"errorcodeindex":@"C0032",@"codecontent":@"Left Front Wheel Speed Sensor Supply"};
    
    self.dictionary = [@{@"2017":@[temDic,temDic1]} mutableCopy];
    
    */
    [self.tableView reloadData];
    
    if (_pageIndex == 2)
    {
        [self.tableView setContentOffset:CGPointZero];
    }
    
}



@end
