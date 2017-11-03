//
//  XMLanguageManager.m
//  Timezone_delete
//
//  Created by x on 17/10/16.
//  Copyright © 2017年 cesiumai. All rights reserved.
//

#import "XMLanguageManager.h"

static XMLanguageManager *instance = nil;

static NSBundle *bundle = nil;

@interface XMLanguageManager ()



@end


@implementation XMLanguageManager

+ (instancetype)shareInstance
{
    if (instance == nil)
    {
        instance = [[self alloc]init];
    }
    
    return instance;

}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //!< 设置当前语言变量
        self.currentLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:@"userLanguage"];
        
        //!< 获取系统语言
        NSArray *langs = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
        
        NSString *system = langs.firstObject;
        
        if ([system containsString:@"en"])
        {
            system = @"en";
            
        }else if ([system containsString:@"zh-Hans"])
        {
            system = @"zh-Hans";
            
        }else
        {
            //!< 注意，系统语言可能不是中文也不是英文，是其他的与语种
            _equalSystem = YES; //!< 其他语种就使用系统默认的语言
        
        }
        
        //!< 如果没有设置用户语言，就设置和系统语言一致
        if (_currentLanguage.length == 0)
        {
            _currentLanguage = system;
        }
       
        _equalSystem = [system isEqualToString:_currentLanguage];
        
        //!< 如果当前语言个系统语言不一致的话，给bundle赋值，用bundle来加载相应的语言
        if (!_equalSystem)
        {
            
             NSString *path = [[NSBundle mainBundle] pathForResource:_currentLanguage ofType:@"lproj"];
            
            bundle = [NSBundle bundleWithPath:path];
            
        }
        
        if([_currentLanguage isEqualToString:@"DashPal"])
        {
            _equalSystem = YES;
            
        }
        
    }
    return self;
}


- (NSString *)getTextWithKey:(NSString *)key
{

    NSLog(@"---------Joyce***---------");
    
    if (_equalSystem)
    {
        //!< 当前系统语言环境和用户设置的语言环境是一致的直接返回系统宏
        return NSLocalizedString(key, nil);  
        
    }else
    {
//        //!< 当前系统设置的语言和用户设置的语言是不一致的，就需要自己进行处理了，可能是中文，也可能是英文
//        if (bundle == nil)
//        {
//            //!< 没有找到相对应的资源文件，也就是说系统的语言，不是英文或者是中文
//            return JJLocalizedString(key, nil);
//            
//        }
//    
        
        return [bundle localizedStringForKey:key value:nil table:@"DashPal"];
        
    }
  

}


//!< 设置用户语言
- (void)setCurrentLanguage:(NSString *)currentLanguage
{

    if (currentLanguage.length == 0)
    {
        return;
    }
    
    _currentLanguage = currentLanguage;
    
//    NSArray *langs = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"];
//    
//    NSString *system = langs.firstObject;
//    
//    if ([system containsString:@"en"])
//    {
//        system = @"en";
//    }
//    
//    if ([system containsString:@"zh-Hans"])
//    {
//        system = @"zh-Hans";
//    }
//    
//    if ([system isEqualToString:currentLanguage])
//    {
//        self.equalSystem = YES;
//        
//    }else
//    {
//        self.equalSystem = NO;
//        
//    }
    
    //!< 设置语言只有三种情况，1 中文，2 英文 3 跟随系统
    if([currentLanguage isEqualToString:@"en"] || [currentLanguage isEqualToString:@"zh-Hans"] )
    {
        //!< 设置语言为中文或者英文
        NSString *path = [[NSBundle mainBundle] pathForResource:_currentLanguage ofType:@"lproj"];
        
        bundle = [NSBundle bundleWithPath:path];
        
        self.equalSystem = NO;
    
    }else
    {
        //!< 在设置语言跟随系统
        self.equalSystem = YES;
        
    }
    
    //!< 保存用户设置的语言
    [[NSUserDefaults standardUserDefaults] setValue:currentLanguage forKey:@"userLanguage"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];


}



@end
