//
//  XMWebViewController.m
//  kuruibao
//
//  Created by x on 17/8/22.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMWebViewController.h"

@interface XMWebViewController ()

@end

@implementation XMWebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
 
    [self setupInit];

}

- (void)setupInit
{
    
    self.navigationController.navigationBar.hidden = NO;
    
    UIWebView *webView = [[UIWebView alloc]initWithFrame:self.view.bounds];
    
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.toUrl]]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.hidden = YES;

}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    
    return UIStatusBarStyleDefault;

}

@end
