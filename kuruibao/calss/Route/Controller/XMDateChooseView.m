//
//  XMDateChooseView.m
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMDateChooseView.h"

@interface XMDateChooseView ()

@property (weak, nonatomic) IBOutlet UIDatePicker *picker1;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker2;
@property (weak, nonatomic) IBOutlet UIDatePicker *picker3;

//!< 定义三个变量记录是否picker是否有变化
@property (assign, nonatomic) BOOL pickerIsChange_01;
@property (assign, nonatomic) BOOL pickerIsChange_02;
@property (assign, nonatomic) BOOL pickerIsChange_03;


@end

@implementation XMDateChooseView



-(void)awakeFromNib
{
    [super awakeFromNib];
    
    [self.picker1 setValue:XMWhiteColor forKey:@"textColor"];
    [self.picker2 setValue:XMWhiteColor forKey:@"textColor"];
    [self.picker3 setValue:XMWhiteColor forKey:@"textColor"];
    
    //!< 设置时间
//    NSDateFormatter *df = [[NSDateFormatter alloc]init];
//    
//    df.dateFormat = @"yyyy-MM-dd HH:mm";
//    
//    //!< 设置datepicker默认时间的显示
//    self.picker2.date = [df dateFromString:@"2017-02-02 00:00"];
//    
//    self.picker3.date = [df dateFromString:@"2017-02-02 23:59"];

}

-(void)show
{
    
    //!< 底部添加蒙版，点击蒙版的时候，把当前的视图从window上删除
    
    UIView *coverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, mainSize.width, mainSize.height)];
    
    coverView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    coverView.tag = 110;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(coverClick)];
    
    [coverView addGestureRecognizer:tap];
    
    CGFloat x = (mainSize.width - (300))/2;
    
    CGFloat y = (mainSize.height - (358))/2;
    
    self.frame = CGRectMake(x, y, (300), (358));
    
    [coverView addSubview:self];
    
    [[UIApplication sharedApplication].keyWindow addSubview:coverView];
    
  
}

/**
 *  点击空白区域，删除当前视图
 */
- (void)coverClick
{
    UIView *cover = [[UIApplication sharedApplication].keyWindow viewWithTag:110];
    
    [cover removeFromSuperview];
    
    
}

/**
 * 点击确认按钮
 */
- (IBAction)clickConfirm:(id)sender {
    
//    if (self.pickerIsChange_01 == NO &&  self.pickerIsChange_02 == NO  && self.pickerIsChange_03 == NO)
//    {
//        
//        //!< 删除当前界面
//        [self coverClick];
//        
//        return;
//    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseViewDidSelectDate:start:end:)]) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc]init];
        
        format.dateFormat = @"yyyy-MM-dd";
        
        NSString *str1 = [format stringFromDate:self.picker1.date];
        
        format.dateFormat = @"HH:mm";
        
        NSString *str2 = [format stringFromDate:self.picker2.date];
        NSString *str3 = [format stringFromDate:self.picker3.date];
        
        //!< 通知代理更新数据
        [self.delegate chooseViewDidSelectDate:str1 start:str2 end:str3];
        
        //!< 删除当前界面
        [self coverClick];
        
    }
}


/**
 *  点击回复到当前时间按钮
 */
- (IBAction)yesClick:(id)sender {
    
    [self.picker1 setDate:[NSDate date]];
    
    //!< set the start tiem to 00:00  and set end time to 23:59
    
    NSDateFormatter *df = [NSDateFormatter new];
    
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    
    NSDate *date1 = [df dateFromString:@"2017-12-12 00:00"];
    
    [self.picker2 setDate:date1];
    
    date1 = [df dateFromString:@"2017-12-12 23:59"];
    
    [self.picker3 setDate:date1];
    
    
}

//!< 监听picker事件
- (IBAction)picker1DidChange:(UIDatePicker *)sender {
    
    self.pickerIsChange_01 = YES;
    
}
- (IBAction)picker2DidChange:(UIDatePicker *)sender {
    
     self.pickerIsChange_02 = YES;
}
- (IBAction)picker3DidChange:(UIDatePicker *)sender {
    
     self.pickerIsChange_03 = YES;
}


#pragma mark ------- setter  设置当前要显示的时间
- (void)setDate1:(NSDate *)date1
{
    _date1 = date1;
    
    self.picker1.date = date1;

}

-(void)setDate2:(NSDate *)date2
{
    _date2 = date2;
    
    self.picker2.date = date2;
    

}

- (void)setDate3:(NSDate *)date3
{
    _date3 = date3;
    
    self.picker3.date = date3;

}


@end
