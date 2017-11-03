//
//  XMChooseSexView.h
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XMChooseSexView : UIView

typedef void (^chooseBlock) (int index);

/**
 完成选择后的回调  index: 1 male，2 female，3 other
 */
@property (copy, nonatomic)chooseBlock callBack;

@end
