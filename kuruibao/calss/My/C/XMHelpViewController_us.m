//
//  XMHelpViewController_us.m
//  kuruibao
//
//  Created by x on 17/8/8.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMHelpViewController_us.h"
#import "XMOBDPluginViewController.h"
#import "XMSet_helpViewController.h"
@interface XMHelpViewController_us ()

@end

@implementation XMHelpViewController_us

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupInit];

}

- (void)setupInit{
    
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"帮助", nil);
}


/**
 *  点击安装位置
 */
- (IBAction)clickLocation:(id)sender {
    
//    XMOBDPluginViewController *vc = [XMOBDPluginViewController new];
 
    
    XMSet_helpViewController *vc = [XMSet_helpViewController new];
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

/**
 *  暂时未确定功能
 */
- (IBAction)clickUse:(id)sender {
    
//    [MBProgressHUD showError:@"暂时未确定功能"];
    
}

@end
