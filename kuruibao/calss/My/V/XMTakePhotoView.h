//
//  XMTakePhotoView.h
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^chooseBlock) (int index);

@interface XMTakePhotoView : UIView

/**
 完成选择后的回调  index: 1 相册，2 拍照，3 取消
 */
@property (copy, nonatomic)chooseBlock callBack;


@end
