//
//  XMMeBottomView.m
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMeBottomView.h"

@interface XMMeBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *aboutLabel;//!< 显示关于字段

@property (weak, nonatomic) IBOutlet UILabel *settingLabel;//!< 显示设置字段
/**
 绑定状态label
 */
@property (weak, nonatomic) IBOutlet UILabel *linkStateLabel;

@end

@implementation XMMeBottomView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    //!< 设置车牌号码默认不显示
//    self.carNumberLabel.text = @"";
    
    
    self.aboutLabel.text = JJLocalizedString(@"关于 DashPal", nil);
    
    self.settingLabel.text = JJLocalizedString(@"设置", nil);
    
    
    
    //!< 监听车牌变化
    [self.carNumberLabel addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionNew context:nil];
    
    
    

}
/**
 *  更新文字内容
 */
- (void)shouldUpdateText
{
    self.aboutLabel.text = JJLocalizedString(@"关于 DashPal", nil);
    
    self.settingLabel.text = JJLocalizedString(@"设置", nil);
    
    [self setLinkState:_linkState];
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

 
 

    if ([keyPath isEqualToString:@"text"])
    {
        NSString * text = change[NSKeyValueChangeNewKey];
        
        if ([text isEqualToString:@"0"])
        {
            //!< 避免出现0 的情况
            self.carNumberLabel.text = JJLocalizedString(@"车牌号码", nil);
        }
    }

}


- (void)setLinkState:(BOOL)linkState
{
    _linkState = linkState;
    
    if (linkState) {
        
        self.linkStateLabel.text = JJLocalizedString(@"已绑定", nil);
    }else
    {
    
        self.linkStateLabel.text = JJLocalizedString(@"未绑定", nil);

    
    }


}

- (IBAction)clickCar:(UITapGestureRecognizer *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewDidClickCar:)]) {
        
        [self.delegate bottomViewDidClickCar:self];
    }
    
}
- (IBAction)clickSetting:(UITapGestureRecognizer *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewDidClickSetting:)]) {
        
        [self.delegate bottomViewDidClickSetting:self];
    }

}
- (IBAction)clickAbout:(id)sender {
    


    if (self.delegate && [self.delegate respondsToSelector:@selector(bottomViewDidClickAbout:)]) {
        
        [self.delegate bottomViewDidClickAbout:self];
    }

}

-(void)dealloc
{

    //!< 移除观察者
    [self.carNumberLabel removeObserver:self forKeyPath:@"text"];

    
}


@end
