//
//  XMActiveManager.h
//  kuruibao
//
//  Created by x on 17/9/19.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  专门负责激活车辆的类
 */
@interface XMActiveManager : NSObject

/**
 激活车辆

 @param qicheid 汽车id
 */
+ (void)activeCarWithQicheid:(NSString *)qicheid;

@end
