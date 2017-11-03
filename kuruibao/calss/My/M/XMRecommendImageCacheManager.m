//
//  XMRecommendImageCacheManager.m
//  kuruibao
//
//  Created by X on 2017/9/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMRecommendImageCacheManager.h"

#import "SDImageCache.h"

#define recommendImageKey_01  @"recommendImageKey_01"

#define recommendImageKey_02  @"recommendImageKey_02"

#define recommendImageKey_03  @"recommendImageKey_03"


@implementation XMRecommendImageCacheManager

/**
 更新推荐信息的缓存图片，内部会进行判定，地址没有变换不会进行更新
 
 @param recommendInfo 推荐数据
 */
+ (void) updateRecommendImageCache:(NSArray *)recommendInfo
{

    if (recommendInfo.count != 3)
    {
        XMLOG(@"更新推荐图片缓存数据失败，失败原因，数组长度错误 %@",recommendInfo);
        
        return;

    }
    
    // 1 解析出三张图片的URL地址
    NSString *URL_01 = [recommendInfo.firstObject objectForKey:@"Url"];
    
    NSString *URL_02 = recommendInfo[1][@"Url"];
    
    NSString *URL_03 = recommendInfo[2][@"Url"];
    
    // 2 检测是否有对应的缓存，有则不执行操作，没有就进行缓存
    SDImageCache *cachaManager = [SDImageCache sharedImageCache];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];

    // image1
    [cachaManager diskImageExistsWithKey:URL_01 completion:^(BOOL isInCache) {
        
        
        if (isInCache)
        {
             
            [df setObject:URL_01 forKey:recommendImageKey_01];
            
            [df synchronize];
            

        }else
        {
        
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL_01]];
                
                UIImage *image = [UIImage imageWithData:data];
                
                
                //-- 删除旧数据
                [cachaManager removeImageForKey:[df objectForKey:recommendImageKey_01] fromDisk:YES withCompletion:nil];
                
                //-- 保存新数据
                [cachaManager storeImage:image forKey:URL_01 toDisk:YES completion:nil];
                
                [df setObject:URL_01 forKey:recommendImageKey_01];
                
                [df synchronize];
                
            });
        
        }
        
        
    }];
    
    // image2
    [cachaManager diskImageExistsWithKey:URL_02 completion:^(BOOL isInCache) {
        
        
        if (isInCache)
        {
            
            [df setObject:URL_02 forKey:recommendImageKey_02];
            
            [df synchronize];
            
        }else
        {
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL_02]];
                
                UIImage *image = [UIImage imageWithData:data];
                
                //-- 删除旧数据
                [cachaManager removeImageForKey:[df objectForKey:recommendImageKey_02] fromDisk:YES withCompletion:nil];
                
                [cachaManager storeImage:image forKey:URL_02 toDisk:YES completion:nil];
                
                [df setObject:URL_02 forKey:recommendImageKey_02];
                
                [df synchronize];
                
            });
            
        }
        
        
    }];

    
    // image3
    [cachaManager diskImageExistsWithKey:URL_03 completion:^(BOOL isInCache) {
        
        
        if (isInCache)
        {
            
            [df setObject:URL_03 forKey:recommendImageKey_03];
            
            [df synchronize];
            
        }else
        {
            
            
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:URL_03]];
                
                UIImage *image = [UIImage imageWithData:data];
                
                //-- 删除旧数据
                [cachaManager removeImageForKey:[df objectForKey:recommendImageKey_03] fromDisk:YES withCompletion:nil];
                
                [cachaManager storeImage:image forKey:URL_03 toDisk:YES completion:nil];
                
                [df setObject:URL_03 forKey:recommendImageKey_03];
                
                [df synchronize];
                
            });
            
        }
        
        
    }];


}


/**
 没有网络的时候，加载缓存的图片数据
 
 @return 图片数组，数组长度为3
 */
+ (NSArray <UIImage *>*)recommendImageCache
{

    SDImageCache *cache = [SDImageCache sharedImageCache];
    
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    UIImage *image_01 = [cache imageFromDiskCacheForKey:[df objectForKey:recommendImageKey_01]];
    
    UIImage *image_02 = [cache imageFromDiskCacheForKey:[df objectForKey:recommendImageKey_02]];

    UIImage *image_03 = [cache imageFromDiskCacheForKey:[df objectForKey:recommendImageKey_03]];


    if (image_01 == nil || image_02 == nil || image_03 == nil)
    {
        
        
        return nil;

    }

    return @[image_01,image_02,image_03];

}




@end
