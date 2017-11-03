//
//  XMChooseLanguageView.m
//  kuruibao
//
//  Created by x on 17/10/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMChooseLanguageView.h"
#import "XMLanguageButton.h"

@interface XMChooseLanguageView ()

/**
 显示跟随系统语言的label
 */
@property (weak, nonatomic) IBOutlet UILabel *autoLabel;

/**
 显示英文label
 */
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;

/**
 显示中文label
 */
@property (weak, nonatomic) IBOutlet UILabel *chineseLabel;


/**
 自动按钮
 */
@property (weak, nonatomic) IBOutlet XMLanguageButton *autoBtn;

/**
 英文按钮
 */
@property (weak, nonatomic) IBOutlet XMLanguageButton *englihBtn;

/**
 中文按钮
 */
@property (weak, nonatomic) IBOutlet XMLanguageButton *chineseBtn;



@end


@implementation XMChooseLanguageView


-(void)awakeFromNib
{

    [super awakeFromNib];
    
    //!< 统一设置为未选中
    _chineseBtn.selected = NO;
    
    _englihBtn.selected = NO;
    
    _autoBtn.selected = NO;
    
    _autoLabel.text = JJLocalizedString(@"跟随系统", nil);

}

//!< 禁止按钮进行交互，统一使用手势  忽略一下三个方法
- (IBAction)autoClick:(id)sender {
}

- (IBAction)englishClick:(id)sender {
}

- (IBAction)chineseClick:(id)sender {
}


/**
 *  响应自动手势
 */
- (IBAction)autoTap:(id)sender {
    
    _chineseBtn.selected = NO;
    
    _englihBtn.selected = NO;
    
    _autoBtn.selected = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseLanguageView:didSelectedIndex:)])
    {
        [self.delegate chooseLanguageView:self didSelectedIndex:1];
    }
    
     
}

/**
 *  响应英文手势
 */
- (IBAction)englishTap:(id)sender {
    
    _chineseBtn.selected = NO;
    
    _englihBtn.selected = YES;
    
    _autoBtn.selected = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseLanguageView:didSelectedIndex:)])
    {
        [self.delegate chooseLanguageView:self didSelectedIndex:2];
    }
}

/**
 *  响应中文手势
 */
- (IBAction)chineseTap:(id)sender {
    
    _chineseBtn.selected = YES;
    
    _englihBtn.selected = NO;
    
    _autoBtn.selected = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(chooseLanguageView:didSelectedIndex:)])
    {
        [self.delegate chooseLanguageView:self didSelectedIndex:3];
    }
}

- (void)setLanguage:(XMLanguageType)type
{
    switch (type) {
        case XMLanguageTypeAuto:
            
            _autoBtn.selected = YES;
            
            break;
            
        case XMLanguageTypeEnglish:
            
            _englihBtn.selected = YES;
            
            break;
            
        case XMLanguageTypeChinese:
            
            _chineseBtn.selected = YES;
            
            break;
            
            
        default:
            break;
    }



}
 


@end
