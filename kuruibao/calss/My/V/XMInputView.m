//
//  XMInputView.m
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMInputView.h"

@interface XMInputView ()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UIButton *okBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@end

@implementation XMInputView

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        self.limitLength = 0;
        
    }
    return self;
}

-(void)awakeFromNib
{
    [super awakeFromNib];
    //!< 修改边框
    self.textView.layer.cornerRadius = 5;
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.layer.borderWidth = 1;
    
    //29 122 255
    //!< 修改按钮边框
    self.okBtn.layer.cornerRadius = 5;
    self.okBtn.layer.masksToBounds = YES;
    self.okBtn.layer.borderColor = XMColor(29, 122, 255).CGColor;
    self.okBtn.layer.borderWidth = 1;
    
    self.cancelBtn.layer.cornerRadius = 5;
    self.cancelBtn.layer.masksToBounds = YES;
    self.cancelBtn.layer.borderColor = XMGrayColor.CGColor;
    self.cancelBtn.layer.borderWidth = 1;
    
    [self.cancelBtn setTitle:JJLocalizedString(@"取消", nil) forState:UIControlStateNormal];
     [self.cancelBtn setTitle:JJLocalizedString(@"取消", nil) forState:UIControlStateHighlighted];
    
     [self.okBtn setTitle:JJLocalizedString(@"确定", nil) forState:UIControlStateNormal];
     [self.okBtn setTitle:JJLocalizedString(@"确定", nil) forState:UIControlStateHighlighted];
  
    //!< 设置默认字长限制
    if(self.limitLength == 0)
    {
        
        self.limitLength = 24;
        
    }
    
    
    //!< 监听textview的变换
    self.textView.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];

//    
    //!< 添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    
    [self addGestureRecognizer:tap];
    

}

/**
 *  响应手势
 */
- (void)tap
{
    
    //!< 不执行操作，拦截父视图的点击事件
    XMLOG(@"---------inputView tap gesturerecognizer---------");
    
    
    
}

- (IBAction)ClickBlank:(id)sender {
    
    XMLOG(@"---------点击空白处---------");
}

- (IBAction)okClick:(id)sender {
    
   
    //!< 判断当前位置
    if (self.superview.frame.origin.y == 0)
    {
        //!< 处于底部展示的状态
        [self.superview performSelector:@selector(tap)];
        
    }else
    {
       
        
        if (self.textView.text.length != 0) {
            
            self.result = self.textView.text;
            
            //!< 通过外部传进来tag值来区分是昵称还是心情
            
            if (self.delegate)
            {
                [self.delegate inputViewOKClick:self];
            }
           
        }
        
        //!< 处于正在编辑的状态
        [self.textView resignFirstResponder];
        
        [self.superview performSelector:@selector(hideToBottom)];


      
        
    }
    
    
   
    
}
- (IBAction)cancelClick:(id)sender {
    
    
    //!< 判断当前位置
    if (self.superview.frame.origin.y == 0)
    {
        //!< 处于底部展示的状态
        [self.superview performSelector:@selector(tap)];
        
    }else
    {
         [self.superview performSelector:@selector(hideToBottom)];
        //!< 处于正在编辑的状态
        [self.textView resignFirstResponder];
        
        
        
    }
    
    
//
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    XMLOG(@"---------%@\n%@---------",NSStringFromRange(range),text);
     XMLOG(@"---------%@---------",textView.text);
    //!< 如果一次性输入足够的长度，需要对长度进行判定
    if (textView.text.length + text.length > self.limitLength)
    {
        //!< 长度过长
        return NO;
    }
    
    
    if (range.length == 1 && text.length == 0)
    {
        //!< 删除操作
        return YES;
    }
    if (textView.text.length >= self.limitLength) {
        
        return NO;
        
    }else
    {
    
        return YES;
    }
    
   
    

}
- (void)textViewDidChange:(UITextView *)textView
{
    //!< 调整剩余文字的字数显示
    NSInteger length = self.textView.text.length;
    
    NSInteger left = self.limitLength - length;
    
    self.leftLabel.text = [NSString stringWithFormat:@"%lu",left];

}

/**
 *  提供给外部，让textview变成第一响应者
 */
- (void)toBecomeFirstResponder
{
    [self.textView becomeFirstResponder];
    
}

#pragma mark ------- setter

- (void)setLimitLength:(NSInteger)limitLength
{
    
    
    if (limitLength != 0)
    {
        //!< 不等于0 就显示限制字数
        self.leftLabel.text = [NSString stringWithFormat:@"%ld",limitLength];
        
    }else
    {
    
        //!< 等于0 的时候不限制长度
        
        limitLength = 100000;
    }

    _limitLength = limitLength;
}

- (void)setContent:(NSString *)content
{
    _content = content;
    
    //!< 处理等于0 的情况
    if (self.limitLength == 0)
    {
        return;
    }
    
     //!< 设置完成内容后，修改限制字长显示的内容
    
    //!< 判断长度
    if(content.length >= self.limitLength)
    {
        //!< 长度过长，截取限定长度的字符串，修改剩余为0
        self.textView.text = [content substringWithRange:NSMakeRange(0, self.limitLength)];
        
        self.leftLabel.text = @"0";
    
    
    }else
    {
        //!< 长度在设定范围内
         self.textView.text = content;
        
        self.leftLabel.text = [NSString stringWithFormat:@"%ld",self.limitLength - content.length];
        
    }


}

#pragma mark ------- 监听通知


- (void)keyboardWillHide:(NSNotification *)noti
{
    
    //!< 清空数据
    self.textView.text = nil;
    self.leftLabel.text = [NSString stringWithFormat:@"%lu",self.limitLength];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
   

}

- (void)setShowLeftLabel:(BOOL)showLeftLabel
{
    _showLeftLabel= showLeftLabel;
    
    self.leftLabel.hidden = !showLeftLabel;

}
@end
