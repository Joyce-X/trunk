//
//  XMDashPalManager.m
//  kuruibao
//
//  Created by x on 17/8/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 一个全局的单例，控制全局变量
 
 ************************************************************************************************/

#import "XMDashPalManager.h"

static XMDashPalManager *manager = nil;

@implementation XMDashPalManager


+ (instancetype)shareManager
{
    if (manager == nil)
    {
        manager = [[self alloc]init];
        
        return manager;
        
    }else
    {
    
        return manager;
    
    }



}



@end
