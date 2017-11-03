//
//  XMShowLogsController.m
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMShowLogsController.h"

#import "XMLogCell.h"

@interface XMShowLogsController ()<UITableViewDelegate,UITableViewDataSource>
/**
 数据源
 */
@property (strong, nonatomic) NSMutableArray *dataSource;

/**
 表格
 */
@property (weak, nonatomic) UITableView *tab;

@end

@implementation XMShowLogsController



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
    
    label.text = @"展示测试信息";
    
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
    
    [btn setTitle:@"刷新" forState:UIControlStateNormal];
    
    [btn addTarget:self action:@selector(updateMike:) forControlEvents:UIControlEventTouchUpInside];
    
    btn.frame = CGRectMake(mainSize.width - 120, 15, 120, 30);
    
    btn.tag = 0;
    
    [self.view addSubview:btn];
    
    
    
    
}

#pragma mark ------- lazy

-(NSMutableArray *)dataSource
{
    
    return [XMMike shareMike].logMsgs;
    
}


/**
 刷新
 */
- (void)updateMike:(UIButton *)sender
{
    
    if (self.dataSource.count == 0)
    {
        return;
    }
    
    NSInteger index = self.dataSource.count;
    
    [self.tab reloadData];
    
    [self.tab scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:index - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
//    [self.tab setContentOffset:CGPointMake(0, _tab.contentSize.height) animated:YES];
    
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
    
    XMLogCell *cell = [tableView dequeueReusableCellWithIdentifier:@"mike"];
    
    if (cell == nil)
    {
        cell = [[XMLogCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"mike"];
    }
    
    cell.text = self.dataSource[indexPath.row];
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSString *str = self.dataSource[indexPath.row];
    
    CGRect rect = [str boundingRectWithSize:CGSizeMake(mainSize.width - 60, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil];
    
    return rect.size.height + 40;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    
}
@end
