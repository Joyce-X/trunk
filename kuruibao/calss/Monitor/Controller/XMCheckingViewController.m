//
//  XMCheckingViewController.m
//  kuruibao
//
//  Created by x on 17/7/27.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCheckingViewController.h"
#import "TTWaterWaveView.h"
#import "XMAnimateCell.h"
#import "XMScoreLabel.h"
#import "AlertTool.h"
#import "XMHistoryController.h"
#import "XMDataTool.h"

@interface XMCheckingViewController ()<UITableViewDelegate,UITableViewDataSource>

/**
 定时器 执行table动画
 */
@property (strong, nonatomic) NSTimer *timer;

@property (weak, nonatomic) UITableView *tableView;

@property (weak, nonatomic) UIButton *bottomBtn;

@property (weak, nonatomic) TTWaterWaveView *animateView;
/**
 顶部显示分数
 */
@property (weak, nonatomic) XMScoreLabel *scoreLabel;

/**
 timer1 用来修改分数
 */
@property (strong, nonatomic) NSTimer *timer1;

@property (assign, nonatomic) BOOL showResult;//!< 标志，是否显示结果，如果显示结果则计算行高，否则返回固定值

@property (assign, nonatomic) int index;//!< 修改分数

@property (assign, nonatomic) int index1;//!< tab动画

/**
需要显示的滚动信息
 */
@property (strong, nonatomic) NSArray *temArr;


@end

@implementation XMCheckingViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setupSubviews];

}

- (void)viewDidDisappear:(BOOL)animated
{
    
    [super viewDidDisappear:animated];
    
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
  
}

- (void)setupSubviews
{
    self.showBackgroundImage = YES;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    self.index = 0;
    
    self.index1 = 0;

    
    //!< 设置动画view
    TTWaterWaveView *waveView = [[TTWaterWaveView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, FITHEIGHT(225))];
    
    waveView.percent = 0.5;
    
    waveView.firstWaveColor = [UIColor grayColor];
    
    waveView.secondWaveColor = [UIColor whiteColor];
    
    [self.view addSubview:waveView];
    
    self.animateView = waveView;
    
    [waveView startWave];
    
    //!< 设置tableView
    UITableView *tableView = [UITableView new];
    
    tableView.delegate = self;
    
    tableView.dataSource = self;
    
    tableView.backgroundColor = XMClearColor;
    
    tableView.tableFooterView = [UIView new];
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  
    tableView.allowsSelection = NO;
    
    tableView.showsVerticalScrollIndicator = NO;
    
    [self.view insertSubview:tableView belowSubview:_animateView];//!< 插在动画底层
    
    self.tableView = tableView;
    
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.equalTo(self.view);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(225));
        
        make.bottom.equalTo(self.view).offset(-FITHEIGHT(108));
        
    }];
    
    UIView *cover = [UIView new];
    
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.4;
    
    cover.tag = 100;
    
    [self.view addSubview:cover];
    
    [cover mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.right.equalTo(tableView);
        
        make.height.equalTo(tableView).multipliedBy(0.5);
        
    }];
    
    
    for (int i = 0; i<9; i++) {
        
        [self.dataSource addObject:@""];
        
    }
    
    NSString *path = [[NSBundle mainBundle ] pathForResource:@"troubleCode.txt" ofType:nil];
    
    NSError *error;
    
    NSString *str = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:&error];
    
    self.temArr = [str componentsSeparatedByString:@"\n"];
    
     //!< 添加线条
    //!< seperate line
    UIImageView *seperateLine1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_connectLine_us"]];
    
    [self.view addSubview:seperateLine1];
    
    [seperateLine1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(1);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(225));
        
    }];
    
    UIImageView *seperateLine2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_connectLine_us"]];
    
    [self.view addSubview:seperateLine2];
    
    [seperateLine2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.equalTo(self.view);
        
        make.height.equalTo(1);
        
        make.bottom.equalTo(self.view).offset(-FITHEIGHT(108));
        
    }];
    
    //!< 添加取消按钮
    UIButton *bottomBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [bottomBtn setImage:[UIImage imageNamed:@"us_checking_btn_cancel"] forState:UIControlStateNormal];
    
    [bottomBtn setImage:[UIImage imageNamed:@"us_checking_btn_finish"] forState:UIControlStateSelected];
    
    [bottomBtn addTarget:self action:@selector(bottomBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:bottomBtn];
    
    self.bottomBtn = bottomBtn;
    
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(FITWIDTH(265));
        
        make.height.equalTo(FITHEIGHT(70));
        
        make.centerX.equalTo(self.view);
        
        make.top.equalTo(seperateLine2).offset(FITHEIGHT(13));
        
    }];
    
    
    //!< 添加分数
    XMScoreLabel *scoreLabel = [XMScoreLabel new];
    
    scoreLabel.fontSize = 120;
    
    CGSize size = [@"100%" sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:120/96*72]}];
    
    scoreLabel.animateScore = 0;
    
    [self.view addSubview:scoreLabel];
    
    _scoreLabel = scoreLabel;
    
    [scoreLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(seperateLine1).offset(-FITHEIGHT(75));
        
        make.centerX.equalTo(self.view);
        
        make.size.equalTo(size);
        
    }];
    
    //!< 开启定时器刷新显示文字
