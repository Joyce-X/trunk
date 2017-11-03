//
//  XMScoreLabel.m
//  kuruibao
//
//  Created by x on 17/7/28.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMScoreLabel.h"


@interface XMScoreLabel ()

@property (assign, nonatomic) NSInteger index;

@property (assign, nonatomic) NSInteger desScore;//!< 目标分数
@end


@implementation XMScoreLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textColor = XMWhiteColor;
        self.textAlignment = NSTextAlignmentCenter;
        self.adjustsFontSizeToFitWidth = YES;
        self.index = 0;
    }
    return self;
}

- (void)setScore:(NSInteger)score
{

    _score = score;
    
    //!< 对0 和 1 的情况进行判断
    if (score < 2)
    {
        
        
        NSString *text = [[NSString alloc]initWithFormat:@"%lupoint",score];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
        
        
        NSRange range2 = [text rangeOfString:@"point"];
        NSRange range1 = NSMakeRange(0, text.length - range2.length);
        
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.fontSize/96.0*72] range:range1];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range2];
        self.attributedText = str;
        
        
        
    }else
    {
        //!< 大于1的情况使用points 复数
        NSString *text = [[NSString alloc]initWithFormat:@"%lupoints",score];
        
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
        
        
        NSRange range2 = [text rangeOfString:@"points"];
        NSRange range1 = NSMakeRange(0, text.length - range2.length);
        
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.fontSize/96.0*72] range:range1];
        [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:12] range:range2];
        self.attributedText = str;
    
    
    
    }
    

}

- (void)setAnimateScore:(NSInteger)animateScore
{
    _animateScore = animateScore;

    NSString *text = [[NSString alloc]initWithFormat:@"%lu%%",animateScore];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:text];
    
    
    NSRange range2 = [text rangeOfString:@"%"];
    NSRange range1 = NSMakeRange(0, text.length - range2.length);
    
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:self.fontSize/96.0*72] range:range1];
    [str addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:20] range:range2];
    self.attributedText = str;

}

- (void)animateToScore:(NSInteger)score duration:(float)duration
{
    self.desScore = score;
    
    if (score == 0)
    {
        self.score = 0;return;
    }
   

    [NSTimer scheduledTimerWithTimeInterval:duration/score target:self selector:@selector(timerTrigger:) userInfo:nil repeats:YES];



}

- (void)timerTrigger:(NSTimer *)timer
{
    self.score = ++self.index;
    
    if (self.index >= _desScore)
    {
        self.score = _desScore;
        
        [timer invalidate];
        
        self.index = 0;
    }
    
}


@end
