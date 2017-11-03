//
//  XMControlAnimateView.m
//  kuruibao
//
//  Created by x on 17/8/13.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMControlAnimateView.h"

@interface XMControlAnimateView ()

//@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;

@property (weak, nonatomic) IBOutlet UISlider *slider;

@end


@implementation XMControlAnimateView

-(void)awakeFromNib
{
    [super awakeFromNib];
    
//    self.progressView.layer.borderWidth = 1;
//    
//    self.progressView.layer.cornerRadius = 1;
//    
//    self.progressView.layer.masksToBounds = YES;
//    
//    self.progressView.layer.borderColor = XMGrayColor.CGColor;
    

}

- (IBAction)cliclkPlayBtn:(UIButton *)sender {
    
//    sender.selected = !sender.selected;
     
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlAnimateViewDidClickPlayBtn:)])
    {
        [self.delegate controlAnimateViewDidClickPlayBtn:sender];
    }
    
    
    
}
- (IBAction)clickBackBtn:(id)sender {
    
    //!< 返回到上一界面
    if (self.delegate && [self.delegate respondsToSelector:@selector(controlAnimateViewDidClickBack)])
    {
        [self.delegate controlAnimateViewDidClickBack];
    }
}
- (IBAction)touchUpInside:(UISlider *)sender {
    
      XMLOG(@"--------------------");
    if(self.delegate && [self.delegate respondsToSelector:@selector(controlAnimateViewDidTouchUpInset:)])
    {
        
        [self.delegate controlAnimateViewDidTouchUpInset:sender];
    
    }
    
}

 


/**
 *  设置进度
 */

- (void)setProgress:(float)progress
{
    _progress  = progress;
    
//    self.progressView.progress = progress;
    self.slider.value = progress;

    if (progress == 1)
    {
        self.playBtn.selected = NO;
    }
}
@end