//    __weak typeof(self) wself = self;
//    
//    static int Index = 0;
    
    
    //!< 这两个定时器的方法都是在ios10之后出来的，必须要适配ios9，所以不能这么用
    /*
    NSTimer *timer = [NSTimer timerWithTimeInterval:0.05 repeats:YES block:^(NSTimer * _Nonnull timer) {
        
        if (scoreLabel.animateScore > 90)
        {
            [wself.dataSource addObject:@""];
            
        }else
        {
         
            [wself.dataSource addObject:temArr[Index + 9]];
        
        }
        
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
       
         [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        
        Index++;
        
    }];
    
    [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    
    self.timer = timer;
    
    
   
   __block int index = 0;
    
  self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.11 repeats:YES block:^(NSTimer * _Nonnull timer) {
       
        scoreLabel.animateScore = ++index;
        
        if (index == 90) {
            //!< 获取检测结果
            [self getCheckedResult];
        }
        
        if (index > 99)
        {
            //!< 销毁定时器，停止tableView的动画
            [timer invalidate];
            
            [wself.timer invalidate];
            
            [self.tableView setContentOffset:CGPointZero];
            
        }
        
    }];
     */
    
    //!< 修改分数
    self.timer1 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(changeScore:) userInfo:nil repeats:YES];
    
    
    //!< tab动画
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.04 target:self selector:@selector(tabAnimate:) userInfo:nil repeats:YES];
}

- (void)changeScore:(NSTimer *)timer
{
    
    self.scoreLabel.animateScore = self.index1++;
    
    if (self.index1 == 90) {
        //!< 获取检测结果
        [self getCheckedResult];
        
    }
    
    if (self.index1 == 100)
    {
        
//        self.scoreLabel.animateScore = 100;
        
        //!< 销毁定时器
        [timer invalidate];
        
        self.timer1 = nil;
        
    }
}

- (void)tabAnimate:(NSTimer *)timer
{
    
    if (_scoreLabel.animateScore > 90)
    {
        [self.dataSource addObject:@" "];
        
    }else
    {
        
        [self.dataSource addObject:self.temArr[self.index + 9]];
        
    }

    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];

    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    self.index++;
    

    
    
}


#pragma mark ------- tableview 代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return self.dataSource.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XMAnimateCell*cell = [XMAnimateCell dequeueReusedCellWithTableView:tableView];
    
    cell.textLabel.text = self.dataSource[indexPath.row];
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.showResult) {
        
        return 30;
    }else
    {
        
        NSString *text = self.dataSource[indexPath.row];
        
        CGRect rect = [text boundingRectWithSize:CGSizeMake(mainSize.width - 30, INFINITY) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:13]} context:nil];
        
        return rect.size.height + 20;
    
    }

}

