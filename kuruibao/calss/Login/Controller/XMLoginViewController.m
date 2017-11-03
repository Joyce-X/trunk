//
//  XMLoginViewController.m
//  KuRuiBao
//
//  Created by x on 16/6/23.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMLoginViewController.h"
#import "XMUserProtocolViewController.h"

#import "XMSettingViewController.h"

#import "AppDelegate.h"

#import "NSString+Hash.h"
#import "XMLoginView.h"
#import "XMRegisterView.h"
#import "XMFindPwdViewController.h"


#import "MJExtension.h"
#import "XMUser.h"
#import "XMLogBtn_us.h"
#import "AlertTool.h"
#import <SMS_SDK/SMSSDK.h>

#import "XMMikeController.h"

#define topViewHeight FITHEIGHT(276)  //顶部黑色背景高度

#define buttonHeight 55 //登录注册按钮高度
#define slideUpOffset 160 //键盘弹起时，View偏移量

static int timeline = 59; //!< 倒计时时间设置

@interface XMLoginViewController ()<XMLoginViewDelegate,XMRegisterViewDelegate,UIScrollViewDelegate>

@property (nonatomic,weak)NSTimer* timer;//!< 定时器

@property (nonatomic,weak)UIImageView* greenView;//!< 选项卡线条
/**
 注册的电话号码
 */
@property (copy, nonatomic) NSString *registerNumber;

/**
 注册时候获取的验证码
 */
@property (copy, nonatomic) NSString *verifyCode;

@property (nonatomic,strong)XMRegisterView* registerView;//!< 注册界面

@property (nonatomic,weak)XMLoginView* loginView;//!< 登录界面

@property (nonatomic,weak)XMLogBtn_us* loginBtn;//!< 登录按钮

@property (copy, nonatomic) NSString *pwd;//md5

//-----------------------------seperate line---------------------------------------//
@property (strong, nonatomic) XMLogBtn_us *registerBtn;

@property (weak, nonatomic) UIScrollView *scroll;//!< 管理注册和登录


@property (assign, nonatomic) CGFloat lastOffset;//!< scroll 上一次的偏移量

@end


@implementation XMLoginViewController


#pragma mark --- lifeCircle

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //-- 设置控件
    [self setupSubviews];
    
    //->>监听键盘通知
    [self monitorKeyboard];
    
}


#pragma mark --- setupSubViews

/**
 *  初始化子控件
 */
