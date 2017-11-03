//
//  XMDetailTroubleController.m
//  kuruibao
//
//  Created by x on 17/8/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMDetailTroubleController.h"

#import "XMTroubleCell_us.h"

#import "XMHistoryController.h"
@interface XMDetailTroubleController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) UITableView *tableView;

@end

@implementation XMDetailTroubleController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupInit];
    
}

- (void)setupInit {
    
    //!< 显示历史记录按钮
    UIButton *historyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [historyBtn setImage:[UIImage imageNamed:@"us_chengking_history"] forState:UIControlStateNormal];
    
    [historyBtn addTarget:self action:@selector(historyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:historyBtn];
    
    [historyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(FITHEIGHT(55));
        
        make.right.equalTo(self.view).offset(-20);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(32), FITHEIGHT(39)));
        
    }];
    
    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.showSubtitle = YES;
    
    self.Title = JJLocalizedString(@"问题记录", nil);
    
    self.subtitle = self.itemName;
    
    UITableView *tableView = [UITableView new];
    
    tableView.dataSource = self;
    
    tableView.delegate = self;
    
    tableView.allowsSelection = NO;
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.backgroundColor = XMClearColor;
    
    [self.view addSubview:tableView];
    
    self.tableView = tableView;
    
    UIView *view = [self.view viewWithTag:7780];
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view);
        
        make.right.equalTo(self.view);
        
        make.bottom.equalTo(self.view);
        
        make.top.equalTo(view.mas_bottom).offset(FITHEIGHT(94));
        
    }];
    
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return self.data.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMTroubleCell_us *cell = [XMTroubleCell_us dequeueReusedCellWithTableView:tableView];
    
    NSDictionary *dic = self.data[indexPath.row];
    
    cell.text = [dic[@"code"] stringByAppendingFormat:@": %@",dic[@"codedesc"]];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dic = self.data[indexPath.row];
    
    NSString *text = [dic[@"code"] stringByAppendingFormat:@": %@",dic[@"codedesc"]];
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake((mainSize.width - 50), MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:15]} context:nil];
    
    
    return rect.size.height + 26;

}


/**
 点击历史按钮
 */
- (void)historyBtnClick
{
    //    XMLOG(@"---------historyBtnClick---------");
    
    XMHistoryController *vc = [XMHistoryController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}


@end
