//
//  AlertTool.h
//  delete
//
//  Created by X on 2017/7/18.
//  Copyright © 2017年 ~X~. All rights reserved.
//

//快捷展示alert的工具类
#import <UIKit/UIKit.h>

@interface AlertTool : NSObject

/*
 * target: 要展示alert的控制器
 * title: alert标题，
 * content :alert内容
 *
 */
+ (void)showAlertWithTarget:(UIViewController*)target title:(NSString *)title content:(NSString *)content;

@end
