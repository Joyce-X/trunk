//
//  XMVersionChecker.m
//  kuruibao
//
//  Created by x on 17/9/6.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//
/**
 *  处理版本检测逻辑
 */
#import "XMVersionChecker.h"
#import "AFNetworking.h"
#import "XMUser.h"

#define imageKey @"imageKey"  //图片数据
#define imageUrl @"imageUrl"  //图片地址

#define storageAddress [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject stringByAppendingString:@"/launchImage.data"]

@interface XMVersionChecker ()

@property (strong, nonatomic) AFHTTPSessionManager *session;

@property (weak, nonatomic) id<XMVersionCheckerDelegate> delegate;

@end


@implementation XMVersionChecker

- (instancetype)initWithDelegate:(id<XMVersionCheckerDelegate>)delegate
{
    
    self = [super init];
    
    if (self)
    {
        self.delegate = delegate;
        
        self.hasNewVersion = NO;
        
        self.pwdError = NO;
        
        [self checkUserState];//检测密码变化
        
    }
    
    return self;


}


#pragma mark ------- lazy
- (AFHTTPSessionManager *)session
{
    if (!_session)
    {
        _session = [AFHTTPSessionManager manager];
        
        _session.requestSerializer = [AFHTTPRequestSerializer serializer];
        
        _session.responseSerializer = [AFHTTPResponseSerializer serializer];
    }

    return _session;
}

/**
 *  检测版本
 */
- (void)checkVersion
{
    
    //!< 服务器获取版本号 需要等待一段时间在请求，不要和广告业冲突
    
    NSString *urlStr = [mainAddress stringByAppendingString:@"versionget&type=ios"];
    
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self processResult:responseObject];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       
        //!< 请求失败，不执行任何操作
        XMLOG(@"---------请求版本信息失败，网络原因---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------请求版本信息失败，网络原因---------"]];

        
    }];
    
    
   
    
         
//    [self processResult:data];
    
    
    //!< 检测是否有启动图片数据
//    [self checkLaunchImage];
    
}

- (void)processResult:(NSData *)data
{
    
    NSString *result = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    
    if (result.integerValue == 0 && result.length == 1)
    {
        XMLOG(@"---------请求版本信息，没有新数据---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------请求版本信息，没有新数据---------"]];

        
    }else if(result.integerValue == -1)
    {
        
        XMLOG(@"---------请求版本信息，参数或网络错误---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------请求版本信息，参数或网络错误---------"]];

        
    }else
    {
        XMLOG(@"---------新版本数据:%@---------",result);
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------新版本数据:%@---------",result]];

    
        NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];

        NSDictionary *dic = arr.firstObject;
        
//        //!< 获取版本信息，与本地版本进行比对
        float versionServer = [dic[@"version"] floatValue];
//
        
//         float versionServer = result.floatValue;//!< 打开上边的注释，删除这句测试代码
        
         NSDictionary *infoDic = [NSBundle mainBundle].infoDictionary;
        
         float currentVersion = [infoDic[@"CFBundleShortVersionString"] floatValue];
        
        if (versionServer > currentVersion)
        {
            //!< 服务器版本大于本地版本，通知代理更新版本
            if (self.delegate && [self.delegate respondsToSelector:@selector(checkerDidFinishVersionChecker:)])
            {
                self.hasNewVersion = YES;
                
                [self.delegate checkerDidFinishVersionChecker:self];
            }
            
        }else
        {
            //!< 没有新版本
            XMLOG(@"---------Server:%f,Current:%f---------",versionServer,currentVersion);
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------Server:%f,Current:%f---------",versionServer,currentVersion]];

            
            XMLOG(@"---------没有新版本---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------没有新版本---------"]];

        
        
        }
        
        
    }
    
    
}

/**
 *  检测是否有启动图片
 */
