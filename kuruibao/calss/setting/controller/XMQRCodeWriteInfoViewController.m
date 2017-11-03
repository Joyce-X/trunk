//
//  XMQRCodeWriteInfoViewController.m
//  kuruibao
//
//  Created by x on 16/10/5.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMQRCodeWriteInfoViewController.h"

@interface XMQRCodeWriteInfoViewController ()
@property (nonatomic,weak)UITextField* imeiTF;
@property (nonatomic,weak)UIButton* saveBtn;
@end

@implementation XMQRCodeWriteInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self setupSubViews];
 }



- (void)setupSubViews
{
    self.showBackgroundImage = YES;
    
//    self.view.backgroundColor = XMGrayColor;
    
    self.showBackArrow = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"手动添加", nil);

    
    UIButton *saveBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateNormal];
    [saveBtn setBackgroundImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateHighlighted];
    CGFloat btn_w = 55;
    CGFloat btn_h = btn_w;
    CGFloat btn_x = mainSize.width - btn_w - 15;
    CGFloat btn_y = backImageH - btn_h * 0.5;
    saveBtn.frame = CGRectMake(btn_x, btn_y, btn_w, btn_h);
    [saveBtn addTarget:self action:@selector(saveBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:saveBtn];
    self.saveBtn = saveBtn;
    
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, backImageH, mainSize.width, mainSize.height - backImageH)];
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    [self.view addSubview:scrollView];
    
    UILabel *imeiLabel = [UILabel new];
    imeiLabel.text = JJLocalizedString(@"IMEI号码:", nil);
    imeiLabel.textAlignment = NSTextAlignmentCenter;
    imeiLabel.textColor = [UIColor whiteColor];
    imeiLabel.font = [UIFont systemFontOfSize:14];
    [scrollView addSubview:imeiLabel];
    [imeiLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(scrollView).offset(30);
        make.left.equalTo(scrollView).offset(30);
        make.size.equalTo(CGSizeMake(90, 25));
        
    }];
    
    UITextField * imeiTF = [UITextField new];
    imeiTF.placeholder = JJLocalizedString(@"手动输入", nil);
    imeiTF.borderStyle = UITextBorderStyleRoundedRect;
    imeiTF.font = [UIFont systemFontOfSize:13];
    [scrollView addSubview:imeiTF];
    self.imeiTF = imeiTF;
    [imeiTF mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerY.equalTo(imeiLabel);
        make.height.equalTo(imeiLabel);
        make.left.equalTo(imeiLabel.mas_right).offset(10);
        make.right.equalTo(self.view).offset(-20);
    }];
    
    
}

- (void)saveBtnDidClick
{
    
    if (_imeiTF.text.length != IMEILENGTH)
    {
        [MBProgressHUD showError:JJLocalizedString(@"请输入11位IMEI号码", nil)];
        return;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName: kCHEXIAOMISETTINGQRCODIDIDFINISHSCANNOTIFICATION object:self userInfo:@{@"info":_imeiTF.text}];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(finishWrite:)])
    {
    
        [self.delegate finishWrite:_imeiTF.text];
        
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

 - (void)viewWillAppear:(BOOL)animated
{

    [super viewWillAppear:animated];
    [self.view bringSubviewToFront:_saveBtn];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{

    [self.view endEditing:YES];

}
#pragma mark -- 监听通知的方法



@end
