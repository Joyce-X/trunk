//
//  JJGPSModel.m
//  kuruibao
//
//  Created by x on 17/7/24.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "JJGPSModel.h"


@implementation JJGPSModel

/**
 GPS事件类型 1:行程开始; 2:行程结束; 3:水平校准进行中; 4:水平校准完成; 5:方向校准进行中; 6:方向校准完成; 7:安装位置移动; 10:急刹车; 11:急加油; 12:快速变道; 13:弯道加速; 14:碰撞; 15:频繁变道; 16:烂路高速行驶; 17:急转弯; 18:翻车 19:异常震动; 20:车门异常; 21:胎压和手刹异常; 30:超速报警; 31:水温报警; 32:转速报警; 33:电压报警; 34:故障报警; 35:怠速报警; 38:拖吊报警
 */
- (GMSMarker *)getMarker
{
    
    NSString *title = nil;
    
    switch (self.eventtype)
    {
        case 1://!<行程开始
            
            title = JJLocalizedString(@"行程开始", nil);
            
            break;
        case 2://!<行程结束
            
            title = JJLocalizedString(@"行程结束", nil);
            
            break;
        case 3://!<水平校准进行中
            
            title = JJLocalizedString(@"水平校准进行中", nil);
            
            break;
        case 4://!<
            
            title = JJLocalizedString(@"水平校准完成", nil);
            break;
        case 5://!<
            
            title = JJLocalizedString(@"方向校准进行中", nil);
            
            break;
        case 6://!<
            
            title = JJLocalizedString(@"方向校准完成", nil);
            
            break;
        case 7://!
            
            title = JJLocalizedString(@"安装位置移动", nil);
            
            break;
        case 10://!<
            title = JJLocalizedString(@"急刹车", nil);
            
            break;
        case 11://!<
            
            title = JJLocalizedString(@"急加油", nil);
            
            break;
        case 12://!<
            
            title = JJLocalizedString(@"快速变道", nil);
            
            break;
        case 13://!<
            
            title = JJLocalizedString(@"弯道加速", nil);
            
            break;
        case 14://!<
            
            title = JJLocalizedString(@"碰撞", nil);
            
            break;
        case 15://!<
            
            title = JJLocalizedString(@"频繁变道", nil);
            
            break;
        case 16://!<
            
            title = JJLocalizedString(@"烂路高速行驶", nil);
            
            break;
        case 17://!<
            
            title = JJLocalizedString(@"急转弯", nil);
            
            break;
        case 18://!<
            
            title = JJLocalizedString( @"翻车", nil);
            
            break;
        case 19://!<
            
            title = JJLocalizedString(@"异常震动", nil);
            
            break;
        case 20://!<
            
            
            title = JJLocalizedString(@"车门异响", nil);
            
            break;
        case 21://!<
            
            title = JJLocalizedString(@"胎压和手刹异常", nil);
            
            break;
        case 30://!<
            
            title = JJLocalizedString(@"超速报警", nil);
            
            break;
        case 31://!<
            
            title = JJLocalizedString(@"水温报警", nil);
            
            break;
        case 32://!<
            
            title = JJLocalizedString(@"转速报警", nil);
            
            break;
        case 33://!<
            
            title = JJLocalizedString(@"电压报警", nil);
            
            break;
        case 34://!<
            
            title = JJLocalizedString(@"故障报警", nil);
            
            break;
            
        case 35:
        
        title = JJLocalizedString(@"怠速报警", nil);
        
            break;
            
        case 38:
        
        title = JJLocalizedString(@"拖吊报警", nil);
            
            break;
            
        default:
            
            title = nil;//!< 无事件
            
            break;
    }
    
    if (title) {
        
        //!< 说明有时间类型
        GMSMarker *AMarker = [GMSMarker markerWithPosition:[self.location coordinate]];
        
        AMarker.title = title;
        
        return AMarker;
        
    }else
    {
         return nil;
    }
    


   
}
@end
