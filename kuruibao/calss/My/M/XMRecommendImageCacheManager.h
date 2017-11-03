//
//  XMRecommendImageCacheManager.h
//  kuruibao
//
//  Created by X on 2017/9/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//


/**
 *  此类负责管理推荐数据的图片缓存工作，在没有网络的时候，显示缓存的图片
 */

#import <Foundation/Foundation.h>

@interface XMRecommendImageCacheManager : NSObject


/**
 *  直接提供两个类方法就可以，不用实现实例方法
 */


/**
 更新推荐信息的缓存图片，内部会进行判定，地址没有变换不会进行更新

 @param recommendInfo 推荐数据
 */
+ (void) updateRecommendImageCache:(NSArray *)recommendInfo;


/**
 没有网络的时候，加载缓存的图片数据

 @return 图片数组，数组长度为3
 */
+ (NSArray <UIImage *>*)recommendImageCache;

@end
