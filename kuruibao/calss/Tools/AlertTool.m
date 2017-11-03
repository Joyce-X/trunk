//
//  AlertTool.m
//  delete
//
//  Created by X on 2017/7/18.
//  Copyright © 2017年 ~X~. All rights reserved.
//




#import "AlertTool.h"


static UIAlertController *alert;

@implementation AlertTool

+(void)showAlertWithTarget:(UIViewController *)target title:(NSString *)title content:(NSString *)content
{

    alert = [UIAlertController alertControllerWithTitle:title message:content preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:JJLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [alert dismissViewControllerAnimated:YES completion:nil];
        
    }];
    
    [alert addAction:action];
    
    
    [target presentViewController:alert animated:YES completion:nil];
    
    
    
    


}

- (void)dealloc
{
    
    NSLog(@"Joyce");

}

@end
