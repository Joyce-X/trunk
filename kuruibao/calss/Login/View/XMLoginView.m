//
//  XMLoginView.m
//  kuruibao
//
//  Created by x on 16/9/30.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMLoginView.h"
#import "UIView+alert.h"
#import "NSString+Hash.h"
#import "AlertTool.h"
#import "XMVerifyManager.h"
#import "XMCustomTextField.h"
@interface XMLoginView()

@property (weak, nonatomic) IBOutlet XMCustomTextField *phoneTF; //!< 电话输入框

@property (weak, nonatomic) IBOutlet XMCustomTextField *pwdTF;//!< 密码输入框

@property (assign, nonatomic) BOOL isSelect; //!< 默认是选中的，也就是select = NO 的时候表示用户同意协议，为YES时代表不同意协议

/**
 电话号码前的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

/**
 密码前的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *pwdBtn;

/**
 登录按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *logInBtn;

@end
@implementation XMLoginView

#pragma mark --- 监听按钮点击


//!< 登录
- (IBAction)loginBtnClick:(id)sender {
    
    //!< 验证手机号码正确性 和密码长度之后，通知代理做登录操作  判断是否同意协议

     //!< 判断手机号码正确性
//#warning 确定手机号码格式后，判断手机号码的合法性
    
    
//    if(![self validateMobile:_phoneTF.text])
//    {
//         [self showAlertWithMessage:@"手机号码格式不正确" btnTitle:@"确定"];
//        return;
//    }
    

    
    //!< 判断密码格式
    if (_pwdTF.text.length < 6 || _pwdTF.text.length > 20) {
        
         [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"密码为6-20位", nil)];
            return;
    }
    
    
    //!< 判断是否同意协议
    if(_isSelect)
    {
        
         [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"未同意用户使用协议", nil)];
        return;
        
    
    }
    
    //!< 通知代理
    if(self.delegate && [self.delegate respondsToSelector:@selector(loginViewDidClickLoginBtn:phineNumber:pwd:)])
    {
        //!< 密码不进行加密传递 在登录操作时候进行加密操作
        [self.delegate loginViewDidClickLoginBtn:self phineNumber:_phoneTF.text pwd:_pwdTF.text];
    }
    
}

//!< 忘记密码
- (IBAction)losePwdBtnClick:(id)sender {
    
    //!< 通知代理跳转到找回密码界面
    if(self.delegate && [self.delegate respondsToSelector:@selector(loginViewDidClickLosePwdBtn:)])
    {
        [self.delegate loginViewDidClickLosePwdBtn:self];
    
    }
    
}


//!< 协议内容
- (IBAction)protocolTitleClick:(id)sender {
    
    //!< 通知代理展示用户协议界面
    if (self.delegate && [self.delegate respondsToSelector:@selector(loginViewDidClickUserProtocolBtn:)])
    {
        [self.delegate loginViewDidClickUserProtocolBtn:self];
    }
    
}

//!< 选中协议
- (IBAction)selelctProtocolBtnClick:(UIButton *)sender{
    
    //!< 更改显示状态
    //!< 默认是选中的，也就是select = NO 的时候表示用户同意协议，为YES时代表不同意协议
    
    sender.selected = !sender.selected;
    _isSelect = sender.selected;
}


/**
 *  判断电话号码是否合法
 */
- (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    
    return [phoneTest evaluateWithObject:mobile];
}


#pragma mark --- 从其他界面跳转到登录页面时，快速填充账号和密码

- (void)setPhoneNumber:(NSString *)phoneNumber
{
    _phoneNumber = phoneNumber;
    
    _phoneTF.text = phoneNumber;


}

- (void)setPwd:(NSString *)pwd
{
    _pwd = pwd;
    
    _pwdTF.text = pwd;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];

    self.phoneBtn.userInteractionEnabled = NO;
    
    self.pwdBtn.userInteractionEnabled = NO;
    
    [self.logInBtn mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.bottom.equalTo(self).offset(FITHEIGHT(58));
        
        make.centerX.equalTo(self);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(196), FITHEIGHT(54)));
        
    }];
    
    self.phoneTF.placeholder = JJLocalizedString(@"请输入手机号码", nil);
    
    self.pwdTF.placeholder = JJLocalizedString(@"请输入密码", nil);
    
    UIButton *btn = [self viewWithTag:21];
    
    [btn setTitle:JJLocalizedString(@"忘记密码 ", nil) forState:UIControlStateNormal];
    
    [btn setTitle:JJLocalizedString(@"忘记密码 ", nil) forState:UIControlStateHighlighted];

   
    UIButton *btn1 = [self viewWithTag:22];
    
    [btn1 setTitle:JJLocalizedString(@"用户使用协议", nil) forState:UIControlStateNormal];
    
    [btn1 setTitle:JJLocalizedString(@"用户使用协议", nil) forState:UIControlStateHighlighted];
    
    
    
 }

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];;


}

#pragma mark ------- 响应通知的方法
- (void)textFieldTextChange:(NSNotification *)noti
{
    if (noti.object == self.phoneTF)
    {
 
        self.phoneBtn.selected = self.phoneTF.text.length >= minimumPhonenNumberLength;
        
    }else if (noti.object == self.pwdTF)
    {
         
        self.pwdBtn.selected = self.pwdTF.text.length >= minimumPWDLength;
        
    }
    
    if(self.phoneTF.text.length >= minimumPhonenNumberLength &&  [XMVerifyManager verifyPasswordValid:self.pwdTF.text])
    {
        self.logInBtn.enabled = YES;
        
    }else
    {
        self.logInBtn.enabled = NO;
    }
    
    
   
   
    
}


@end
