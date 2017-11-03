//
//  XMRealTimeView.m
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMRealTimeView.h"
#import "XMCountDownBtn.h"
@interface XMRealTimeView ()<XMCountDownBtnDelegate>


/**
 倒计时按钮
 */
@property (weak, nonatomic) IBOutlet XMCountDownBtn *countDownBtn;
/**
 行驶里程
 */
@property (weak, nonatomic) IBOutlet UILabel *xingshilichengLabel;
/**
 百公里油耗
 */
@property (weak, nonatomic) IBOutlet UILabel *baigongliyouhaoLabel;
/**
 总油耗
 */
@property (weak, nonatomic) IBOutlet UILabel *zongyouhaoLabel;
/**
 速度
 */
@property (weak, nonatomic) IBOutlet UILabel *chesuLabel;
/**
 转速
 */
@property (weak, nonatomic) IBOutlet UILabel *zhaunsuLabel;
/**
 电压
 */
@property (weak, nonatomic) IBOutlet UILabel *dianyaLabel;
/**
 水温
 */
@property (weak, nonatomic) IBOutlet UILabel *shuiwenLabel;
/**
 急加速
 */
@property (weak, nonatomic) IBOutlet UILabel *jijiasuLabel;

/**
 急刹车
 */
@property (weak, nonatomic) IBOutlet UILabel *JIshacheLabel;
/**
 急转弯
 */
@property (weak, nonatomic) IBOutlet UILabel *jizhuanwanLabel;
/**
 弯道加速
 */
@property (weak, nonatomic) IBOutlet UILabel *wandaojiasuLabel;

@end


@implementation XMRealTimeView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.countDownBtn.delegate = self;


}

/**
 *  点击倒计时按钮
 */
- (IBAction)countDownBtnClick:(XMCountDownBtn *)sender {
    
    //!< 通知代理响应点击事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(realTimeViewDidClickCountDownBtn:)])
    {
        [self.delegate realTimeViewDidClickCountDownBtn:self];
    }
    
    [_countDownBtn pauseTimer];
    
    self.isCountingDown = NO;
    
}

/**
 停止倒计时
 */
- (void)pauseTimer
{
    
    [_countDownBtn pauseTimer];
    
    [self resteTime];
    
    self.isCountingDown = NO;
}

/**
 开始倒计时
 */
- (void)startTimer
{

    //!< 更新完数据后，开始定时器
    [self.countDownBtn startTimer];
    
    self.isCountingDown = YES;

}

- (void)resteTime
{
    //!< 将倒计时按钮恢复到10秒
    [self.countDownBtn setTitle:JJLocalizedString(@"10", nil) forState:UIControlStateNormal];
 
}

- (void)setDic:(NSDictionary *)dic
{
    _dic = dic;
    
    //!< 里程
    self.xingshilichengLabel.text = [XMUnitConvertManager convertKmToMile:[dic[@"oXC"][@"licheng"] floatValue]];//[NSString stringWithFormat:@"%@ km",dic[@"oXC"][@"licheng"]];
    
    //!< 百公里油耗
    self.baigongliyouhaoLabel.text = [XMUnitConvertManager litrePer100KMToGallonPer100Mile:[dic[@"oXC"][@"avgyouhao"] floatValue]];//[XMUnitConvertManager convertLitreToGallon:[dic[@"oXC"][@"avgyouhao"] floatValue]];//[NSString stringWithFormat:@"%@ L/100km",dic[@"oXC"][@"avgyouhao"]];
    
    //!< 总油耗
    self.zongyouhaoLabel.text = [XMUnitConvertManager convertLitreToGallon:[dic[@"oXC"][@"penyou"] floatValue]];//[NSString stringWithFormat:@"%@L",dic[@"oXC"][@"penyou"]];
    
    //!< 速度 self.chesuLabel.text
    NSString *speed = [NSString stringWithFormat:@"%@/h",[XMUnitConvertManager convertKmToMile:[dic[@"oCK"][@"parm0002"] floatValue]]];
    
    if ([speed containsString:@"."])
    {
        //!< 如果包含点，就对小数点后的数据进行处理
        NSRange range = [speed rangeOfString:@"."];
        
       speed = [speed substringToIndex:range.location];//!< 速度的数值
        
        //!< 拼接单位
        speed = [speed stringByAppendingString:@" mile/h"];
        
    }
    
    self.chesuLabel.text = speed;
    
    //!< 转速
    self.zhaunsuLabel.text = [NSString stringWithFormat:@"%@ rpm",dic[@"oCK"][@"parm0001"]];
    
    //!< 电压
    self.dianyaLabel.text = [NSString stringWithFormat:@"%@ V",dic[@"oCK"][@"parm1101"]];
    //!< 水温
    
    self.shuiwenLabel.text = [XMUnitConvertManager convertTemperatureToF:[dic[@"oCK"][@"parm0004"] floatValue]];//[NSString stringWithFormat:@"%@°C",dic[@"oCK"][@"parm0004"]];
    
    //!< 急加速
    self.jijiasuLabel.text = [NSString stringWithFormat:@"%@ Time(s)",dic[@"oXC"][@"jijiayou"]];
    
    //!< 急刹车
    self.JIshacheLabel.text = [NSString stringWithFormat:@"%@ Time(s)",dic[@"oXC"][@"jishache"]];
    
    //!< 急转弯
    self.jizhuanwanLabel.text = [NSString stringWithFormat:@"%@ Time(s)",dic[@"oXC"][@"jizhuanwan"]];
    
    //!< 弯道加速
    self.wandaojiasuLabel.text = [NSString stringWithFormat:@"%@ Time(s)",dic[@"oXC"][@"wandaojiasu"]];
    
    [self startTimer];

}

#pragma mark ------- XMCountDownBtnDelegate

- (void)pleaseUpdateData
{
    //!< 定时器到10秒，提醒更新数据
    //!< 通知代理响应点击事件
//    if (self.delegate && [self.delegate respondsToSelector:@selector(realTimeViewDidClickCountDownBtn:)])
//    {
//        [self.delegate realTimeViewDidClickCountDownBtn:self];
//    }
    [self countDownBtnClick:nil];

}

@end
