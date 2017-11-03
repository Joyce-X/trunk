//
//  XMFindPwdView.m
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMFindPwdView.h"
#import "AlertTool.h"
#import "XMVerifyManager.h"
#import "XMCustomTextField.h"
@interface XMFindPwdView ()

/**
 第一个按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *firstBtn;

/**
 第二个按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
/**
 号码输入框
 */
@property (weak, nonatomic) IBOutlet XMCustomTextField *phoneTF;
/**
 验证码输入框
 */
@property (weak, nonatomic) IBOutlet XMCustomTextField *verifyTF;
/**
 点击获取验证码的按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;

/**
 底部下一步按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;

/**
 定时器
 */
@property (strong, nonatomic) NSTimer *timer;
@property (copy, nonatomic,readwrite) NSString *phoneNumber;//!< 用户输入的电话号码
@property (copy, nonatomic,readwrite) NSString *verificationCode;//!< 验证码

@property (assign, nonatomic) BOOL clickV;//!< 是否点击过获取验证码
@property (assign, nonatomic) int index;

@end

@implementation XMFindPwdView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.firstBtn.userInteractionEnabled = NO;
    
    self.secondBtn.userInteractionEnabled = NO;
    
    [self.nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(FITHEIGHT(58));
        
        make.centerX.equalTo(self);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(196), FITHEIGHT(54)));
        
    }];
    
    //!< 国际化
    self.phoneTF.placeholder = JJLocalizedString(@"手机号码 ", nil);
    
    self.verifyTF.placeholder = JJLocalizedString(@"验证码", nil);
    
    [self.getCodeBtn setTitle:JJLocalizedString(@"获取验证码", nil) forState:UIControlStateNormal];
    
    [self.getCodeBtn setTitle:JJLocalizedString(@"获取验证码", nil) forState:UIControlStateHighlighted];
    
    
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
     
    }else if (noti.object == self.verifyTF)
    {
        
        self.secondBtn.selected = self.verifyTF.text.length > 0;
        
    }
    
    self.nextBtn.enabled = self.phoneTF.text.length > 0  && self.verifyTF.text.length > 0;
    
    
}


/**
 *  点击获取验证码按钮
 */
- (IBAction)getVerifyClick:(UIButton *)sender {
    
    
 
    if (![self phoneNumberValidate:self.phoneTF.text]) {
        
        //!< 手机号码不正确
        [AlertTool showAlertWithTarget:(UIViewController*)self.delegate title:nil content:JJLocalizedString(@"手机号码格式不正确", nil)];
        
        return;
        
    }
    
    self.clickV = YES;
    
    //!< 调用代理方法
    if ([self.delegate respondsToSelector:@selector(findPwdViewGetVerifyCodeBtnClick:)])
    {
        self.phoneNumber = self.phoneTF.text;
        
        [self.delegate findPwdViewGetVerifyCodeBtnClick:self];
    }
    
    
    
}

/**
 *  点击下一步按钮
 */
- (IBAction)nextBtnClick:(id)sender {
    
 
    
    if (![self phoneNumberValidate:self.phoneTF.text]) {
        
        //!< 手机号码不正确
        [AlertTool showAlertWithTarget:(UIViewController*)self.delegate title:nil content:JJLocalizedString(@"手机号码格式不正确", nil)];
        
        return;
        
    }
    
    //!< 判断是否点击过获取验证吗按钮
    if (!self.clickV)
    {
         [AlertTool showAlertWithTarget:(UIViewController*)self.delegate title:nil content:JJLocalizedString(@"未获取验证码", nil)];
          return;
    }
    
    if ([self.delegate respondsToSelector:@selector(findPwdViewNextBtnClick:)])
    {
         self.phoneNumber = self.phoneTF.text;
        self.verificationCode = self.verifyTF.text;
        [self.delegate findPwdViewNextBtnClick:self];
    }
    
}
/**
 *  判断手机号码是否有效
 */
- (BOOL)phoneNumberValidate:(NSString *)phoneNumber
{
    return [XMVerifyManager verifyAreaCode:phoneNumber];
    
    
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
//            [label removeFromSuperview];
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


- (void)stopTimer
{
    
    
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
 用户修改密码的时候，提供的接口
 
 @param phoneNumber 用户电话号码
 */
- (void)setExistPhoneNumber:(NSString *)phoneNumber
{

    //!< 设置用户电话号码，关闭交互功能
    self.phoneTF.text = phoneNumber;
    
    self.phoneTF.userInteractionEnabled = NO;
    
    self.phoneNumber = self.phoneTF.text;

}

@end
