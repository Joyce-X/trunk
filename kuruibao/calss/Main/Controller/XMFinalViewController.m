//
//  XMFinalViewController.m
//  kuruibao
//
//  Created by x on 17/9/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMFinalViewController.h"

@interface XMFinalViewController ()

@end

@implementation XMFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];//!< 优先加载缓存

}

- (void)networkResume
{
  
    [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];//!< 优先加载缓存

    
}

- (void)networkDisconnect
{
    [self.session.requestSerializer setCachePolicy:NSURLRequestReturnCacheDataElseLoad];//!< 优先加载缓存

}

@end