- (void)setupSubviews
{
    self.showBackgroundImage = YES;
   
     //!< 创建顶部带logo的大背景
    UIImageView *topview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 20, mainSize.width, topViewHeight)];
 
    topview.image = [UIImage imageNamed:@"Login_backgroundUp"];
    
    topview.userInteractionEnabled = YES;
    
    [self.view addSubview:topview];
    
    //!< 添加logo
    UIImageView *logoIV1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Logo_DashPal"]];
    
    logoIV1.contentMode = UIViewContentModeScaleAspectFit;
    
    [topview addSubview:logoIV1];
    
    [logoIV1 mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(120, 120));
        make.center.equalTo(topview);
        
    }];
    
    //!< 添加登录注册按钮
    XMLogBtn_us *loginBtn = [XMLogBtn_us buttonWithType:UIButtonTypeCustom];
    
    [loginBtn setTitle:JJLocalizedString(@"登录", nil) forState:UIControlStateNormal];
    
    loginBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [loginBtn setTitleColor:XMRedColor forState:UIControlStateSelected];
    [loginBtn setTitleColor:XMGrayColor forState:UIControlStateNormal];
    
    loginBtn.tag = 0;
    
    loginBtn.selected = YES;
    
    [loginBtn addTarget:self action:@selector(topBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [topview addSubview:loginBtn];
    
    self.loginBtn = loginBtn;
    
     [loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.bottom.equalTo(topview);
        
        make.width.equalTo(mainSize.width * 0.5);
        
        make.height.equalTo(buttonHeight);
        
    }];
    
    
    //!< 注册按钮
    XMLogBtn_us *registerBtn = [XMLogBtn_us buttonWithType:UIButtonTypeCustom];
    
    [registerBtn setTitle:JJLocalizedString(@"注册", nil) forState:UIControlStateNormal];
    
    registerBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [registerBtn setTitleColor:XMGrayColor forState:UIControlStateNormal];
    [registerBtn setTitleColor:XMRedColor forState:UIControlStateSelected];
    
    registerBtn.tag = 1;
    
    registerBtn.selected = NO;
    
    [registerBtn addTarget:self action:@selector(topBtnDidClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [topview addSubview:registerBtn];
    
    self.registerBtn = registerBtn;
    
    [registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.bottom.equalTo(topview);
        
        make.width.equalTo(mainSize.width * 0.5);
        
        make.height.equalTo(buttonHeight);
        
    }];
    
    
    //!< 添加红色线条
    UIImageView *greenLine = [UIImageView new];
    
    greenLine.backgroundColor = XMRedColor;
    
    [topview addSubview:greenLine];
    
    self.greenView = greenLine;
    
    [greenLine mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.width.equalTo(registerBtn);
        
        make.height.equalTo(2);
        
        make.bottom.equalTo(registerBtn);
        
        make.left.equalTo(loginBtn);
        
    }];
    
    
    CGFloat scrollHeight = mainSize.height - 20 - topViewHeight;
    
    //!< 添加scrollVIew
    UIScrollView *scroll = [[UIScrollView alloc]init];
    
    scroll.pagingEnabled = YES;
    
    scroll.bounces = NO;
    
    scroll.showsHorizontalScrollIndicator = NO;
    
    scroll.contentSize = CGSizeMake(mainSize.width * 2, 0);
    
    scroll.frame = CGRectMake(0, 20 + topViewHeight, mainSize.width, scrollHeight);
    
    scroll.delegate = self;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick)];
    
    [scroll addGestureRecognizer:tap];
    
    [self.view addSubview:scroll];
    
    self.scroll = scroll;
    
    //!< 添加登录View和注册view
    XMLoginView *loginView = [[[NSBundle mainBundle] loadNibNamed:@"XMLogin" owner:nil options:nil] firstObject];
    
    loginView.delegate = self;
    
    loginView.frame = CGRectMake(0, 0, mainSize.width, scrollHeight);
    
    [scroll addSubview:loginView];
    
    self.loginView = loginView;
    
    //!< 注册
    XMRegisterView *registerView = [[[NSBundle mainBundle]loadNibNamed:@"XMRegister" owner:nil options:nil] firstObject];
    
    registerView.frame = CGRectMake(mainSize.width,0,mainSize.width,scrollHeight);
    
    registerView.delegate = self;
    
    [scroll addSubview:registerView];
    
    self.registerView = registerView;
    
    
    //!< 添加长按手势
    UITapGestureRecognizer *longPress = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
    
    longPress.numberOfTapsRequired = 4;
    
    [self.view addGestureRecognizer:longPress];
    
  
    
       
  }

- (void)longPress
{
    
    XMMikeController *vc = [XMMikeController new];
    
    [self presentViewController:vc animated:YES completion:nil];
    
    
}



#pragma mark --- 监听按钮点击事件

- (void)topBtnDidClick:(UIButton *)sender
{
    if (sender.selected)
    {
        return;
    }
    
    sender.selected = !sender.selected;
    
    
    if (sender.tag) //!< 点击注册
    {
        [self.view endEditing:YES];
        
        [self.scroll setContentOffset:CGPointMake(mainSize.width, 0) animated:YES];
        
        self.loginBtn.selected = NO;
        
       
        
    }else   //!< 点击登录
    {
        [self.view endEditing:YES];
        
        [self.scroll setContentOffset:CGPointMake(0, 0) animated:YES];
        
        self.registerBtn.selected = NO;
        
         
    }
    
    
}


//->> 监听键盘的弹起和落下
- (void)monitorKeyboard
{
    
    //!<监听键盘的弹起和落下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
 
    
}

- (void)tapClick{

    
   [self.view endEditing:YES];
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

      [self.view endEditing:YES];

}

#pragma mark --- 注册成功跳转登录

/**
 *  环信酷锐宝注册成功，开始跳转登录
 *
 *
 */
- (void)registerSuccessJumpToLoginWithPhoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd
{
    //!< 设置登录界面账号和密码，代码点击登录按钮
    [MBProgressHUD hideHUD];
    
    self.loginView.phoneNumber = phoneNumber;
    
    self.loginView.pwd = pwd;
    
    [self topBtnDidClick:self.loginBtn];//!< 切换界面
    
    [self.registerView clearTimer];//!< 清空定时器
    
    [self loginViewDidClickLoginBtn:nil phineNumber:phoneNumber pwd:pwd];//!< 登录

}




