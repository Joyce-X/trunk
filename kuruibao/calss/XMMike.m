//
//  XMMike.m
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "AFNetworking.h"
#import "XMMike.h"

#import "XMUser.h"

@interface XMMike ()

/**
 每间隔10秒上传日志到服务器（最新的数据）
 */
@property (strong, nonatomic) AFHTTPSessionManager *session;

/**
 上一次上传到的位置标记，用来获取标记之后的数据上传到服务器
 */
@property (assign, nonatomic) NSInteger index;

/**
 定时上传数据到服务器
 */
@property (strong, nonatomic) NSTimer *timer;

@end

static XMMike *shareInstance = nil;

@implementation XMMike

+ (instancetype)shareMike
{

    if (shareInstance == nil)
    {
        shareInstance = [[self alloc] init];
        
    }

    return shareInstance;

}


- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        //!< 设置默认参数
        self.americaPhoneNumberLength = 10;
        
        self.verifyAmericaAreaCode = YES;
        
        self.verifyChinaPhoneNumber = YES;
        
        //马来西亚默认关闭
//        self.verifyAmericaAreaCode = NO;
        
        //马来西亚默认关闭
//        self.verifyChinaPhoneNumber = NO;
        
//        self.logMsgs = [NSMutableArray array];
//        
//        self.index = 0;
        
//        self.timer = [NSTimer timerWithTimeInterval:5 target:self selector:@selector(updateLogs:) userInfo:nil repeats:YES];
//        
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
        
    }
    
    return self;
}

/**
 上传日志到服务器
 */
- (void)updateLogs:(NSTimer *)timer
{
    //!< 在主线程中执行
    
    if(shareInstance.logMsgs.count < 5)return;
   
    //!< 拼接字符串
    
    if(shareInstance.logMsgs.count <= _index + 3)return;
    
    NSArray *arr = [shareInstance.logMsgs subarrayWithRange:NSMakeRange(_index, 3)];
    
    NSString *str = @"";
    
    for (NSString *log in arr)
    {
        str = [str stringByAppendingString:log];
        
    }
    
    _index += 3;
    
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    
    //!< 转码
    str = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSString *urlStr = [mainAddress stringByAppendingFormat:@"submitfeedback&userid=34&phone=17688827110&nickname=Joyce&feedback=%@",str];
    
    [shareInstance.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        XMLOG(@"---------%@---------",[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        XMLOG(@"---------back失败---------");
        
    }];
    
    
    
}

#pragma mark ------- lazy

- (AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        
        _session.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        _session.requestSerializer.timeoutInterval = 6;
    }
 
    return _session;
}

/**
 添加日志
 
 @param msg 需要打印的信息
 */
+ (void) addLogs:(NSString *)msg
{
//    [[XMMike shareMike].logMsgs addObject:msg];
    
 
}



 
@end