-(void)checkLaunchImage
{
   
    NSUserDefaults *df = [NSUserDefaults standardUserDefaults];
    
    NSString *urlStr = [mainAddress stringByAppendingString:@"bootadvert"];
    
    //!< 请求新数据
    [self.session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if (result.length > 20)
        {
            //!< 有数据
            NSArray *arr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            NSDictionary *dic = arr.firstObject;
            
            NSString *imageUrlAddress = dic[@"Url"];
//            
//            imageUrlAddress = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1504712371257&di=bb0527cd8047a1ad0e9850bcd404f995&imgtype=0&src=http%3A%2F%2F4493bz.1985t.com%2Fuploads%2Fallimg%2F160927%2F3-16092G02T3.jpg";//测试数据
            
            
            //!< 获取本地地址
            NSString *localAdd = [df objectForKey:imageUrl];
            
            if ([localAdd isEqualToString:imageUrlAddress])
            {
                //!< 没有新数据，不用更新
                XMLOG(@"---------请求成功，地址没有改变---------");
                
            }else
            {
                XMLOG(@"---------地址发生改变---------");
                
                
                //!< 有新数据，下载新数据
                [self.session GET:imageUrlAddress parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                    XMLOG(@"---------下载进度：%.2f---------",downloadProgress.completedUnitCount * 1.0/downloadProgress.totalUnitCount);
                   
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    XMLOG(@"---------广告业图片下载成功---------");
                    //!< 保存图片地址
                    [df  setObject:imageUrlAddress forKey:imageUrl];
                    
                    [df synchronize];
                    
                    if (![[NSFileManager defaultManager] fileExistsAtPath:storageAddress]) {
                        
                        [[NSFileManager defaultManager] createFileAtPath:storageAddress contents:nil attributes:nil];
                        
                    };
                    //!< 保存数据
                   BOOL res =  [responseObject writeToFile:storageAddress atomically:YES];
                
                    XMLOG(@"---------%@---------",storageAddress);
                    if (res)
                    {
                        XMLOG(@"---------写入成功---------");
                    }else
                    {
                    
                        XMLOG(@"---------写入失败---------");
                    }
                    
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    
                    XMLOG(@"---------广告业图片下载失败---------");
                    
                }];
            
            
            }
            
            
            
        }else
        {
            
            XMLOG(@"---------请求广告业数据失败，返回值错误---------");
        
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        //!< 请求失败，不加载任何数据
        XMLOG(@"---------请求广告业失败，网络原因---------");
        
    }];
    
    
    
    
    
    
    
    
    
}


+ (UIImage *)launchImageAddress{

    //!< 获取图片数据
    NSData *data = [NSData dataWithContentsOfFile:storageAddress];
    
    //!< 有数据就返回，么用数据就加载默认
    if (data)
    {
        return [UIImage imageWithData:data];
    }else
    {
        return nil;
    
    }
   

}




/**
 检测用户密码是否有修改
 */
- (void)checkUserState
{

 
//    
//    if ([AFNetworkReachabilityManager sharedManager].networkReachabilityStatus < 1)
//    {
//        
//        XMLOG(@"---------密码检测失败，网络未连接---------");
//        
//        return;
//    }
    
    
    XMUser *user = [XMUser user];
    
    NSMutableDictionary *para = [NSMutableDictionary dictionary];
    
    para[@"Mobil"] = user.mobil;
    
    para[@"Password"] = user.password;
    
    para[@"Source"] = @"G";
    
    [self.session POST:@"http://api.longseer.online/v2.ashx?key=43f32f4722e0991ae17403a549e1f244&method=Login" parameters:para progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *result = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
//        NSString *showStr;
        
        if ([result isEqualToString:@"0"])
        {
            XMLOG(@"---------用户名或密码错误---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------用户名或密码错误---------"]];

            
            //!< 密码错误的话，说明已经修改了密码
            //!< 通知代理跳转到登录界面
            if(self.delegate && [self.delegate respondsToSelector:@selector(checkerFinishCheckUserStateJumpToLoginVC:)])
            {
                //!< 删除账户信息
                BOOL res = [[NSFileManager defaultManager] removeItemAtPath:ACCOUNTPATH error:nil];
                
                [XMUser clearAccount];
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lastScore_US"];
                
                [[NSUserDefaults standardUserDefaults] synchronize];
            
                self.pwdError  = YES;
            
                [self.delegate checkerFinishCheckUserStateJumpToLoginVC:self];
                
               
                
            }
            
            
            
        }else if ([result isEqualToString:@"-2"])
        {
            XMLOG(@"---------用户不存在---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------用户不存在---------"]];

            
        }else if([result isEqualToString:@"-1"])
        {
            XMLOG(@"---------Network  busy---------");
            
            [XMMike addLogs:[NSString stringWithFormat:@"---------Network  busy---------"]];

        }else
        {
            //!< 登陆成功，字典转模型保存用户信息
            //!< 保存用户信息
            NSError *error = nil;
            
            id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:&error];
            
            if([obj isKindOfClass:[NSArray class]])
            {
                NSDictionary *dic = [(NSArray *)obj firstObject];
                
                XMUser *user_new = [XMUser userWithDictionary:dic];
                
                //!< 判断密码是否星等
                if ([user.password isEqualToString:user_new.password])
                {
                    //!< 密码相等，不执行操作
                    XMLOG(@"---------密码没有发省变化---------");
                    
                    [XMMike addLogs:[NSString stringWithFormat:@"---------密码没有发省变化---------"]];

                    
                    //!< 密码没有发生变化的时候，去检测新版本
                      [self checkVersion];
                    
                }else
                {
                    //!< 密码发生变化 不回来到这里
                    
                }
                
                
                
            }else
            {
                
                
                XMLOG(@"密码检测失败，服务器返回参数错误");
                
                [XMMike addLogs:[NSString stringWithFormat:@"密码检测失败，服务器返回参数错误"]];

                
                return;
            }
            
            
        
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        XMLOG(@"---------检测密码失败，网络连接超时---------");
        
        [XMMike addLogs:[NSString stringWithFormat:@"---------检测密码失败，网络连接超时---------"]];

        
    }];

}




















@end
