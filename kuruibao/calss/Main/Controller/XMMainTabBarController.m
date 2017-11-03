//
//  XMMainTabBarController.m
//  KuRuiBao
//
//  Created by x on 16/6/21.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMMainTabBarController.h"
#import "XMTabBarButton.h"

@interface XMMainTabBarController ()

@property (nonatomic,weak)UIButton* lastBtn;

/**
 底部tabbar
 */
@property (weak, nonatomic) UIView  *bottomView;

@end

@implementation XMMainTabBarController

- (void)viewDidLoad
{

    [super viewDidLoad];
    
    //->>自定义tabbar
    [self setupCustomTabbar];
    
    [self chooseSubViewController];

}


//!< 选择显示的子控制器
- (void)chooseSubViewController
{
//    self.selectedIndex = 1;
//    
//    self.selectedIndex = 0;
//   
    
}

/**
 *  自定义tabbar 布局子控件
 */
- (void)setupCustomTabbar
{
    UIView *tabbar = [[UIView alloc]initWithFrame:self.tabBar.bounds];
    
    UIImageView *backGroundImageView = [[UIImageView alloc]initWithFrame:self.tabBar.bounds];
    
//    backGroundImageView.image = [UIImage imageNamed:@"mainPage_tabbar_cover_us"];
    
    backGroundImageView.backgroundColor = [UIColor colorWithRed:60/255.0 green:59/255.0 blue:64/255.0 alpha:1];
    
    [tabbar addSubview:backGroundImageView];

    [self.tabBar addSubview:tabbar];
    
    self.bottomView = tabbar;

    //-----------------------------seperate line---------------------------------------//
 
    //->>添加按钮
    
    //->>体检
    XMTabBarButton *checkBtn = [[XMTabBarButton alloc]init];
    
    [checkBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_home_normal_us"] forState:UIControlStateNormal];
    
    [checkBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_home_highLight_us"] forState:UIControlStateSelected];
 
    checkBtn.tag = 0;
    
    [checkBtn addTarget:self action:@selector(tabBarItemDidClick:) forControlEvents:UIControlEventTouchDown];

    [tabbar addSubview:checkBtn];
    
    self.lastBtn = checkBtn;
    
    self.lastBtn.selected = YES;
    
    self.selectedIndex = 0;
    
    [checkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(tabbar);
        
        make.top.equalTo(tabbar);
        
        make.bottom.equalTo(tabbar);
        
        make.width.equalTo(mainSize.width / 4);
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    
    //->>地图
    XMTabBarButton *mapBtn = [[XMTabBarButton alloc]init];
    
    [mapBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_GPS_normal_us"] forState:UIControlStateNormal];
    
    [mapBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_GPS_highLight_us"] forState:UIControlStateSelected];
    
     mapBtn.tag = 1;
    
    [mapBtn addTarget:self action:@selector(tabBarItemDidClick:) forControlEvents:UIControlEventTouchDown];
    
    [tabbar addSubview:mapBtn];
    
    [mapBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(checkBtn.mas_right);
        
        make.top.equalTo(tabbar) ;
        
        make.bottom.equalTo(tabbar);
        
        make.width.equalTo(mainSize.width / 4);
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    
    //->>轨迹
    XMTabBarButton *routeBtn = [[XMTabBarButton alloc]init];
    
    [routeBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_track_normal_us"] forState:UIControlStateNormal];
    
    [routeBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_track_highLight_us"] forState:UIControlStateSelected];
 
     routeBtn.tag = 2;
    
     [routeBtn addTarget:self action:@selector(tabBarItemDidClick:) forControlEvents:UIControlEventTouchDown];
   
    [tabbar addSubview:routeBtn];
    
    [routeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        
        make.left.equalTo(mapBtn.mas_right);
        
        make.top.equalTo(tabbar) ;
        
        make.bottom.equalTo(tabbar) ;
        
        make.width.equalTo(mainSize.width / 4);
    }];
    
    
    //-----------------------------seperate line---------------------------------------//
    
    //->>我的
    XMTabBarButton *myBtn = [[XMTabBarButton alloc]init];
    
    [myBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_my_normal_us"] forState:UIControlStateNormal];
    
    [myBtn setImage:[UIImage imageNamed:@"mainPage_tabbar_my_highLight_us"] forState:UIControlStateSelected];
    
    myBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    myBtn.tag = 3;
    
     [myBtn addTarget:self action:@selector(tabBarItemDidClick:) forControlEvents:UIControlEventTouchDown];

    [tabbar addSubview:myBtn];
    
    [myBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(routeBtn.mas_right);
        
        make.top.equalTo(tabbar) ;
        
        make.bottom.equalTo(tabbar) ;
        
        make.width.equalTo(mainSize.width / 4);
        
    }];

    
}

/**
 手动设置选中的item
 
 @param index 第几个 0-3
 */
- (void)setSelectItem:(int)index
{
    
    XMTabBarButton *btn = [self.bottomView viewWithTag:index];
    
    [self tabBarItemDidClick:btn];
    

}


/**
 *  监控按钮的点击
 */
- (void)tabBarItemDidClick:(UIButton *)sender
{
  
      if (sender.selected)return; //->>如果是选中状态不执行操作
    
      self.lastBtn.selected = NO;
    
      sender.selected = YES;
    
      self.selectedIndex = sender.tag;
    
      self.lastBtn = sender;
    
}



- (UIStatusBarStyle)preferredStatusBarStyle
{

    return [self.selectedViewController preferredStatusBarStyle];
}


@end
