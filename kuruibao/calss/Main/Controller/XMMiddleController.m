//
//  XMMiddleController.m
//  kuruibao
//
//  Created by x on 17/8/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleController.h"

@interface XMMiddleController ()

@end

@implementation XMMiddleController

- (void)viewDidLoad
{
    [super viewDidLoad];

    //!< 完全忽略缓存
    [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];

}

 - (void)networkDisconnect
{
    
    //!< 有的地方不可以使用缓存，比如登录，主监控界面等
    [self.session.requestSerializer setCachePolicy:NSURLRequestReloadIgnoringCacheData];
    

}

@end
