//
//  XMAccountSetController.m
//  kuruibao
//
//  Created by x on 17/8/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMAccountSetController.h"
#import "XMLoginViewController.h"
#import "XMLoginNaviController.h"
#import "XMFindPwdViewController.h"
@interface XMAccountSetController ()
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@end

@implementation XMAccountSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInit];

}

- (void)setupInit{
   
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"账户设置", nil);
    
    //!< 获取用户信息，用星号显示
    XMUser *user = [XMUser user];
    
    NSString *number = user.mobil;
    
    if (number.length < 8)
    {
        self.phoneLabel.text = JJLocalizedString(@"******", nil);
    }else
    {
    
      number =  [number stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    
    }
    
    self.phoneLabel.text = number;
    
    //!< 添加退出按钮
    UIButton *logoutBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    
    [logoutBtn setImage:[UIImage imageNamed:@"logout button"] forState:UIControlStateNormal];
    
    [logoutBtn addTarget:self action:@selector(logoutBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:logoutBtn];
    
    [logoutBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self.view).offset(-FITHEIGHT(66));
        
        make.centerX.equalTo(self.view);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(196), FITHEIGHT(54)));
        
    }];
    
    UILabel *label1 = [self.view viewWithTag:21];
    
    UILabel *label2 = [self.view viewWithTag:22];
    
    label1.text = JJLocalizedString(@"手机号码", nil);
    
    label2.text = JJLocalizedString(@"修改密码", nil);
    
}


/**
 *  点击修改密码
 */
- (IBAction)clickChangePwd:(id)sender {
    
    
//    [MBProgressHUD showError:@"没有界面暂时"];
    XMFindPwdViewController *vc = [XMFindPwdViewController new];
    
    vc.titleText = JJLocalizedString(@"修改密码 ", nil);
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

#define scoreKey  @"lastScore_US"  //需要退出的时候，删除上一次的得分数据

- (void)logoutBtnClick
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
     
    //!< 删除账户信息
    BOOL res = [[NSFileManager defaultManager] removeItemAtPath:ACCOUNTPATH error:nil];
    
    if (res) {
        
        XMLOG(@"---------删除用户信息成功---------");
    }else
    {
        
        XMLOG(@"---------删除用户信息失败---------");
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:scoreKey];
    
    //!< 发送通知,通知相关界面关闭定时器
    [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalWillExitNotification object:nil];
     
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view];
        
         [UIApplication sharedApplication].keyWindow.rootViewController = [[XMLoginNaviController alloc]initWithRootViewController:[XMLoginViewController new]];
        
        
    });
    
}


@end
