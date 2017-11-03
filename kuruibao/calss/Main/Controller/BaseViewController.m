//
//  BaseViewController.m
//  kuruibao
//
//  Created by x on 17/7/18.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@property (assign, nonatomic) BOOL flag;

@end

@implementation BaseViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        //!< 监听网络变化的通知
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(networkDidChange:) name:XMNetWorkDidChangedNotification object:nil];
        
        //!< 监听转换语言的通知
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeLanguage) name:kDashPalWillChangeLanguageNotification object:nil];
        
        _flag = NO;
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //!< 监听网络变化的通知
        [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(networkDidChange:) name:XMNetWorkDidChangedNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    //!< 根据网络状态设置缓存策略
    if (connecting)
    {
        //!< 有网的情况忽略缓存
        [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
        
    }else
    {
        
        //!< 无网的情况，有缓存加载缓存，没有缓存就请求
        [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];
        
        
    }


}

#pragma mark ------- lazy

-(NSMutableArray *)dataSource
{
    if (!_dataSource)
    {
        _dataSource = [NSMutableArray array];
    }
    
    return _dataSource;
    
}


-(AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        _session.requestSerializer = [AFHTTPRequestSerializer serializer];
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        _session.requestSerializer.timeoutInterval = 10;
        
//        [_session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
        
    }
    return _session;
    
}

#pragma mark ------- setter

/**
 *  背景图片
 */
- (void)setShowBackgroundImage:(BOOL)showBackgroundImage
{
    _showBackgroundImage = showBackgroundImage;
    
    if (showBackgroundImage)
    {
        
        UIImageView *iv = [self.view viewWithTag:7777];
        
        if(iv)return;
        
        //!< 显示底图
        UIImageView *backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"mainPage_backgroundImage_us"]];
        
        backgroundImageView.tag = 7777;
        
        [self.view insertSubview:backgroundImageView atIndex:0];
        
        [backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.left.right.top.bottom.equalTo(self.view);
            
        }];
        
    }else
    {
        //!< 删除底图
        UIImageView *iv = [self.view viewWithTag:7777];
        
        if (iv)
        {
            [iv removeFromSuperview];
        }
    
    }

}

/**
 *  返回按钮
 */
- (void)setShowBackArrow:(BOOL)showBackArrow
{
    _showBackArrow = showBackArrow;
    
    if (showBackArrow)
    {
        
        UIButton *btn = [self.view viewWithTag:7778];
        
        if(btn)return;
        
        //!< 显示底图
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [backBtn setImage:[UIImage imageNamed:@"us_back"] forState:normal];
        
        [backBtn addTarget:self action:@selector(backArrowClcik) forControlEvents:UIControlEventTouchUpInside];
        
        backBtn.tag = 7778;
        
        backBtn.contentEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
        
//        backBtn.backgroundColor = XMGreenColor;
//        
//        backBtn.imageView.backgroundColor = XMRedColor;
        
        [self.view addSubview:backBtn];
        
        [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(CGSizeMake(45, 45));
            
            make.left.equalTo(self.view).offset(15);
            
            make.top.equalTo(self.view).offset(45);
            
        }];
        
    }else
    {
        //!< 删除底图
        UIButton *backBtn = [self.view viewWithTag:7778];
        
        if (backBtn)
        {
            [backBtn removeFromSuperview];
        }
        
    }



}

/**
 *  显示标题
 */
- (void)setShowTitle:(BOOL)showTitle
{
    _showTitle = showTitle;
    
    if (showTitle)
    {
        
        UILabel *titleLabel = [self.view viewWithTag:7779];
        
        if(titleLabel)return;
        
        //!< 显示底图
        UILabel *title = [UILabel new];
        
        title.tag = 7779;
        
        title.font = [UIFont boldSystemFontOfSize:20];
        
        title.textColor = XMWhiteColor;
        
        [self.view addSubview:title];
     
    }else
    {
        //!< 删除底图
        UILabel *title = [self.view viewWithTag:7779];
        
        if (title)
        {
            [title removeFromSuperview];
        }
        
    }



}

/**
 *  子标题
 */
