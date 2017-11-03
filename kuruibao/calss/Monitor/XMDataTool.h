//
//  XMDataTool.h
//  kuruibao
//
//  Created by x on 17/7/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

/***********************************************************************************************
 
 存储和取出userdefault相关数据
 
 ************************************************************************************************/

#import <Foundation/Foundation.h>

@interface XMDataTool : NSObject


/**
 取出上一次检测结果

 @return score
 */
+ (NSInteger)getLastCheckScore;


/**
 保存当前体检结果
 */
+ (void)saveCurrentScore:(NSInteger)score;



/**
 从目标数组分离出带有特定前缀的数组，仅可用于主界面点击具体项详细内容时候

 @param prefix 指定前缀
 @param sourceArr 指定数组
 @return 新数组
 */
+ (NSArray *)separateArrayWithString:(NSString *)prefix from:(NSArray *)sourceArr;



/**
 根据请求的结果计算得分

 @param array 请求结果
 @return 分数
 */
+ (int)calculateScoreWithArray:(NSArray <NSString *>*)array;

@end
