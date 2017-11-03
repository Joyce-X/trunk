//
//  XMRegisterView.m
//  kuruibao
//
//  Created by x on 16/9/30.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMRegisterView.h"
#import "AlertTool.h"
#import "XMVerifyManager.h"
#import "XMCustomTextField.h"


@interface XMRegisterView()
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet XMCustomTextField *phoneTF; //!< 电话
@property (weak, nonatomic) IBOutlet XMCustomTextField *pwdTF;//!< 密码

@property (weak, nonatomic) IBOutlet XMCustomTextField *verifyCodeTF;//!< 验证码

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

@property (assign, nonatomic) BOOL clickCode;//!< 是否点击获取验证码
/**
 定时器
 */
@property (strong, nonatomic) NSTimer *timer;


@property (assign, nonatomic) int index;

@end
@implementation XMRegisterView




 //!< 注册按钮
- (IBAction)registerBtnClick:(id)sender {
    
    //!< 判断电话号码是否为空，是否合法，密码是否为空，是否合法
#warning 电话号码格式确定后进行格式校验
    //!< 电话是否合法
    if(![self validateMobile:_phoneTF.text])
    {
        [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"手机号码格式不正确", nil)];
        
        return;
        
    }
    
    //!< 密码是否合法
    if(_pwdTF.text.length < 6 || _pwdTF.text.length > 20)
    {
       [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"密码为6-20位", nil)];
        return;
        
    }
    
    //!< 判断是否点击验证码
    if (!self.clickCode)
    {
         [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"未获取验证码", nil)];
        return;
        
    }
    
       //!< 通知代理执行注册操作
    if(self.delegate && [self.delegate respondsToSelector:@selector(registerViewDidClickRegisterBtnWithPhoneNumber:pwd:verifyCode:)])
    {
        
        [self.delegate registerViewDidClickRegisterBtnWithPhoneNumber:_phoneTF.text pwd:_pwdTF.text verifyCode:_verifyCodeTF.text];
        
    }
    
}

//< 获取验证码
- (IBAction)getVerifyCodeBnClick:(UIButton *)sender {
    
    
    
    //!< 判断手机号码是否正确，错误提示手机号码不正确，正确通知控制器发送验证码
    //!< 验证是否输入手机号码
    if (_phoneTF.text.length == 0)
    {
        [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"请输入电话号码", nil)];
        return;
    }


    if(![self validateMobile:_phoneTF.text])
    {
        [AlertTool showAlertWithTarget:(UIViewController *)self.delegate title:nil content:JJLocalizedString(@"手机号码格式不正确", nil)];
        return;
        
    }
    
    //!< 通知代理发送验证码
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerViewDidClickGetVerifyCodeBtnWithPhoneNumber:)])
    {
        [self.delegate registerViewDidClickGetVerifyCodeBtnWithPhoneNumber:_phoneTF.text];
        
        self.clickCode = YES;
        
    }
   
    
 
    
}

-(void)startCountdown
{

    UIButton *sender = self.getCodeBtn;
    //!< 创建显示倒计时的label
    UILabel *label = [UILabel new];
    
    label.textColor = XMWhiteColor;
    
    label.font  = sender.titleLabel.font;
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.frame = sender.frame;
    
    label.tag = 999;
    
    [self addSubview:label];
    
    //!< 进行倒计时操作
    sender.hidden = YES;
    
    self.index = 59;
    
    label.text = JJLocalizedString(@"59 second(s)", nil);
    
    
//    self.timer =  [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
//        
//        if (index == 1)
//        {
//             [label removeFromSuperview];
//            
//            sender.hidden = NO;
//            
//            [timer invalidate];
//            
//            return ;
//        }
//        
//        index--;
//        
//        label.text = [NSString stringWithFormat:@"%d second(s)",index];
//        
//    }];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeLabelText:) userInfo:label repeats:YES];
   
 
  

}

- (void)changeLabelText:(NSTimer *)timer
{
    
    UILabel *label = timer.userInfo;
    
    if (_index == 1)
    {
        [label removeFromSuperview];
        
        self.getCodeBtn.hidden = NO;
        
        [timer invalidate];
        
        return ;
    }
    
    _index--;
    
    label.text = [NSString stringWithFormat:@"%d second(s)",_index];
    
    
}


/**
 *  判断电话号码是否合法
 */
- (BOOL) validateMobile:(NSString *)mobile
{
    
    return [XMVerifyManager verifyAreaCode:mobile];
    
}




- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.firstBtn.userInteractionEnabled = NO;
    
    self.secondBtn.userInteractionEnabled = NO;
    
    self.thirdBtn.userInteractionEnabled = NO;
   
//
    self.phoneTF.placeholder = JJLocalizedString(@"请输入手机号码", nil);
    
    self.verifyCodeTF.placeholder = JJLocalizedString(@"请输入短信验证码", nil);
    
    self.pwdTF.placeholder = JJLocalizedString(@"密码不少于6位，并由字母和数字组成", nil);
    
    UIButton *btn = [self viewWithTag:21];
    
    [btn setTitle:JJLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    [btn setTitle:JJLocalizedString(@"获取验证码", nil) forState:UIControlStateHighlighted];

    
   
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
        
        self.firstBtn.selected = self.phoneTF.text.length >= minimumPhonenNumberLength;
        
        
    }else if (noti.object == self.pwdTF)
    {
        
         self.thirdBtn.selected = self.pwdTF.text.length >= minimumPWDLength;
            
     }else if (noti.object == self.verifyCodeTF)
    {
        
        self.secondBtn.selected = self.verifyCodeTF.text.length > 0;
        
    }
    
    if(self.phoneTF.text.length >= minimumPhonenNumberLength &&  [XMVerifyManager verifyPasswordValid:self.pwdTF.text]  && self.verifyCodeTF.text.length > 0)
    {
         self.registerBtn.enabled = YES;
        
    }else
    {
         self.registerBtn.enabled = NO;
    }
    
   
}


#pragma mark ------- sethidden
- (void)setHidden:(BOOL)hidden
{

    [super setHidden:hidden];
    
    if (!hidden)
    {
        return;
    }
    
    self.phoneTF.text = nil;
    
    self.verifyCodeTF.text = nil;
    
    self.pwdTF.text = nil;

    self.getCodeBtn.hidden = NO;
    
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }

    UILabel *label = [self viewWithTag:999];
    
    [label removeFromSuperview];
}


/**
 *  清除定时器，恢复获取验证码按钮
 */
- (void)clearTimer
{
    self.phoneTF.text = nil;
    
    self.verifyCodeTF.text = nil;
    
    self.pwdTF.text = nil;
    
    self.getCodeBtn.hidden = NO;
    
    if (self.timer)
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    UILabel *label = [self viewWithTag:999];
    
    [label removeFromSuperview];

    
}



@end