- (void)setShowSubtitle:(BOOL)showSubtitle
{
    _showSubtitle = showSubtitle;
    
    if (showSubtitle)
    {
        
        UILabel *showSubtitle = [self.view viewWithTag:7780];
        
        if(showSubtitle)return;
        
        //!< 显示底图
        UILabel *title = [UILabel new];
        
        title.tag = 7780;
        
        title.font = [UIFont systemFontOfSize:14];
        
        title.textColor = XMWhiteColor;
        
        [self.view addSubview:title];
        
    }else
    {
        //!< 删除底图
        UILabel *title = [self.view viewWithTag:7780];
        
        if (title)
        {
            [title removeFromSuperview];
        }
        
    }


}

/**
 *  设置标题
 */
- (void)setTitle:(NSString *)Title
{
    _Title = Title;
    
    UILabel *titleLabel = [self.view viewWithTag:7779];
    
    titleLabel.text = Title;
    
    CGSize size =  [Title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:20]}];
    
    size.width = ceil(size.width) + 3;
    
    size.height = ceil(size.height) + 3;
    
    
    if (_flag)
    {
        
        //!< 更新约束
        [titleLabel remakeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(size);
            
            make.left.equalTo(self.view).offset(25);
            
            make.top.equalTo(self.view).offset(FITHEIGHT(112));
            
        }];
        
    }else
    {
        //!< 添加约束
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(size);
            
            make.left.equalTo(self.view).offset(25);
            
            make.top.equalTo(self.view).offset(FITHEIGHT(112));
        }];
        
    }
    
    
}

/**
 *  设置子标题
 */
- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    
    UILabel *subLabel = [self.view viewWithTag:7780];
    
    subLabel.text = subtitle;
    
   CGSize size = [subtitle sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}];

    size.width = ceil(size.width);
    
    size.height = ceil(size.height);
    
    UILabel *titleLabel = [self.view viewWithTag:7779];

    if (_flag)
    {
        
        //!< 更新约束
        [subLabel remakeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(size);
            
            make.left.equalTo(titleLabel);
            
            make.top.equalTo(titleLabel.mas_bottom).offset(13);
            
        }];
        
    }else
    {
        //!< 添加约束
        [subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.size.equalTo(size);
            
            make.left.equalTo(titleLabel);
            
            make.top.equalTo(titleLabel.mas_bottom).offset(13);
            
        }];
    
    }
    
    
    

}


#pragma mark ------- 响应通知方法
/**
 *  网络状态发生改变
 */
- (void)networkDidChange:(NSNotification *)noti
{
    NSInteger result = [[noti.userInfo objectForKey:@"info"] integerValue];
    
    if (result == 1 || result == 2)
    {
        //!< 网络恢复
        [self networkResume];
        
    }else
    {
        //!< 网络断开
        [self networkDisconnect];
        
    }
    
}

- (void)changeLanguage
{
    
    self.flag = YES;
    
    
}



#pragma mark ------- 按钮的点击事件
/**
 *  点击返回按钮
 */
- (void)backArrowClcik
{
    [self.navigationController popViewControllerAnimated:YES];
    
}

//!< 网络恢复
- (void)networkResume
{
    XMLOG(@"---------网络恢复---------");
    
    [XMMike addLogs:@"---------网络恢复---------"];
     
     //!< 设置缓存策略为忽略缓存
    [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    
}

//!< 网络失去连接
- (void)networkDisconnect
{
    XMLOG(@"---------网络已断开---------");
    [XMMike addLogs:@"---------网络已断开---------"];
    
    
    //!< 设置缓存策略为加载缓存
    [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataDontLoad];

    
}


#pragma mark ------- system

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleLightContent;
    
}

-  (void)setDestinationHeight:(NSInteger)destinationHeight
{
    _destinationHeight = destinationHeight;
    
    UIView *view = [self.view viewWithTag:7777];
    
    [view updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.equalTo(self.view);
        
        make.height.equalTo(185);
        
    }];

}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];//!< 移除通知
    XMLOG(@"---------controller已销毁---------");
    [XMMike addLogs:@"---------controller已销毁---------"];
    
 
}

@end
