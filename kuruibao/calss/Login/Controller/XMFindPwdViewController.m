//
//  XMFindPwdViewController.m
//  KuRuiBao
//
//  Created by x on 16/6/23.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//
/**********************************************************
 class description:找回密码界面，登录时忘记密码情况进行找回密码操作
 
 **********************************************************/
#import "XMFindPwdViewController.h"
#import "AFNetworking.h"
#import "NSString+Hash.h"
#import "XMFindPwdView.h"
#import "XMEnterPwdController.h"
#import "AlertTool.h"
#import <SMS_SDK/SMSSDK.h>

#define slideUpOffset 160 //键盘弹起时，View偏移量

@interface XMFindPwdViewController ()<XMFindPwdViewDelegate>

@property (copy, nonatomic) NSString *verifyPhoneNumber;//!< 接收短信验证码的手机号码

@property (copy, nonatomic) NSString *verifyCode;//!< 找回密码时候获取的验证码

@property (weak, nonatomic) XMFindPwdView *findView;

@property (copy, nonatomic) NSString *success_phoneNumber;//!< 验证成功的手机号
@property (copy, nonatomic) NSString *success_code;//!< 验证成功的验证码


/**
 登录之后设置密码用
 */
@property (copy, nonatomic) NSString *desPhoneNumber;

@end


@implementation XMFindPwdViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //-- 设置初始化信息
    [self setupInitInfo];
    
    //->>监听键盘通知
    [self monitorKeyboard];
//
   
    
    
}

#pragma mark -- init

- (void)setupInitInfo
{
    
    self.showBackgroundImage = YES;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
   
    XMFindPwdView *findView = [[NSBundle mainBundle] loadNibNamed:@"XMFindPwd" owner:nil options:nil].firstObject;
    
    findView.delegate = self;
    
    [self.view addSubview:findView];
    
    self.findView = findView;
    
    [findView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(276));
        
    }];
    
   
    if (self.titleText.length > 0)
    {
        self.Title = self.titleText;
        
        //!< 设置只能修改当前账户的密码
        NSString *mobil = [XMUser user].mobil;
        
        [self.findView setExistPhoneNumber:mobil];
        
        
        
    }else
    {
        
        self.Title = JJLocalizedString(@"忘记密码", nil);
        
    }
    
    
}


#pragma mark --- XMFindPwdViewDelegate


/**
 点击获取验证码按钮
 
 @param view 触发者
 */
- (void)findPwdViewGetVerifyCodeBtnClick:(XMFindPwdView *)view
{
    if (!connecting)
    {
        [AlertTool showAlertWithTarget:self title:nil
                               content:JJLocalizedString(@"网络未连接", nil)];
        return;
    }
    
    //!< 发送验证码
     self.verifyPhoneNumber = view.phoneNumber;
     self.verifyCode = view.verificationCode;
    
    NSString *zone;
    
    if (_verifyPhoneNumber.length == [XMMike shareMike].americaPhoneNumberLength)
    {
        //!< 美国手机
        zone = @"1";
        
    }else
    {
        //!< 中国手机
        zone = @"86";
    }
    
//    if (_verifyPhoneNumber.length == 10 || _verifyPhoneNumber.length == 11)
//    {
//        zone = @"+60";
//    }
    
    //!< 这里要判定用户是否存在，存在的话向下执行，不存在就提示
    
    NSString *reqStr = [mainAddress stringByAppendingFormat:@"Checkuser&Mobil=%@",view.phoneNumber];
    
    [MBProgressHUD showMessage:nil];
    
    [self.session GET:reqStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [MBProgressHUD hideHUD];
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.intValue == 1)
        {
            //!< 已经被注册
            //!< 发送验证码
            
            //!< 发请求获取验证码
            [MBProgressHUD showSuccess:JJLocalizedString(@"验证码已发送", nil)];
            
            //!< 显示倒计时
            [self.findView startCountdown];
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:_verifyPhoneNumber zone:zone result:^(NSError *error) {
                
                //!< 无论发成功还是失败，都按成功逻辑走
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
            
        }else
        {
            //!< 没有被注册
            [MBProgressHUD showError:JJLocalizedString(@"电话号码还未注册", nil)];
            
        }
        
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUD];
        
        [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
        
    }];
  
}


/**
 点击下一步按钮
 
 @param view 触发者
 */
- (void)findPwdViewNextBtnClick:(XMFindPwdView *)view
{
    //!< 验证手机号
    if(![view.phoneNumber isEqualToString:self.verifyPhoneNumber])
    {
        //!< 接收验证码的手机与当前手机不一致
        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"电话号码不一致", nil)];
        
        return;
    
    }
    //!< 验证网络
    if (!connecting)
    {
        [AlertTool showAlertWithTarget:self title:nil
                               content:JJLocalizedString(@"网络未连接", nil)];
        return;
    }
    
    [self.view endEditing:YES];

    //!< 判断验证成功的信息是否存在存在就跳过验证
    if (self.success_phoneNumber.length > 0 && self.success_code.length > 0 && [self.success_phoneNumber isEqualToString:view.phoneNumber] && [self.success_code isEqualToString:view.verificationCode])
    {
        //!< 信息匹配就直接跳过SMS验证
        //!< 关闭findview定时器，
        [_findView stopTimer];
        
        //!< 跳转到下一界面，传手机号码过去
        XMEnterPwdController *vc = [XMEnterPwdController new];
        
        vc.phoneNumber = view.phoneNumber;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else{
        
        [MBProgressHUD showMessage:JJLocalizedString(@"加载中...", nil)];
        
        NSString *zone = _verifyPhoneNumber.length == [XMMike shareMike].americaPhoneNumberLength ? @"1" : @"86";//为什么等于8呢
        
//        NSString *zone;
//        
//        if (_verifyPhoneNumber.length == 10 || _verifyPhoneNumber.length == 11)
//        {
//            zone = @"+60";
//        }
        
        //!< 判断验证码时都正确
        [SMSSDK commitVerificationCode:view.verificationCode phoneNumber:_verifyPhoneNumber zone:zone result:^(NSError *error) {
            
            if (error)
            {
                //!< 验证失败
                [MBProgressHUD hideHUD];
                
                [MBProgressHUD showError:JJLocalizedString(@"验证码错误", nil)];
                
            }else
            {
                [MBProgressHUD hideHUD];
                
                //!< 验证成功，保存验证成功的手机号和验证码，如果返回这个界面，在跳转就跳过SMS验证
                self.success_code = view.verificationCode;
                self.success_phoneNumber = view.phoneNumber;
                
                //!< 关闭findview定时器，
                [_findView stopTimer];
                
                //!< 跳转到下一界面，传手机号码过去
                XMEnterPwdController *vc = [XMEnterPwdController new];
                
                vc.phoneNumber = view.phoneNumber;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }
        }];
        
    }
    
}



//->> 监听键盘的弹起和落下
- (void)monitorKeyboard
{
    
    //!<监听键盘的弹起和落下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
}


- (UIStatusBarStyle)preferredStatusBarStyle
{

    return UIStatusBarStyleLightContent;
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    
    [self.view endEditing:YES];
}


#pragma mark -- 监听通知的方法

/**
 *  键盘即将弹出
 */
- (void)keyboardWillShow:(NSNotification *)noti
{
    if (self.view.y != 0)return;
    
    CGFloat duration = [noti.userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] floatValue];
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

#pragma mark -- 监控内存
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
      
}
     


@end
