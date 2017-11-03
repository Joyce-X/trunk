//
//  XMMiddleScrollView.m
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMiddleScrollView.h"

@interface XMMiddleScrollView ()

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;//!< 总距离
@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;//!< 开始时间
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;//!< 结束时间
@property (weak, nonatomic) IBOutlet UILabel *jijiasuLabel;//!< 急加速
@property (weak, nonatomic) IBOutlet UILabel *jishacheLabel;//!< 急刹车
@property (weak, nonatomic) IBOutlet UILabel *jizhaunwanLabel;//!< 急转弯
@property (weak, nonatomic) IBOutlet UILabel *wandaojiasuLabel;//!< 弯道加速
@property (weak, nonatomic) IBOutlet UILabel *pingjunyouhaoLabel;//!< 平均油耗
@property (weak, nonatomic) IBOutlet UILabel *averageSpeedLabel;//!< 平均速度
/**
 行驶时间label
 */
@property (weak, nonatomic) IBOutlet UILabel *xingshishijianLabel;

/**
 参考邮费label
 */
@property (weak, nonatomic) IBOutlet UILabel *estimatePriceLabel;
/**
 耗油量Label
 */
@property (weak, nonatomic) IBOutlet UILabel *haoyouliangLabel;

@end


@implementation XMMiddleScrollView

/**
 *  点击操作按钮
 */
- (IBAction)buttonClick:(UIButton *)sender {
    
    //!< 通知代理进行跳转
    if(self.delegate && [self.delegate respondsToSelector:@selector(scrollViewJumpBtnClick:)])
    {
        [self.delegate scrollViewJumpBtnClick:self];
    
    }
    
}

- (void)scrollToBottom
{
    
    CGRect frame = self.frame;
    
    frame.origin.y = mainSize.height - 100;
    
    [UIView animateWithDuration:0.2 animations:^{
        
        self.frame = frame;
        
    }];
    
     

}

- (void)setModel:(XMTrackSegmentStateModel *)model
{
    _model = model;
    
    //!< 设置数据...
    self.distanceLabel.text = [XMUnitConvertManager convertKmToMile:model.licheng.floatValue];//[NSString stringWithFormat:@"%.2f",model.licheng.floatValue];
    
    //!< 对start时间和end时间进行处理
    if(model.starttime.length > 0 && model.endtime.length > 0)
    {
        NSArray *arr = [model.starttime componentsSeparatedByString:@"T"];
    
        if (arr.count == 2)
        {
               self.startTimeLabel.text = arr.lastObject;
        }
        
        NSArray *arr2 = [model.endtime componentsSeparatedByString:@"T"];
        
        if (arr2.count == 2)
        {
            self.endTimeLabel.text = arr2.lastObject;
        }
    
    }
    
    self.jijiasuLabel.text = [NSString stringWithFormat:@"%@ time(s)",model.jijiayou];
    
    self.jishacheLabel.text = [NSString stringWithFormat:@"%@ time(s)",model.jishache];
    
    self.jizhaunwanLabel.text = [NSString stringWithFormat:@"%@ time(s)",model.jizhuanwan];
    
    self.wandaojiasuLabel.text = [NSString stringWithFormat:@"%@ time(s)",model.wandaojiasu];
    
    //!< 平均油耗 需要换算
    self.pingjunyouhaoLabel.text = [XMUnitConvertManager litrePer100KMToGallonPer100Mile:model.pingjunouhao.floatValue];
    
    //!< convert km/h to mile/h
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@ mile/h",[XMUnitConvertManager convertKmToMileWithoutUnit:model.pingjunsudu.floatValue]];
    
    //!< It has been processed in the model<XMTrackSegmentStateModel> implementation
    self.xingshishijianLabel.text = model.xingshiTime;
    
  
    //!< estimate price = gallon * per price/gallon, 1 conver the latre to gallon,2 the unit of specify peice shoule be gallon
    
    //!< 油价 * 耗油
    float price = [[XMUnitConvertManager convertLitreToGallonWithoutUnit:model.penyou.floatValue] floatValue] * XMEstimateFuelPrice;
    
    self.estimatePriceLabel.text = [NSString stringWithFormat:@"%.2f $",price];
    
    self.haoyouliangLabel.text = [XMUnitConvertManager convertLitreToGallon:model.penyou.floatValue];//[NSString stringWithFormat:@"%@L",model.penyou];

}

@end