#pragma mark --- XMLoginViewDelegate

/**
 *  点击忘记密码按钮
 */
- (void)loginViewDidClickLosePwdBtn:(XMLoginView *)loginView
{
    XMFindPwdViewController *findPwdViewController = [XMFindPwdViewController new];
    
    __weak typeof(self) wSelf = self;
    
    findPwdViewController.finishFind = ^(NSString *phoneNumber,NSString *pwd)
    {
        //!< 和注册相同方法 点击完成的话跳转到登录页面进行登录
        [wSelf registerSuccessJumpToLoginWithPhoneNumber:phoneNumber pwd:pwd];
    
    };
    
    [self.navigationController pushViewController:findPwdViewController animated:YES];
}


/**
 *
 *  点击用户协议
 *
 */
- (void)loginViewDidClickUserProtocolBtn:(XMLoginView *)loginView
{
     XMUserProtocolViewController *protocolVC = [[XMUserProtocolViewController alloc]init];
 
    [self presentViewController:protocolVC animated:YES completion:nil];


}

/**
 *  执行登录操作
 *
 *
 */
- (void)loginViewDidClickLoginBtn:(XMLoginView *)loginView phineNumber:(NSString *)phoneNumber pwd:(NSString *)pwd
{
    

    //!< 开始发送登录请求(在logView中已经进行判断)
     [self.view endEditing:YES];
    
    if (!connecting)
    {
        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"网络未连接", nil)];
        
        return;
    }
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
//     NSString *urlStr = [mainAddress stringByAppendingFormat:@"Login&Mobil=%@&Password=%@&Source=G",phoneNumber,[pwd md5String]];
    
    //----------------------------------------------------------------//
 
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    para[@"Mobil"] = phoneNumber;
    
    para[@"Password"] = [pwd md5String];
    
    para[@"Source"] = @"G";
    
    [self.session POST:@"http://api.longseer.online/v2.ashx?key=43f32f4722e0991ae17403a549e1f244&method=Login" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSString *showStr;
        
        if ([result isEqualToString:@"0"])
        {
            showStr = JJLocalizedString(@"用户名或密码错误", nil);
            
        }else if ([result isEqualToString:@"-2"])
        {
            showStr = JJLocalizedString(@"用户不存在", nil);
            
        }else if([result isEqualToString:@"-1"])
        {
            showStr = @"Network  busy";
        }
        
        if (showStr.length > 0)
        {
            [AlertTool showAlertWithTarget:self title:nil content:showStr];
            
            return;
        }
        
        
        
        {
            //!< 登陆成功，字典转模型保存用户信息
            //!< 保存用户信息
            NSError *error = nil;
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            
            if([obj isKindOfClass:[NSArray class]])
            {
                NSDictionary *dic = [(NSArray *)obj firstObject];
                
                XMUser *user = [XMUser userWithDictionary:dic];
                
                //-- 保存用户类型
                //                [[NSUserDefaults standardUserDefaults] setInteger:user.typeId forKey:@"typeId"];
                
                //                [[NSUserDefaults standardUserDefaults] synchronize];
                
                //用户信息不存在的时候，保存用户信息
                [XMUser save:user whenUserExist:NO];
                
            }else
            {
                
                [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"登录失败", nil)];
                
                XMLOG(@"服务器返回参数错误");
                
                [XMMike addLogs:[NSString stringWithFormat:@"服务器返回参数错误"]];

                
                return;
            }
            
            //!< 跳转页面 设置主窗口
            
            UITabBarController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"XMMainTabBarController"];
            
            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"登录失败", nil)];
        
    }];
    
    //------------------------------------------------------------------//
   
