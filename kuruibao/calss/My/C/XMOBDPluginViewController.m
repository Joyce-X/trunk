//
//  XMOBDPluginViewController.m
//  kuruibao
//
//  Created by x on 17/8/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMOBDPluginViewController.h"

@interface XMOBDPluginViewController ()

@end

@implementation XMOBDPluginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupInit];
}

- (void)setupInit{
    
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"安装位置", nil);
    
    //!< 显示内容
}

@end
