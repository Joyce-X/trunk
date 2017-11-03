//
//  XMHome_usScrollView.m
//  kuruibao
//
//  Created by x on 17/7/26.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMHome_usScrollView.h"

#import "NSDictionary+convert.h"

#define itemFont [UIFont systemFontOfSize:14]
#define itemHeightFactor (1.0/3)

#define adjustValue (-4)

@interface XMHome_usScrollView ()

@property (weak, nonatomic) UILabel *averageSpeedLabel;//!< 平均速度
@property (weak, nonatomic) UILabel *maxSpeedLabel;//!< 最高速度
@property (weak, nonatomic) UILabel *totalDistanceLabel;//!< 总里程
@property (weak, nonatomic) UILabel *totalConsumptionLabel;//!< 总油耗
@property (weak, nonatomic) UILabel *startTimeLabel;//!< 开始时间
@property (weak, nonatomic) UILabel *endTimeLabel;//!< 结束时间
@property (weak, nonatomic) UILabel *batteryVoltageLabel;//!< 电瓶电压
@property (weak, nonatomic) UILabel *waterTemperatureLabel;//!< 水箱水温



@end

@implementation XMHome_usScrollView

- (instancetype)init
{
    self = [super init];
   
    if (self) {
        
        [self setupSubviews];
        
    }
    return self;
}