//     [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
//         
//         NSString *showStr;
//         
//        if ([result isEqualToString:@"0"])
//        {
//            showStr = JJLocalizedString(@"用户名或密码错误", nil);
//            
//        }else if ([result isEqualToString:@"-2"])
//        {
//            showStr = JJLocalizedString(@"用户不存在", nil);
//        
//        }else if([result isEqualToString:@"-1"])
//        {
//            showStr = @"Network  busy";
//        }
//         
//         if (showStr.length > 0)
//         {
//             [AlertTool showAlertWithTarget:self title:nil content:showStr];
//             
//             return;
//         }
//         
//        
//         
//        {
//            //!< 登陆成功，字典转模型保存用户信息
//            //!< 保存用户信息
//            NSError *error = nil;
//            
//            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
//            
//            if([obj isKindOfClass:[NSArray class]])
//            {
//                NSDictionary *dic = [(NSArray *)obj firstObject];
//                
//                XMUser *user = [XMUser userWithDictionary:dic];
//                
//                //-- 保存用户类型
////                [[NSUserDefaults standardUserDefaults] setInteger:user.typeId forKey:@"typeId"];
//                
////                [[NSUserDefaults standardUserDefaults] synchronize];
//        
//                 [XMUser save:user];
//                
//            }else
//            {
//                
//                [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"登录失败", nil)];
//                
//                XMLOG(@"服务器返回参数错误");
//                
//                return;
//             }
//            
//            //!< 跳转页面 设置主窗口
//            
//            UITabBarController *mainVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"XMMainTabBarController"];
//            
//            [UIApplication sharedApplication].keyWindow.rootViewController = mainVC;
//        }
//        
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        
//        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"登录失败", nil)];
//        
//     }];
//    

    

}


#pragma mark --- XMRegisterViewDelegate

/**
 *  获取验证码
 *
 *  para:电话号码
 */
- (void)registerViewDidClickGetVerifyCodeBtnWithPhoneNumber:(NSString *)phoneNumber
{
    
    [self.view endEditing:YES];
    
    if(!connecting)
    {
        //!< 无网络
        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"网络未连接", nil)];
        return;
    }
    
    //!< 获取验证码
    self.registerNumber = phoneNumber;//!< 记录获取验证码手机号码，在注册的时候进行二次验证
    
    //!< 发请求获取验证码
    
    [MBProgressHUD showSuccess:JJLocalizedString(@"验证码已发送", nil)];
    
    //!< 显示倒计时
    [self.registerView startCountdown];
 
    NSString *zone;
    
    if (phoneNumber.length == [XMMike shareMike].americaPhoneNumberLength)
    {
        //!< 美国手机
        zone = @"1";
//        zone = @"+60";
        
    }else
    {
        //!< 中国手机
        zone = @"86";
    }
    
//    if (phoneNumber.length == 10 || phoneNumber.length == 11)
//    {
//        zone = @"+60";
//    }
    
     //!< 请求验证码
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:phoneNumber zone:zone result:^(NSError *error) {
        
        if (error)
        {
            //!< 发送失败
            XMLOG(@"---------%@--发送失败---------",error);
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------%@--发送失败---------",error]];

            
        }else
        {
            //!< 发送成功
            XMLOG(@"---------发送成功---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------发送成功---------"]];

        
        }
        
        
    }];
    
  
}


/**
 *  注册酷锐宝账户
 *
 *
 */
- (void)registerViewDidClickRegisterBtnWithPhoneNumber:(NSString *)phoneNumber pwd:(NSString *)pwd verifyCode:(NSString *)verifyCode
{
    
    
    [self.view endEditing:YES];
    
    //!< 获取验证码手机和注册手机是否一致，
    if (![_registerNumber isEqualToString:phoneNumber]) {
        

    [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"电话号码不一致", nil)];
        
        return;
    }
    
    [MBProgressHUD showMessage:JJLocalizedString(@"加载中...", nil)];
    
    //!< 判断记录的手机号码和验证码是否存在且和现在传进来的一致，就不用进行SMS验证
    if(_registerView.phoneNumber_smsSuccess.length > 0 && [_registerView.phoneNumber_smsSuccess isEqualToString:phoneNumber] && _registerView.verifyCode_smsSuccess.length > 0 && [_registerView.verifyCode_smsSuccess isEqualToString:verifyCode])
    {
    
        //!< 一切验证通过开始注册
        [self registerWithPhoneNumber:phoneNumber pwd:pwd];
    
    
    }else
    {
        
        NSString *zone = _registerNumber.length == [XMMike shareMike].americaPhoneNumberLength ? @"1" : @"86";
        
//        NSString *zone;
//        if (phoneNumber.length == 10 || phoneNumber.length == 11)
//        {
//            zone = @"+60";
//        }
        
        //!< 判断验证码时都正确
        [SMSSDK commitVerificationCode:verifyCode phoneNumber:_registerNumber zone:zone result:^(NSError *error) {
            
            if (error)
            {
                //!< 验证失败
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showError:JJLocalizedString(@"验证码错误", nil)];
                
            }else
            {
                
                //!< 短信验证成功，保存手机号码和短信验证码
                self.registerView.phoneNumber_smsSuccess = phoneNumber;
                
                self.registerView.verifyCode_smsSuccess = verifyCode;
                
                //!< 一切验证通过开始注册
                [self registerWithPhoneNumber:phoneNumber pwd:pwd];
                
            }
        }];
    
    
    }
    
    
    
    
}

