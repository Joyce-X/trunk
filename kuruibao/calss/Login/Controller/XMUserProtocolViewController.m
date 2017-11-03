
//
//  XMUserProtocolViewController.m
//  KuRuiBao
//
//  Created by x on 16/6/23.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 这个类用来展示用户协议，声明相关责任
 
 
 ************************************************************************************************/

#import "XMUserProtocolViewController.h"
 
@interface XMUserProtocolViewController ()<UIWebViewDelegate>

@end

@implementation XMUserProtocolViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //-- 初始化
    [self setupWebView];
   
   
}


- (void)setupWebView
{
     self.view.backgroundColor = [UIColor whiteColor];

    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"用户使用协议", nil);
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, backImageH , mainSize.width, mainSize.height - backImageH )];
    web.delegate = self;
    [self.view addSubview:web];
  
     NSString *protocolPath = [[NSBundle mainBundle] pathForResource:@"protocol.html" ofType:nil];
    NSURL *url = [NSURL fileURLWithPath:protocolPath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [web loadRequest:request];
    
    
}



- (void)backArrowClcik
{
    [self dismissViewControllerAnimated:YES completion:nil];

}


#pragma mark --- UIWebViewDelegate

- (void)webViewDidStartLoad:(UIWebView *)webView
{
     [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;


}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
     [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

}
 
@end