#pragma mark ------- 按钮点击方法
- (void)bottomBtnDidClick:(UIButton *)sender
{
    
    if (_timer)
    {
        [_timer invalidate];
        _timer = nil;
        
     }
    
    if (self.timer1)
    {
        [_timer1 invalidate];
        
        _timer1 = nil;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
    if (sender.selected)
    {
        //!< 点击的是完成按钮 代用代理方法
        if([self.delegate respondsToSelector:@selector(checkingVCWillDisAppear:)])
        {
        
            //!< 检测结果分数和数据通过self传递
            [self.delegate checkingVCWillDisAppear:self];
        
        }
    }
    
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


#pragma mark ------- 动画执行完毕，执行事件

/**
 修改响应界面
 */
- (void)changeUserInterface
{
    //!< 底部按钮切换为完成
    _bottomBtn.selected = YES;
    
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
    
    [[self.view viewWithTag:100] removeFromSuperview];
  
}

//!< 下发指令成功后获取检测结果
- (void)getCheckedResult
{
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Getcommandresult&controlid=%@",self.number];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        //!< 检测完成，更新界面
        switch (result.integerValue) {
            case 0:
            {
                //!< 获取检测信息成功（不能转为int 会返回0）
                XMLOG(@"获取检测结果成功，准备解析数据");
                
                [XMMike addLogs:@"获取检测结果成功，准备解析数据"];

                 NSArray *resultArray = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
 
                self.resultData = resultArray;
                
                [self stopTimer];
                
                [self.dataSource removeAllObjects];
                
                for (NSDictionary *dic in resultArray)
                {
                    NSString *item = [NSString stringWithFormat:@"%@: %@",dic[@"code"],dic[@"codedesc"]];
                    
                    [self.dataSource addObject:item];
                }
                
                self.showResult = YES;
                
                [self.tableView reloadData];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                [self.tableView setContentOffset:CGPointZero animated:NO];//!< set offset 0
                
                });
                
                [self changeUserInterface];
                
                [self.animateView.displayLink invalidate];
                
                //!< 得分逻辑
                self.resultScore = [XMDataTool calculateScoreWithArray:self.dataSource];
                
                [self.scoreLabel animateToScore:self.resultScore duration:1.5];
           
            }
                break;
            case -1:
                
                //!< 网络异常
                [self handleFailure];
                
                break;
            case -2:
                
                //!< 没有找到任务
              [self handleFailure];
                
                break;
                
            case 100:
                
                //!< 没有检测到问题或者问题在OBD库中没有找到
                XMLOG(@"获取检测结果成功，返回信息：没有检测到问题");
                
                [XMMike addLogs:@"获取检测结果成功，返回信息：没有检测到问题"];

                [self stopTimer];
                
                [self changeUserInterface];
                
                [_animateView.displayLink invalidate];
                
                self.dataSource = [@[@"",JJLocalizedString(@"车辆状况良好", nil)] mutableCopy];
                
                self.resultScore = 100;
                
//                self.scoreLabel.score = 100;
                [self.scoreLabel animateToScore:100 duration:1.0];
                
                [self.tableView reloadData];
                
                [self.tableView setContentOffset:CGPointZero animated:NO];//!< set offset 0
                
                break;
                
            default:
                break;
        }
        
        XMLOG(@"获取检测成功结果：%@",result);
        
        [XMMike addLogs:[NSString stringWithFormat:@"获取检测成功结果：%@",result]];

        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [self handleFailure];
        
        
    }];
    
    
}

/**
 请求失败处理
 */
- (void)handleFailure
{
    _scoreLabel.score = 0;
    
    [_animateView.displayLink invalidate];
    
    [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"网络异常", nil)];
    
    //!< 销户定时器
    [self stopTimer];
    
    [self changeUserInterface];
    
    self.resultScore = 0;

}


- (void)stopTimer
{
    if (self.timer) {
        
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    if (self.timer1) {
        
        [self.timer1 invalidate];
        
        self.timer1 = nil;
    }
    
}


- (void)dealloc
{
    XMLOG(@"-------XMCheckingViewController--dealloc ---------");
}

@end
