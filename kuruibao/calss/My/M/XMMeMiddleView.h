//
//  XMMeMiddleView.h
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XMMeMiddleView;

@protocol XMMeMiddleViewDelegate <NSObject>

/**
 点击XMMeMiddleView的更多按钮

 @param middleView trigger
 */
- (void)middleViewDidClickMore:(XMMeMiddleView *)middleView;

/**
 点击第几张推荐的图片

 @param middleView trigger
 @param index 图片下标
 */
- (void)middleViewDidClicImage:(XMMeMiddleView *)middleView atIndex:(NSInteger)index;


@end

@interface XMMeMiddleView : UIView


@property (weak, nonatomic) id<XMMeMiddleViewDelegate> delegate;

/**
 推荐数据
 */
@property (strong, nonatomic) NSArray *recommandArr;



/**
 提供没有网络的时候设置缓存图片的接口
 */
@property (nonatomic,strong)NSArray <UIImage *>* disconnectImages;

/**
 *  更新文字内容
 */
- (void)shouldUpdateText;
@end
