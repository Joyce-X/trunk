//
//  XMShareView.m
//  kuruibao
//
//  Created by x on 17/8/11.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMShareView.h"
#import "XMPresent.h"
@implementation XMShareView

#define animateTime 0.3 //动画时间

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //!< 创建的时候就设置自身发frame
//    self.frame = CGRectMake((mainSize.width -FITWIDTH(265))/2, mainSize.height, FITWIDTH(265), FITHEIGHT(123));
    self.frame = CGRectMake(0, mainSize.height-123, mainSize.width, 123);
    
    

}

- (void)animateToShow
{
    
//    if (self.frame.origin.y != mainSize.height)
//    {
//        //!< 已经显示了
//        XMLOG(@"---------正在显示分享视图---------");
//        return;
//    }
    
//    [UIView animateWithDuration:animateTime animations:^{
//       
//        self.transform = CGAffineTransformMakeTranslation(0, -123);
//        
//    }];
    
    [XMPresent presentView:self withFrame:CGRectZero];

}

- (void)animateToHide{

//    [UIView animateWithDuration:animateTime animations:^{
//        
//        self.transform = CGAffineTransformIdentity;
//        
//    }];
    
    [XMPresent dismissAnimate:YES];
}

/**
 *  点击取消按钮
 */
- (IBAction)cancelTouchdown:(id)sender {
}


- (IBAction)clickTwitter:(id)sender {
    
    [self animateToHide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewClickTwitter:)]) {
        [self.delegate shareViewClickTwitter:self];
    }
    
   
}
- (IBAction)clickFacebook:(id)sender {
    
    [self animateToHide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewClickFacebook:)]) {
        [self.delegate shareViewClickFacebook:self];
    }
}
- (IBAction)clickWhatsapp:(id)sender {
    
    [self animateToHide];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareViewClickWhatsapp:)]) {
        [self.delegate shareViewClickWhatsapp:self];
    }
    
}
- (IBAction)clickCancel:(id)sender {
    
    [self animateToHide];
   
}
@end