- (void)setupSubviews
{
    self.contentSize = CGSizeMake(mainSize.width * 3, 0);
    self.showsHorizontalScrollIndicator = NO;
    self.pagingEnabled = YES;
    
    //1.1
    UILabel *rateLabel = [UILabel new];
    rateLabel.textColor = XMWhiteColor;
    rateLabel.font = itemFont;
    rateLabel.tag = 201;
    rateLabel.text = JJLocalizedString(@"平均速度", nil);
    rateLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:rateLabel];
    [rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //1.2
    UILabel *batteryLabel = [UILabel new];
    batteryLabel.textColor = XMWhiteColor;
    batteryLabel.font = itemFont;
     batteryLabel.tag = 202;
    batteryLabel.text = JJLocalizedString(@"最大速度", nil);
    batteryLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:batteryLabel];
    [batteryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(rateLabel.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //1.3
    UILabel *waterLabel = [UILabel new];
    waterLabel.textColor = XMWhiteColor;
    waterLabel.font = itemFont;
    waterLabel.tag = 203;
    waterLabel.text = JJLocalizedString(@"总里程", nil);
    waterLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:waterLabel];
    [waterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(batteryLabel.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //1.1-1  平均速度
    UILabel *rate = [UILabel new];
    rate.textColor = XMWhiteColor;
    rate.font = itemFont;
    rate.text = JJLocalizedString(@"--mile/h", nil);;
    [self addSubview:rate];
    self.averageSpeedLabel = rate;
    [rate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(rateLabel.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //1.2-1 最大车速
    UILabel *battery = [UILabel new];
    battery.textColor = XMWhiteColor;
    battery.font = itemFont;
    battery.text = JJLocalizedString(@"--mile/h", nil);;
    [self addSubview:battery];
    self.maxSpeedLabel = battery;
    [battery mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(rate.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(batteryLabel.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //1.3-1 总里程
    UILabel *water = [UILabel new];
    water.textColor = XMWhiteColor;
    water.font = itemFont;
    water.text = JJLocalizedString(@"--mile", nil);;
    [self addSubview:water];
    self.totalDistanceLabel = water;
    [water mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(battery.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(waterLabel.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];

    
    
    
    
    
    //2.1
    UILabel *journeyLabel = [UILabel new];
    journeyLabel.textColor = XMWhiteColor;
    journeyLabel.font = itemFont;
    journeyLabel.tag = 204;
    journeyLabel.text = JJLocalizedString(@"总油耗 ", nil);
    journeyLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:journeyLabel];
    [journeyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self).offset(mainSize.width);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    
    //2.1-1 总油耗
    UILabel *journey = [UILabel new];
    journey.textColor = XMWhiteColor;
    journey.font = itemFont;
    journey.text = JJLocalizedString(@"--gallon", nil);
    [self addSubview:journey];
    self.totalConsumptionLabel = journey;
    [journey mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(journeyLabel);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(journeyLabel.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    
    //3.1
    UILabel *Label3 = [UILabel new];
    Label3.textColor = XMWhiteColor;
    Label3.tag = 205;
    Label3.font = itemFont;
    Label3.text = JJLocalizedString(@"电压", nil);
    Label3.textAlignment = NSTextAlignmentRight;
    [self addSubview:Label3];
    [Label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(journeyLabel.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(journeyLabel);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    
    //3.2
    UILabel *Label4 = [UILabel new];
    Label4.textColor = XMWhiteColor;
    Label4.font = itemFont;
    Label4.tag = 206;
    Label4.text = JJLocalizedString(@"水温", nil);
    Label4.textAlignment = NSTextAlignmentRight;
    [self addSubview:Label4];
    [Label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Label3.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self).offset(mainSize.width);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    
    //3.1-1 电压
    UILabel *label_03 = [UILabel new];
    label_03.textColor = XMWhiteColor;
    label_03.font = itemFont;
    label_03.text = JJLocalizedString(@"--V", nil);;
    [self addSubview:label_03];
    self.batteryVoltageLabel = label_03;
    [label_03 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Label3);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(Label3.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //3.2-1 水温 1摄氏度(℃)=33.8华氏度(℉)
    UILabel *label_04 = [UILabel new];
    label_04.textColor = XMWhiteColor;
    label_04.font = itemFont;
    label_04.text = JJLocalizedString(@"--°F", nil);;
    [self addSubview:label_04];
    self.waterTemperatureLabel = label_04;
    [label_04 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label_03.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(label_03);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];

    
    
    
    
    
    
    
    
    
    
    
    
    //2.2
    UILabel *Label1 = [UILabel new];
    Label1.textColor = XMWhiteColor;
    Label1.font = itemFont;
    Label1.tag = 207;
    Label1.text = JJLocalizedString(@"开始时间", nil);
    Label1.textAlignment = NSTextAlignmentRight;
    [self addSubview:Label1];
    [Label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(self).offset(mainSize.width * 2);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
    }];
    
    //2.3
    UILabel *Label2 = [UILabel new];
    Label2.textColor = XMWhiteColor;
    Label2.font = itemFont;
    Label2.tag = 208;
    Label2.text = JJLocalizedString(@"结束时间", nil);
    Label2.textAlignment = NSTextAlignmentRight;
    [self addSubview:Label2];
    [Label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Label1.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(Label1);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //-----------------------------seperate line---------------------------------------//
    //2.2-1 开始时间
    UILabel *label_01 = [UILabel new];
    label_01.textColor = XMWhiteColor;
    label_01.font = itemFont;
    label_01.text = JJLocalizedString(@"--", nil);
    [self addSubview:label_01];
    self.startTimeLabel = label_01;
    [label_01 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(Label1);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(Label1.mas_right).offset(30);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
        
    }];
    
    //2.3-1 结束时间
    UILabel *label_02 = [UILabel new];
    label_02.textColor = XMWhiteColor;
    label_02.font = itemFont;
    label_02.text = JJLocalizedString(@"--", nil);
    [self addSubview:label_02];
    self.endTimeLabel = label_02;
    [label_02 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(label_01.mas_bottom).offset(adjustValue);
        make.width.equalTo(mainSize.width/2-15);
        make.left.equalTo(label_01);
        make.height.equalTo(self).multipliedBy(itemHeightFactor);
    }];
    
  
  
    
}

 /**
 设置数据
 
 @param dic 实时数据
 */
- (void)setData:(NSDictionary *)dic
{
    
    if(dic == nil)
    {
        [self clear];//!< 清除数据
        
        return;
    
    }
    
    //!< 设置实时数据
    dic = [NSDictionary nullDic:dic];
    
    //!< aevrage
    NSString *average = dic[@"oXC"][@"avgspeed"];
    
    //!< max
    NSString *max = dic[@"oXC"][@"maxspeed"];
    
    //!< total distance
    NSString *distance = dic[@"oXC"][@"licheng"];
    
    //!< consumption
    NSString *consumption = dic[@"oXC"][@"penyou"];
    
    //!< start time
    NSString *startTime = dic[@"oXC"][@"startHHmmSS"];
    
    //!< endTime
//    NSString *endTime = dic[@"oXC"][@"endHHmmSS"];
    
    //!< voltage
    NSString *voltage = dic[@"oCK"][@"parm1101"];
    
    //!< temperature
    NSString *temperature = dic[@"oCK"][@"parm0004"];
    
    //!< 平均速度
    self.averageSpeedLabel.text = [NSString stringWithFormat:@"%@ mile/h",[XMUnitConvertManager convertKmToMileWithoutUnit:average.floatValue]];
    
    //!< 最高速度
    self.maxSpeedLabel.text = [NSString stringWithFormat:@"%@ mile/h",[XMUnitConvertManager convertKmToMileWithoutUnit:max.floatValue]];

    //!< 总距离
    self.totalDistanceLabel.text = [XMUnitConvertManager convertKmToMile:distance.floatValue];//[NSString stringWithFormat:@"%@km",distance];

    //!< 总油耗
    self.totalConsumptionLabel.text = [XMUnitConvertManager convertLitreToGallon:consumption.floatValue];//[NSString stringWithFormat:@"%@L",consumption];

    self.startTimeLabel.text = startTime;

//    self.endTimeLabel.text = endTime;

    self.endTimeLabel.text = JJLocalizedString(@"未结束", nil);

    
    self.batteryVoltageLabel.text = [NSString stringWithFormat:@"%@ V",voltage];

    //!< 水温
    self.waterTemperatureLabel.text = [XMUnitConvertManager convertTemperatureToF:temperature.floatValue];//[NSString stringWithFormat:@"%@°C",temperature];

    
    
}

- (void)shouldUpdateText
{

    UILabel *label1 = [self viewWithTag:201];
  
    label1.text = JJLocalizedString(@"平均速度", nil);
    
    
    
    UILabel *label2 = [self viewWithTag:202];
    
    label2.text =  JJLocalizedString(@"最大速度", nil);
    
    
    UILabel *label3 = [self viewWithTag:203];
    
    label3.text =  JJLocalizedString(@"总里程", nil);
    
    
    
    UILabel *label4 = [self viewWithTag:204];
    
    label4.text =  JJLocalizedString(@"总油耗 ", nil);
    
    
    
    UILabel *label5 = [self viewWithTag:205];
    
    label5.text =  JJLocalizedString(@"电压", nil);
    
    
    
    
    UILabel *label6 = [self viewWithTag:206];
    
    label6.text =  JJLocalizedString(@"水温", nil);
    
    
    
    UILabel *label7 = [self viewWithTag:207];
    
    label7.text =  JJLocalizedString(@"开始时间", nil);
    
    
    
    UILabel *label8 = [self viewWithTag:208];
    
    label8.text =  JJLocalizedString(@"结束时间", nil);
    
    
    //!< 当实时监控开启的时候，可能会显示为中文或英文，所以清空，当下次赋值时候再自动根据语言加载
    self.endTimeLabel.text = JJLocalizedString(@"--", nil);
    
   

}

- (void)clear
{
    //!< 清空所有显示数据
    self.averageSpeedLabel.text = JJLocalizedString(@"--mile/h", nil);
    self.maxSpeedLabel.text = JJLocalizedString(@"--mile/h", nil);
    self.totalDistanceLabel.text = JJLocalizedString(@"--mile", nil);
    self.totalConsumptionLabel.text = JJLocalizedString(@"--gallon", nil);
    self.startTimeLabel.text = JJLocalizedString(@"--", nil);
    self.endTimeLabel.text = JJLocalizedString(@"--", nil);
    self.batteryVoltageLabel.text = JJLocalizedString(@"--V", nil);
    self.waterTemperatureLabel.text = JJLocalizedString(@"--°F", nil);
    

}

@end
