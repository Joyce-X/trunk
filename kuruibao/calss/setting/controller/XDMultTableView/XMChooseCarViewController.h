//
//  ViewController.h
//  TestDemo
//
//  Created by x on 16/6/21.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMCarModel.h"
@protocol XMChooseCarViewControllerDelegate <NSObject>

- (void)chooseVCDidsSelectCar:(XMCarModel *)car;

@end

@interface XMChooseCarViewController : UIViewController


@property (nonatomic,weak)id delegate;


@end

