//
//  XMLanguageManager.h
//  Timezone_delete
//
//  Created by x on 17/10/16.
//  Copyright © 2017年 cesiumai. All rights reserved.
//

#import <Foundation/Foundation.h>

#define JJLocalizedString(key, comment) \
[[XMLanguageManager shareInstance] getTextWithKey:(key)]

@interface XMLanguageManager : NSObject

/**
 当前语言环境
 */
@property (copy, nonatomic) NSString *currentLanguage;

/**
 用户语言是否和系统语言一致
 */
@property (assign, nonatomic) BOOL equalSystem;

+ (instancetype)shareInstance;

- (NSString *)getTextWithKey:(NSString *)key;

@end