/**
 先服务器注册

 @param number 手机号码
 @param pwd 密码
 */
- (void)registerWithPhoneNumber:(NSString *)number pwd:(NSString *)pwd
{
    //!< 一切验证通过开始注册
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Reg&Mobil=%@&Password=%@",number,[pwd md5String]];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        //!< 状态值
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        int state = [result intValue];
        
        switch (state) {
            case 0:
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     [MBProgressHUD showError:JJLocalizedString(@"注册失败", nil)];
                });
                
                break;
                
            case -3:
                
                     [MBProgressHUD showError:JJLocalizedString(@"电话号码已经注册过", nil)];
                
                
                break;
                
            case -2:
                
               XMLOG(@"---------非有效手机号码---------");
                
                
                break;
                
            default:
                
                [MBProgressHUD showMessage:JJLocalizedString(@"注册成功，即将跳转登录", nil)];
                
                //!< 跳转登录操作
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    
                    
                    [self registerSuccessJumpToLoginWithPhoneNumber:_registerNumber pwd:pwd];
                    
                });
                
                
                NSString *userNumber = [NSString stringWithFormat:@"%d",state];
                
                //!< 保存用户编号到沙河
                [[NSUserDefaults standardUserDefaults] setObject:userNumber forKey:@"userNumber"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                break;
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        [MBProgressHUD showError:JJLocalizedString(@"注册失败，请检查网络连接", nil)];
        
    }];
    
}



#pragma mark --- ****************************

#pragma mark -- 监听通知的方法

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)noti
{
    if (self.view.y != 0)return;
    
    XMLOG(@"%@",noti.userInfo);
    
    [XMMike addLogs:[NSString stringWithFormat:@"%@",noti.userInfo]];

    CGFloat duration = [noti.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        
        self.view.y -= slideUpOffset;
        
    }];
  
    
}



/**
 *  键盘即将隐藏
 */
- (void)keyboardWillHide:(NSNotification *)noti
{
    if (self.view.y == 0)return;
   
    [UIView animateWithDuration:0.25 animations:^{
        
        self.view.y += slideUpOffset;
        
    }];
    
}
 






#pragma mark -- timer

- (void)chageLabelTitle:(NSTimer *)sender
{
    
    self.registerView.labelText = [NSString stringWithFormat:@"%d秒后重新发送",--timeline];
    
    if (timeline == 0)
    {
         //-- 时间到
        [sender invalidate];
        
        self.timer = nil;
        
        self.registerView.isShowTimer = NO;
        
        timeline = 59;
        
        self.registerView.labelText = @"59秒后重新发送";
    }
    
    
    
}


#pragma mark ------- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //!< 在scroll滑动的时候，修改红色线条的位置
    //!< 最大偏移量为屏幕宽度，对应线条最大偏移量为屏幕一半 2：1
    
    CGPoint offset = scrollView.contentOffset;

    CGFloat increment = offset.x - self.lastOffset;
    
    self.greenView.transform = CGAffineTransformTranslate(_greenView.transform, increment/2.0, 0);
    
    self.lastOffset = offset.x;
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    XMLOG(@"---------%f---------",scrollView.contentOffset.x);
    
    [XMMike addLogs:[NSString stringWithFormat:@"---------%f---------",scrollView.contentOffset.x]];

    //!< 判断结束拖动时候的偏移量
    if (scrollView.contentOffset.x > mainSize.width / 2)
    {
        //!< 设置点击注册按钮
        [self topBtnDidClick:self.registerBtn];

    }else
    {
        //!< 设置点击登录
        [self topBtnDidClick:self.loginBtn];
//        self.logBtn
    
    }


}

/**
 *  关闭定时器
 */
- (void)closeTimer
{
    if(self.timer)
    {
        XMLOG(@"定时器销毁");
         [self.timer invalidate];
        self.timer = nil;
        timeline = 59;
        
    }
    
    
}

 

- (UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;

}


- (void)dealloc
{
    //-- 移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //-- 销毁定时器
    [self closeTimer];
    
    
}

@end
