//
//  XMTrackAverageStateModel.m
//  kuruibao
//
//  Created by x on 16/11/29.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//
/**********************************************************
 class description:一天内行程的平均数据
 
 **********************************************************/
#import "XMTrackAverageStateModel.h"


#define oilPrice 5.94

@implementation XMTrackAverageStateModel

//!< 转模型的时候，要对单位进行处理

- (instancetype)initWithDictionary:(NSDictionary *)dic
{

    self = [super init];
    
    if (self)
    {
        
        //!< 行驶距离
        NSString *licheng = dic[@"totallicheng"];
        
        self.totallicheng = [XMUnitConvertManager convertKmToMile:licheng.floatValue];
        
        //!< 喷油量
        NSString * penyou = dic[@"totalpenyou"];
        
        self.totalpenyou = [XMUnitConvertManager convertLitreToGallon:penyou.floatValue];
        
      
        
        NSString *time = dic[@"totalxingshitime"];
        
        int hour = time.intValue / 3600;
        
        int minute = (time.intValue % 3600) / 60 ;
        
        int second = time.intValue%60;
        
//        if (self.totallicheng.length == 0)
//        {
//            self.totallicheng = @"0";
//        }
//        
//        if (self.totalpenyou.length == 0)
//        {
//            self.totalpenyou = @"0";
//        }
        
//        self.totalMoney = [NSString stringWithFormat:@"%.1fRMB",self.totalpenyou.floatValue * oilPrice];
        
//        self.totallicheng = [NSString stringWithFormat:@"%.1fkm",self.totallicheng.floatValue];
        
//        self.totalpenyou = [NSString stringWithFormat:@"%.1fL",self.totalpenyou.floatValue];
        
 
        
//        if (hour == 0)
//        {
//            if (minute == 0)
//            {
//                self.totalxingshitime = [NSString stringWithFormat:@"%ds",second];
//                
//            }else
//            {
//                self.totalxingshitime = [NSString stringWithFormat:@"%02d:%02d",minute,second];
//            
//            }
//            
//        }else if (minute == 0)
//        {
//            //!< 分为0
//            self.totalxingshitime = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
//        
//        }else if (second == 0)
//        {
//            //!< 秒为0
//            self.totalxingshitime = [NSString stringWithFormat:@"%d:%d:",hour,minute];
//        
//        }else
        {
        
            //!< 时分秒都不为0
            self.totalxingshitime = [NSString stringWithFormat:@"%02d:%02d:%02d",hour,minute,second];
        
        }
        
        
        
    }

    return self;

}
@end
