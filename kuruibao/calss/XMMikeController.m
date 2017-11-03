//
//  XMMikeController.m
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMikeController.h"

#import "XMShowLogsController.h"

@interface XMMikeController ()<UITableViewDelegate,UITableViewDataSource>

/**
 数据源
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

/**
 表格
 */
@property (weak, nonatomic) UITableView *tab;

@end

@implementation XMMikeController

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self setupUI];

}

- (void)setupUI
{
    
    
    self.view.backgroundColor = [UIColor blackColor];
    
    //!< 返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setImage:[UIImage imageNamed:@"us_back"] forState:normal];
    
    [backBtn addTarget:self action:@selector(backArrowClcik) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    
    [self.view addSubview:backBtn];
    
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(45, 45));
        
        make.left.equalTo(self.view).offset(15);
        
        make.top.equalTo(self.view).offset(45);
        
    }];
    
    UILabel *label = [UILabel new];
    
    label.textColor = XMWhiteColor;
    
    label.text = @"查看测试信息";
    
    label.frame = CGRectMake(90, 50, mainSize.width - 180, 50);
    
    label.textAlignment  = NSTextAlignmentCenter;
    
    [self.view addSubview:label];

    //!< 添加表
    UITableView *tab = [[UITableView alloc]initWithFrame:CGRectMake(0, 120, mainSize.width, mainSize.height - 120)];
    
    tab.delegate = self;
    
    tab.dataSource = self;
    
    tab.tableFooterView = [UIView new];
    
    [self.view addSubview:tab];
    
    self.tab = tab;
    
    //!< 添加按钮，恢复原始值
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [btn setTitle:@"恢复默认值" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(resetMike:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(mainSize.width - 120, 15, 120, 30);
    
    btn.tag = 0;
    
    [self.view addSubview:btn];
    
    //!< 添加增加长度按钮
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [btn1 setTitle:@"增加长度限制" forState:UIControlStateNormal];
    
    [btn1 addTarget:self action:@selector(resetMike:) forControlEvents:UIControlEventTouchUpInside];
    
    btn1.tag = 1;
    
    btn1.frame = CGRectMake(mainSize.width - 120, 50, 120, 30);
    
    [self.view addSubview:btn1];
    
    //!< 添加减少长度按钮
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [btn2 setTitle:@"减少长度限制" forState:UIControlStateNormal];
    
    btn2.tag = 2;
    
    [btn2 addTarget:self action:@selector(resetMike:) forControlEvents:UIControlEventTouchUpInside];
    
    btn2.frame = CGRectMake(mainSize.width - 120, 85, 120, 30);
    
    [self.view addSubview:btn2];
    
    
}

#pragma mark ------- lazy

-(NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        
        _dataSource = [NSMutableArray array];
        
        XMMike *mike = [XMMike shareMike];
        //!< 总共需要4条数据
        
        //!< 1 判断是否开启中国手机号码验证
        NSString *str1 = mike.verifyChinaPhoneNumber ? @"是否开启中国手机验证：是" : @"是否开启中国手机验证：否";
        
        
        //!< 2 判断是否开启美国区域码验证
        NSString *str2 = mike.verifyAmericaAreaCode ? @"是否开启美国区域码验证：是" : @"是否开启美国区域码验证：否";
        
        //!< 设置美国手机号码长度限制
        NSString *str3 = [NSString stringWithFormat:@"当前美国手机号码长度限制为: %ld位",mike.americaPhoneNumberLength];
        
        NSString *str4 = @"点击查看日志";
        
        [_dataSource addObject:str1];
        
        [_dataSource addObject:str2];

        
        [_dataSource addObject:str3];

        
        [_dataSource addObject:str4];

        
        
    }

    return _dataSource;

}


/**
 恢复默认值
 */
- (void)resetMike:(UIButton *)sender
{
    
    XMMike *mike = [XMMike shareMike];
    
    if (sender.tag == 0)
    {
        mike.verifyAmericaAreaCode = YES;
        
        mike.verifyChinaPhoneNumber = YES;
        
        mike.americaPhoneNumberLength = 10;
        
        self.dataSource = nil;
        
        [self.tab reloadData];
    }
    
    if (sender.tag == 1)
    {
        
        
        mike.americaPhoneNumberLength++;
        
        self.dataSource = nil;
        
        [self.tab reloadData];
    }
    
    
    if (sender.tag == 2)
    {
       
        
        mike.americaPhoneNumberLength--;
        
        self.dataSource = nil;
        
        [self.tab reloadData];
    }
    
    
    
}


/**
 点击返回按钮
 */
- (void)backArrowClcik
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark ------- UITableViewDelegate,UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mike"];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mike"];
    }
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    XMMike *mike = [XMMike shareMike];
    
    if (indexPath.row == 0)
    {
        //!< 点击是否开启中国手机验证
        mike.verifyChinaPhoneNumber = !mike.verifyChinaPhoneNumber;
    }
    
    if (indexPath.row == 1)
    {
        //!< 点击验证区域码
        mike.verifyAmericaAreaCode = !mike.verifyAmericaAreaCode;
    }
    
    if(indexPath.row == 2)
    {
        //!< 点击限制长度
    
    }
    
    if(indexPath.row == 3)
    {
    
        //!< 点击查看日志
        [self presentViewController:[XMShowLogsController new] animated:YES completion:nil];
    
    }

    self.dataSource = nil;
    
    [tableView reloadData];

}


@end
