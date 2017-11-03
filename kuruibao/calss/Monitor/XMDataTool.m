//
//  XMDataTool.m
//  kuruibao
//
//  Created by x on 17/7/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMDataTool.h"


#define scoreKey  @"lastScore_US"

@implementation XMDataTool
/**
 取出上一次检测结果
 
 @return score
 */
+ (NSInteger)getLastCheckScore
{

    NSInteger score = [[NSUserDefaults standardUserDefaults] integerForKey:scoreKey];
    
    
    return score;

}


/**
 保存当前体检结果
 */
+ (void)saveCurrentScore:(NSInteger)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:scoreKey];
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
  
}

+ (NSArray *)separateArrayWithString:(NSString *)prefix from:(NSArray *)sourceArr
{
    NSMutableArray *tem = [NSMutableArray array];
    
    for (NSDictionary *dic in sourceArr)
    {
        NSString *code = dic[@"code"];
        
        if ([code hasPrefix:prefix])
        {
            [tem addObject:dic];
        }
        
    }

    return [tem copy];

}

/**
 根据请求的结果计算得分
 
 @param array 请求结果
 @return 分数
 */
+ (int)calculateScoreWithArray:(NSArray <NSString *>*)array
{
    /*
     3.1 发动机系统,1-3 项,每项扣 3 分,4-6 项,每项扣 5 分,7 项以后,每项扣 8 分,扣到零分。
     
     3.2 电子刹车系统,1-2 项,每项扣 10 分,3-6 项,每项扣 7 分,7 项以后,每项扣 5 分,扣到零分。
     
     3.3 车身控制系统,1-5 项,每项扣 5 分,6-9 项,每项扣 3 分,10 项以后,每项扣 2 分,扣到零分。
     
     3.4 其他,1-3 项,每项扣 3 分,4-6 项,每项扣 5 分,7 项以后,每项扣 8 分,扣到零分。
     
     3.5 等级区分,100 分,颜色 1,五颗星;85-99 分,颜色 2,四颗星;75-84,颜色 3,三颗星;60-74,颜色 4,两颗星;60 分一下,颜 色 5,一颗星
     
     */
    
    //!< 数量计算
    int P = 0,B = 0,C = 0,U = 0;
    
    for (NSString *str in array)
    {
        if ([str hasPrefix:@"P"])
        {
            P++;
            
        }else if ([str hasPrefix:@"B"])
        {
            B++;
            
        }else if ([str hasPrefix:@"C"])
        {
            C++;
            
        }else if([str hasPrefix:@"U"])
        {
           U++;
        }
        
     }
    
    //!< 分数计算
     int scoreP = 0,scoreB = 0,scoreC = 0,scoreU = 0;
    
    //!< scoreP 计算 发动机系统,1-3 项,每项扣 3 分,4-6 项,每项扣 5 分,7 项以后,每项扣 8 分,扣到零分。
    if (P <= 3 )
    {
        //!< 1-3 项,每项扣 3 分
        scoreP = 3 * P;
    
    }else if (P <= 6 )
    {
        //!< 4-6 项,每项扣 5 分
        scoreP = 3 * 3 + (5 * (P - 3));
        
    }else if (P > 6 )
    {
        //!< 7 项以后,每项扣 8 分
        scoreP = 3 * 3 + (5 * 3) + (8 * (P - 6));
        
    }
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< scoreB 计算 电子刹车系统,1-2 项,每项扣 10 分,3-6 项,每项扣 7 分,7 项以后,每项扣 5 分,扣到零分。
    if (B <= 2 )
    {
        scoreB = 10 * B;
        
    }else if (B <= 6 )
    {
      
        scoreB = 10 * 2 + (7 * (B - 2));
        
        
    }else if (B > 6 )
    {
       
        scoreB = 10 * 2 + (7 * 4) + (B - 6) * 5;
        
    }
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< scoreC 车身控制系统,1-5 项,每项扣 5 分,6-9 项,每项扣 3 分,10 项以后,每项扣 2 分,扣到零分
    if (C <= 5 )
    {
        scoreC = 5 * C;
        
    }else if (C <= 9 )
    {
        
        scoreC = 5 * 5 + (3 * (C - 5));
        
        
    }else if (C > 9 )
    {
        
        scoreC = 5 * 5 + 3 * 4 + 2 * (C - 9);
        
    }
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< scoreU 其他,1-3 项,每项扣 3 分,4-6 项,每项扣 5 分,7 项以后,每项扣 8 分,扣到零分。
    if (U <= 3 )
    {
        scoreU = 3 * U;
        
    }else if (U <= 6 )
    {
        
        scoreU = 3 * 3 + (5 * (U - 3));
        
        
    }else if (U > 6 )
    {
        
        scoreU = 3 * 3 + 5 * 3 + 8 * (U - 6);
        
    }
    
    
    int scoreResult  = 100 - (scoreP + scoreB + scoreC + scoreU);
    
    if (scoreResult < 0)
    {
        
        //!< 小于0分按照0分计算
        scoreResult = 0;
    }

    return scoreResult;

}



























@end
