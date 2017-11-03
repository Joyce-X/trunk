//
//  XMEnterPwd.m
//  kuruibao
//
//  Created by x on 17/8/2.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMEnterPwd.h"
#import "XMVerifyManager.h"
#import "XMCustomTextField.h"
#import <Social/Social.h>
@interface XMEnterPwd ()

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;
@property (weak, nonatomic) IBOutlet XMCustomTextField *firstPwdTF;

@property (weak, nonatomic) IBOutlet XMCustomTextField *secondPwdTF;

@property (weak, nonatomic) IBOutlet UIButton *confirmBtn;

@property (copy, nonatomic,readwrite) NSString *password1;


@property (copy, nonatomic,readwrite) NSString *password2;@end


@implementation XMEnterPwd

- (IBAction)confirmClick:(id)sender {
    
    if ( [self.delegate respondsToSelector:@selector(EnterPwdClickConfirmBtn:)])
    {
        self.password1 = self.firstPwdTF.text;
        
        self.password2 = self.secondPwdTF.text;
        
        [self.delegate EnterPwdClickConfirmBtn:self];
    }
    
//    SLComposeViewController *vc = [SLComposeViewController composeViewControllerForServiceType:@""];
    
}
 
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextFieldTextDidChangeNotification object:nil];
    
    self.firstBtn.userInteractionEnabled = NO;
    
    self.secondBtn.userInteractionEnabled = NO;
    
    [self.confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.bottom.equalTo(self).offset(FITHEIGHT(58));
        
        make.centerX.equalTo(self);
        
        make.size.equalTo(CGSizeMake(FITWIDTH(196), FITHEIGHT(54)));
        
    }];
    
    
    self.firstPwdTF.placeholder = JJLocalizedString(@"密码为6-20位", nil);
    
    self.secondPwdTF.placeholder = JJLocalizedString(@"密码为6-20位", nil);
   
}
 

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    
    
}

#pragma mark ------- 响应通知的方法
- (void)textFieldTextChange:(NSNotification *)noti
{
    if (noti.object == self.firstPwdTF)
    {
        
        self.firstBtn.selected = self.firstPwdTF.text.length >= minimumPWDLength;
        
    }else if (noti.object == self.secondPwdTF)
    {
        
        self.secondBtn.selected = self.secondPwdTF.text.length >= minimumPWDLength;
        
    }
    
    if ([XMVerifyManager verifyPasswordValid:self.firstPwdTF.text] && [XMVerifyManager verifyPasswordValid:self.secondPwdTF.text])
    {
        self.confirmBtn.enabled = YES;
    }else
    {
        self.confirmBtn.enabled = NO;
    }
     
    
    
    
    
}
@end
