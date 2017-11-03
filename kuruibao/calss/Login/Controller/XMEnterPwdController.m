//
//  XMEnterPwdController.m
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMEnterPwdController.h"

#import "XMEnterPwd.h"

#import "AlertTool.h"

#import "NSString+Hash.h"

#define slideUpOffset 160 //键盘弹起时，View偏移量
@interface XMEnterPwdController ()<XMEnterPwdDelegate>

@property (weak, nonatomic) XMEnterPwd *pwdView;

@end

@implementation XMEnterPwdController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setupInit];
    
    [self monitorKeyboard];
}


- (void)setupInit
{
    
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"重置密码", nil);
    
    XMEnterPwd *enterpwdView = [[NSBundle mainBundle] loadNibNamed:@"XMEnter" owner:nil options:nil].firstObject;
    
    enterpwdView.delegate = self;
    
    [self.view addSubview:enterpwdView];
    
    self.pwdView = enterpwdView;
    
    [enterpwdView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self.view);
        
        make.top.equalTo(self.view).offset(FITHEIGHT(240));
        
    }];
    
    
    
    
}

#pragma mark ------- XMEnterPwdDelegate
/**
 *  点击验证按钮
 */
- (void)EnterPwdClickConfirmBtn:(XMEnterPwd *)enterView
{

    if (![_pwdView.password1 isEqualToString:_pwdView.password2]) {
        
        [AlertTool showAlertWithTarget:self title:nil content:JJLocalizedString(@"两次密码不一致", nil)];
        
        return;
    }
    //!< 判第一个密码格式是否正确，判断两次密码是否一致
//    if (![self pwdValidate:_pwdView.password1])
//    {
//        [AlertTool showAlertWithTarget:self title:nil content:@"password is not enough strong!"];
//        
//        return;
//    }

    //!< 发送更改密码请求
    NSString *password = enterView.password1;
    
    NSString *phoneNumber = self.phoneNumber;
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"Updatepasswordbymobil&Mobil=%@&Password=%@",phoneNumber,[password md5String]];
    
    [MBProgressHUD showMessage:nil toView:self.view];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        [MBProgressHUD hideHUDForView:self.view];
        
        
        
        if (result.intValue == 1)
        {
            //!< 修改成功
            [MBProgressHUD showMessage:JJLocalizedString(@"修改成功", nil) toView:self.view];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                [MBProgressHUD hideHUDForView:self.view];
                
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            });
            
            
        }else
        {
            //!< 修改失败
            [MBProgressHUD showError:JJLocalizedString(@"修改失败", nil)];
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [MBProgressHUD hideHUDForView:self.view];
        
        [MBProgressHUD showError:JJLocalizedString(@"网络异常", nil)];
        
    }];
    
}

/**
 *  判断手机号码是否有效
 */
- (BOOL)pwdValidate:(NSString *)pwd
{
    //!< 暂时只是判断位数，后期添加判断区号
    if(pwd.length > 5)
    {
        return YES;
    }else
    {
        
        return NO;
    }
    
    
}


//->> 监听键盘的弹起和落下
- (void)monitorKeyboard
{
    
    //!<监听键盘的弹起和落下
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    
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



@end
