//
//  XMCountDownBtn.m
//  kuruibao
//
//  Created by x on 17/8/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCountDownBtn.h"

@interface XMCountDownBtn ()

@property (strong, nonatomic) NSTimer *timer;//!< 改变显示文字  默认不会自动开启定时器

@property (assign, nonatomic) int index;//!<  标记当前倒计时时间

@end

@implementation XMCountDownBtn

/**
 *  开始倒计时
 */
- (void)startTimer
{
     self.index = 10;
    
    self.enabled = YES;
   
    if (self.timer )
    {
        [self.timer invalidate];
        
        self.timer = nil;
    }
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(changeTitle:) userInfo:nil repeats:YES];
}

- (void)pauseTimer
{
//    self.index = 10; 暂停计时器，不会修改index  只是干掉定时器
    
    [self.timer invalidate];
    
    self.timer  = nil;
    
    self.enabled = NO;
}

- (void)stopTimer
{
    self.index = 10;
    
    [self.timer invalidate];
    
    self.timer = nil;

}

- (void)changeTitle:(NSTimer *)timer
{
    
    [self setTitle:[NSString stringWithFormat:@"%d",_index] forState:UIControlStateNormal];
        
        if (self.index == 1)
        {
            //!< 通知代理更新数据，停止定时器，设置不可点
            if (self.delegate && [self.delegate respondsToSelector:@selector(pleaseUpdateData)])
            {
                [self.delegate pleaseUpdateData];
            }
            
            [timer invalidate];
            
            self.timer = nil;
            
            self.enabled = NO;
            
        }
        
    self.index--;
}

#pragma mark ------- setter

- (void)setIndex:(int)index
{
    //!< 倒计时到0 的时候，从10从新开始倒计时
    if (index == 0)
    {
        index = 10;
    }
    
    _index = index;
   

}

- (void)dealloc
{

    XMLOG(@"---------dealloc---------");

}

@end
