//
//  XMMike.h
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//


/***********************************************************************************************
 
 说明：1 这是一个单例，为了方便Mike在美国进行测试，专门构造一个隐蔽模块，方便Mike在美国对登录注册的一次限制参数自行进行测试，测试完毕之后
      在最后阶段对这个模块进行删除
 
      2.每间隔10秒上传打印的日志信息，方便查看用户在APP内进行的操作
 
      3. 完成模块之后，对此模块进行测试，必须确保此模块的安全，不能引起APP崩溃
 
 ************************************************************************************************/


/***********************************************************************************************
 
 分析：1 必须是单例，随时上传打印的日志信息
      2 属性1：存放日志信息的数组， 属性2 标志是否需要开启中国手机号码验证的标志位。 属性3：一个integer类型属性，设置限定美国手机号码长度
        属性4，bool类型，标志是否开启美国区域码验证
 
 
 ************************************************************************************************/
#import <Foundation/Foundation.h>

@interface XMMike : NSObject

/**
 构造Mike单例

 @return 返回Mike单例
 */
+ (instancetype) shareMike;

/**
 打印的日志，传至服务器，方便我在网站看用户在APP内进行的操作，和后期查看测试信息，提供两个隐蔽接口来查看，一个在登录界面长按logo 6秒出现
    另外一个在“我的界面长按6秒出现”
 */
@property (strong, nonatomic) NSMutableArray <NSString *> *logMsgs;

/**
 标志是否开启对中国手机号码验证的的接口，默认为YES  设置为NO则不再对中国手机号码进行验证
 */
@property (assign, nonatomic) BOOL verifyChinaPhoneNumber;


/**
 设置美国手机号码长度，默认为10
 */
@property (assign, nonatomic) NSInteger americaPhoneNumberLength;

/**
 是否对美国的手机号码的区域码（前三位）进行验证  默认为YES  设置为NO，将不再对区域码进行验证
 */
@property (assign, nonatomic) BOOL verifyAmericaAreaCode;

/**
 添加日志
 
 @param msg 需要打印的信息
 */
+ (void) addLogs:(NSString *)msg;

  




@end
