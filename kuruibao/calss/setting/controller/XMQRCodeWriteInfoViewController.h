//
//  XMQRCodeWriteInfoViewController.h
//  kuruibao
//
//  Created by x on 16/10/5.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMDetailRootViewController.h"

@protocol XMQRCodeWriteInfoViewControllerDelegate <NSObject>

/**
 手动填写完场

 @param result 输入结果
 */
- (void)finishWrite:(NSString *)result;

@end

@interface XMQRCodeWriteInfoViewController : XMDetailRootViewController

@property (weak, nonatomic) id<XMQRCodeWriteInfoViewControllerDelegate> delegate;

@end
