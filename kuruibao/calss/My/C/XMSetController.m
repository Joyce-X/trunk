//
//  XMSetController.m
//  kuruibao
//
//  Created by x on 17/8/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMSetController.h"
#import "XMAccountSetController.h"
#import "XMHelpViewController_us.h"
#import "XMSet_userBackViewController.h"
#import "XMSet_helpViewController.h"
#import "XMPresent.h"
#import "XMChooseLanguageView.h"
@interface XMSetController ()<UIAlertViewDelegate,XMChooseLanguageViewDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *messageSwitch;//!< 消息按钮

@property (weak, nonatomic) IBOutlet UILabel *setLabel;
@property (weak, nonatomic) IBOutlet UILabel *pushmsgLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UILabel *helpLabel;
@property (weak, nonatomic) IBOutlet UILabel *feedbackLabel;
@property (weak, nonatomic) IBOutlet UILabel *supportLabel;
@property (weak, nonatomic) IBOutlet UILabel *languageLabel;

@end

@implementation XMSetController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupInit];



}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self getPushState];//!< 获取推送状态
    


}

- (void)setupInit
{
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"设置", nil);
    
    _setLabel.text = JJLocalizedString(@"账号设置", nil);
    
    _pushmsgLabel.text = JJLocalizedString(@"推送消息", nil);
    
    _cacheLabel.text = JJLocalizedString(@"清理缓存", nil);
    
    _helpLabel.text = JJLocalizedString(@"帮助", nil);
    
    _feedbackLabel.text = JJLocalizedString(@"反 馈", nil);
    
    _supportLabel.text = JJLocalizedString(@"支持", nil);
    
    _languageLabel.text = JJLocalizedString(@"语言", nil);
    
}


- (void)getPushState
{
    //!< 获取服务器关于推送消息的设置来设置当前按钮的状态
    XMUser *user = [XMUser user];
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"getpushsetting&Userid=%lu",user.userid];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *res = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        
        if (res.integerValue == 0 && res.length == 1)
        {
            //!< 没有找到用户数据
            self.messageSwitch.on = NO;
            
        }else if(res.integerValue == -1)
        {
            //!< 参数或网络错误
        
        
        }else
        {
            //!< 获取信息成功
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
            XMLOG(@"---------获取成功---------");
            NSDictionary *dic = arr.firstObject;
            
            BOOL flag = [dic[@"chekuangflag"] boolValue];
            
            self.messageSwitch.on = flag;
        
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        XMLOG(@"---------获取推送消息失败---------");
    }];
    
    
}



/**
 *  监听消息开关
 */
- (IBAction)messageValueChange:(id)sender {
    
    
    UISwitch *sw = sender;
    
    XMUser *user = [XMUser user];
    
    int value = sw.on ? 1 : 0;
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"pushsetting&Userid=%lu&type=3&Value=%d",user.userid,value];
    
    [MBProgressHUD showMessage:nil];
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showSuccess:JJLocalizedString(@"操作成功", nil)];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"操作失败", nil)];
        
        sw.on = !sw.on;
    }];
    
}


/**
 *  点击账户设置
 */
- (IBAction)clickAccountSetting:(id)sender {
    
    XMAccountSetController *vc = [XMAccountSetController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击清理缓存
 */
- (IBAction)clickClear:(UITapGestureRecognizer *)sender {
    
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:JJLocalizedString(@"确认清除缓存?", nil) delegate:self cancelButtonTitle:JJLocalizedString(@"取消", nil) otherButtonTitles:JJLocalizedString(@"确定 ", nil), nil];
    
    [alert show];
}

/**
 *  点击帮助
 */
- (IBAction)clickHelp:(id)sender {
    
    XMHelpViewController_us *vc = [XMHelpViewController_us new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击反馈
 */
- (IBAction)clickFeedback:(id)sender {
    
    XMSet_userBackViewController *vc = [XMSet_userBackViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 *  点击好评
 */
- (IBAction)clickGoodComment:(id)sender {
    
//    1273634634 DashPal Appid  testID:1185454831

   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id1185454831"]];
    
}



/**
 *  点击语言
 */
- (IBAction)languageClick:(UITapGestureRecognizer *)sender {
    
    XMLOG(@"---------语言设置---------");
    
    XMChooseLanguageView *languageView = [[[NSBundle mainBundle] loadNibNamed:@"XMChooseLanguageView" owner:nil options:nil] firstObject];
    
    NSString *language = [XMLanguageManager shareInstance].currentLanguage;
    
    if ([language isEqualToString:@"en"])
    {
        [languageView setLanguage:XMLanguageTypeEnglish];
        
    }else if ([language isEqualToString:@"zh-Hans"])
    {
        [languageView setLanguage:XMLanguageTypeChinese];
        
    }else
    {
        [languageView setLanguage:XMLanguageTypeAuto];
    }
    
    
    languageView.delegate = self;
    
    [XMPresent presentView:languageView];
    
    
    
}

#pragma mark ------- XMChooseLanguageViewDelegate

- (void)chooseLanguageView:(XMChooseLanguageView *)view didSelectedIndex:(NSUInteger)index
{

    [XMPresent dismiss];
    
    //!< 1判断传进来的下标是否等于当前正在使用的语言，如果是不执行任何操作，2 如果不是则进行相应的语言切换 3,切换完成修改当前标记语言的变量
    if (index == 1)
    {
        //!< 点击跟随系统
        if(![[XMLanguageManager shareInstance].currentLanguage isEqualToString:@"DashPal"])
        {
            [XMLanguageManager shareInstance].currentLanguage = @"DashPal";//!< 设置与其他不同的字符即可，程序内部会进行处理
            
            //!< 刷新数据
            [self refreshText];

        } 
        
    }else if(index == 2)
    {
        if ([[XMLanguageManager shareInstance].currentLanguage isEqualToString:@"en"])
        {
            //!< 不执行操作
        }else
        {
            
            [XMLanguageManager shareInstance].currentLanguage = @"en";
            
            //!< 刷新数据
            [self refreshText];
        
        }
    
    }else
    {
        
        if ([[XMLanguageManager shareInstance].currentLanguage isEqualToString:@"zh-Hans"])
        {
            //!< 不执行操作
        }else
        {
            
            [XMLanguageManager shareInstance].currentLanguage = @"zh-Hans";
            
            //!< 刷新数据
            [self refreshText];
            
        }
        
    
    }
    

}

- (void)refreshText
{
    //!< 刷新当前界面
    [MBProgressHUD showMessage:nil toView:self.view];
    
    //!< 发送通知，通知四个主界面更新语言
    [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalWillChangeLanguageNotification object:nil];
    
    self.Title = JJLocalizedString(@"设置", nil);
    
    _setLabel.text = JJLocalizedString(@"账号设置", nil);
    
    _pushmsgLabel.text = JJLocalizedString(@"推送消息", nil);
    
    _cacheLabel.text = JJLocalizedString(@"清理缓存", nil);
    
    _helpLabel.text = JJLocalizedString(@"帮助", nil);
    
    _feedbackLabel.text = JJLocalizedString(@"反 馈", nil);
    
    _supportLabel.text = JJLocalizedString(@"支持", nil);
    
    _languageLabel.text = JJLocalizedString(@"语言", nil);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [MBProgressHUD hideHUDForView:self.view];
    });
    
    

    
    
}


#pragma mark ------- UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{

    if (buttonIndex == 1)
    {
        //!< click clear button
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        
        [MBProgressHUD showSuccess:JJLocalizedString(@"清理完成", nil)];
        
    }else
    {
    
        XMLOG(@"---------点击取消按钮---------");
    }

}




@end
