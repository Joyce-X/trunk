//
//  XMMeMiddleView.m
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMeMiddleView.h"
#import "UIImageView+WebCache.h"
@interface XMMeMiddleView ()

/**
 推荐label
 */
@property (weak, nonatomic) UILabel *recommendLabel;

/**
 morelabel
 */
@property (weak, nonatomic) UILabel *moreLabel;

@end

@implementation XMMeMiddleView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupInit];
        
    }
    return self;
}


- (void)setupInit
{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    
    
    //!< 图标
    UIImageView *icon = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Recommend icon"]];
    
    [self addSubview:icon];
    
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self).offset(15);
        
        make.top.equalTo(self).offset(13);
        
        make.size.equalTo(CGSizeMake(17, 14));
        
    }];
    
    //!< 文字
    UILabel *labelR = [UILabel new];
    
    labelR.textColor = XMWhiteColor;
    
    labelR.font = [UIFont boldSystemFontOfSize:16];
    
    labelR.text = JJLocalizedString(@"推荐", nil);
    
    [self addSubview:labelR];
    
    self.recommendLabel = labelR;
    
    [labelR mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(icon.mas_right).offset(10);
        
        make.centerY.equalTo(icon);
        
        make.size.equalTo(CGSizeMake(120, 30));
        
    }];
    
    //!< 容器
    UIView *tapView = [UIView new];
    
    tapView.backgroundColor = XMClearColor;
    
    [self addSubview:tapView];
    
    [tapView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.right.equalTo(self).offset(-20);
        
        make.centerY.equalTo(labelR);
        
        make.size.equalTo(CGSizeMake(100, 40));
        
    }];
    
    //!< arrow
    UIImageView *arrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
    [tapView addSubview:arrow];
    
    [arrow mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(12, 18));
        
        make.right.centerY.equalTo(tapView);
        
        
        
    }];
    
    //!< more
    UILabel *moreL = [UILabel new];
    
    moreL.textColor = XMWhiteColor;
    
    moreL.font = [UIFont boldSystemFontOfSize:16];
    
    moreL.text = JJLocalizedString(@"更多", nil);
    
    moreL.textAlignment = NSTextAlignmentRight;
    
    [tapView addSubview:moreL];
    
    self.moreLabel = moreL;
    
    [moreL mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(arrow.mas_left).offset(-5);
        
        make.centerY.equalTo(tapView);
        
        make.size.equalTo(CGSizeMake(50, 30));
        
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    
    [tapView addGestureRecognizer:tap];
    
    //!< 添加三张图片
    
    CGFloat width = (mainSize.width - 40 - 26)/3;
    
    
    for (int i = 1; i<4; i++)
    {
        
        UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"middle_paceholderImage"]];
        
        iv.tag = i + 100;
        
        iv.contentMode = UIViewContentModeScaleToFill;
        
        iv.userInteractionEnabled = YES;
        
        [self addSubview:iv];
        
        float leftPadding = 20 + (width + 13) * (i-1);
        
        [iv mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self).offset(leftPadding);
            
            make.top.equalTo(labelR.mas_bottom).offset(6);
            
            make.size.equalTo(CGSizeMake(width, width));
            
        }];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
        
        [iv addGestureRecognizer:tap];
        
    }
    
   //     middle_paceholderImage
    
}

#pragma mark ------- click event

/**
 *  点击more
 */
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    XMLOG(@"---------tapClick---------");
    
    //!< 调用代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(middleViewDidClickMore:)]) {
        
        [self.delegate middleViewDidClickMore:self];
        
    }
    
    
}
/**
  *  点击按钮
  */
- (void)tap:(UITapGestureRecognizer *)sender
{
//    XMLOG(@"---------%d---------",sender.view.tag);
    
    //!< 调用代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(middleViewDidClicImage:atIndex:)]) {
        
        [self.delegate middleViewDidClicImage:self atIndex:sender.view.tag];
        
    }
    
}


#pragma mark ------- setter
- (void)setRecommandArr:(NSArray *)recommandArr
{
    _recommandArr = recommandArr;
    
    if (recommandArr.count < 3)
    {
        XMLOG(@"---------加载数据源，数量不足,只有%ld条---------",(unsigned long)recommandArr.count);
        
        return;
    }
    //!< 设置图片
    UIImageView *btn1 = [self viewWithTag:101];
    UIImageView *btn2 = [self viewWithTag:102];
    UIImageView *btn3 = [self viewWithTag:103];
    
    NSDictionary *dic1 = recommandArr[0];
    
    NSDictionary *dic2 = recommandArr[1];
    
    NSDictionary *dic3 = recommandArr[2];
    
    [btn1 sd_setImageWithURL:[NSURL URLWithString:dic1[@"Url"]] placeholderImage:[UIImage imageNamed:@"middle_paceholderImage"]];
    
    [btn2 sd_setImageWithURL:[NSURL URLWithString:dic2[@"Url"]] placeholderImage:[UIImage imageNamed:@"middle_paceholderImage"]];
    [btn3 sd_setImageWithURL:[NSURL URLWithString:dic3[@"Url"]] placeholderImage:[UIImage imageNamed:@"middle_paceholderImage"]];

    
    
}

- (void)setDisconnectImages:(NSArray<UIImage *> *)disconnectImages
{
    if (disconnectImages == nil || disconnectImages.count != 3)
    {
        XMLOG(@"图片数组为空或数组长度不为3");
        
        [XMMike addLogs:[NSString stringWithFormat:@"图片数组为空或数组长度不为3"]];
        return;

    }

    UIImageView *image1 = [self viewWithTag:101];
    UIImageView *image2 = [self viewWithTag:102];
    UIImageView *image3 = [self viewWithTag:103];

    if(disconnectImages[0])
    {
        
        image1.image = disconnectImages[0];
    
    }
    
    if(disconnectImages[1])
    {
        
        image2.image = disconnectImages[1];
        
    }
    
    if(disconnectImages[2])
    {
        
        image3.image = disconnectImages[2];
        
    }
    

}

/**
 *  更新文字内容
 */
- (void)shouldUpdateText
{
    _recommendLabel.text = JJLocalizedString(@"推荐", nil);
    _moreLabel.text = JJLocalizedString(@"更多", nil);
    
}


@end








