//
//  XMActiveManager.m
//  kuruibao
//
//  Created by x on 17/9/19.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMActiveManager.h"

#import "AFNetworking.h"

#import "XMUser.h"

@implementation XMActiveManager


+ (void)activeCarWithQicheid:(NSString *)qicheid
{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    session.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    session.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    XMUser *user = [XMUser user];
    
    if (qicheid.integerValue == user.qicheid.integerValue)
    {
        XMLOG(@"---------用户默认汽车id和当前激活的汽车id一致，准备激活默认车辆---------");
        
        [XMMike addLogs:@"---------用户默认汽车id和当前激活的汽车id一致，准备激活默认车辆---------"];

    }else
    {
    
        XMLOG(@"---------准备激活非默认车辆---------");
        [XMMike addLogs:@"---------准备激活非默认车辆---------"];

    
    }
    
        //!< 在线激活 发送101指令
        NSString *urlStr = [mainAddress stringByAppendingFormat:@"Active&Userid=%lu&Qicheid=%@",user.userid,qicheid];
        
        [session GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            
            int statusCode = [[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding] intValue];
            
            switch (statusCode)
            {
                case 0:
                    
                    XMLOG(@"激活失败，网络错误");
                    
                    [XMMike addLogs:@"激活失败，网络错误"];

                    
                    break;
                    
                case -1:
                    
                    XMLOG(@"激活失败，终端不在线");
                    
                    [XMMike addLogs:@"激活失败，终端不在线"];

                    break;
                    
                    
                    
                default:
                    
                    //!< 激活成功，返回终端编号
                    XMLOG(@"激活成功");
                    
                    [XMMike addLogs:@"激活成功"];

                    
                    //!< 设备激活成功之后，需要判定当前车辆是否为默认车辆，如果是默认车辆的话需要更新全局数据
                    if (qicheid.integerValue == user.qicheid.integerValue)
                    {
                        XMLOG(@"---------用户默认汽车id和当前激活的汽车id一致，激活成功，准备更新全局数据---------");
                        
                        [XMMike addLogs:@"---------用户默认汽车id和当前激活的汽车id一致，激活成功，准备更新全局数据---------"];

                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:kDashPalMonitorVCShouldUpdateDefaultCarInfoNotification object:nil];
                    }
                    
                    break;
            }
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            XMLOG(@"激活失败，网络错误");
            
            [XMMike addLogs:@"激活失败，网络错误"];

            
        }];
        
   
    

}


- (void)dealloc
{
    
    XMLOG(@"---------ActiveManager dealloc---------");
    
    [XMMike addLogs:@"---------ActiveManager dealloc---------"];

    
}
@end
