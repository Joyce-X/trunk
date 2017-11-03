//
//  XMSystemMessageCell.m
//  kuruibao
//
//  Created by x on 17/8/21.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMSystemMessageCell.h"

#import "UIImageView+WebCache.h"
@interface XMSystemMessageCell ()

@property (weak, nonatomic) UILabel *timeLabel;

@property (weak, nonatomic) UIView *backView;

@property (weak, nonatomic) UIImageView *iconView;

@property (weak, nonatomic) UILabel *messageLabel;

@property (strong, nonatomic) UIImageView *AD;//!< 显示icon

@end


@implementation XMSystemMessageCell

+(instancetype)dequeueReuseableCellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"XMSystemMessageCell";
    
    XMSystemMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[XMSystemMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
    
    
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        self.backgroundColor = XMClearColor;
        
        UILabel *timeLabel = [UILabel new];
        
        timeLabel.textColor = XMWhiteColor;
        
        timeLabel.font = [UIFont systemFontOfSize:14];
        
        [self.contentView addSubview:timeLabel];
        
        self.timeLabel = timeLabel;
        
        //!< 背景容器
        UIView *backView = [UIView new];
        
        backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        
        [self.contentView addSubview:backView];
        
        self.backView = backView;
        
        //!< icon
        UIImageView *iconView = [UIImageView new];
        
        [backView addSubview:iconView];
        
        self.iconView = iconView;
        
        //!< 添加显示推送消息的Label
        
        UILabel *messageLabel = [UILabel new];
        
        messageLabel.textColor = [UIColor whiteColor];
        
        messageLabel.numberOfLines = 0;
        
        messageLabel.font = [UIFont systemFontOfSize:14];
        
        messageLabel.textAlignment = NSTextAlignmentLeft;
        
        messageLabel.backgroundColor = [UIColor clearColor];
        
        [self.backView addSubview:messageLabel];
        
        self.messageLabel = messageLabel;
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.AD = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"us_home_message_AD"]];
        
        [self.backView addSubview:self.AD];
        
    }
    
    return self;
    
}

- (void)layoutSubviews
{
    
    [super layoutSubviews];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self).offset(8);
        
        make.height.equalTo(17);
        
        make.width.equalTo(320);
        
        make.left.equalTo(self).offset(13);
        
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.right.bottom.equalTo(self);
        
        make.top.equalTo(self.timeLabel.mas_bottom).offset(10);
        
    }];
    
    [self.AD mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(19, 12));
        
        make.centerY.equalTo(self.backView);
        
        make.left.equalTo(self.backView).offset(13);
        
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.equalTo(CGSizeMake(40, 40));
        
        make.centerY.equalTo(self.backView);
        
        make.right.equalTo(self.backView).offset(-13);
        
        
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.backView).offset(13);
        
        make.left.equalTo(self.AD.mas_right).offset(13);
        
        make.right.equalTo(self.iconView.mas_left).offset(-13);
        
        make.bottom.equalTo(self.backView).offset(-13);
    }];
    
    
    
}

- (void)setModel:(XMSystemMessageModel *)model
{
    _model = model;
    
    if (model.imgUrl.length > 5)
    {
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:model.imgUrl] placeholderImage:[UIImage imageNamed:@"weber"]];
        
//        self.messageLabel.text = model.pushmessage;
        
    }

        
    self.messageLabel.text = model.pushmessage;
    
//    self.timeLabel.text = model.createtime;
    //!< 对时间进行处理
    NSString *timeStr = model.createtime;
    
    if ([timeStr containsString:@"."])
    {
        //!< 如果包含"." 则说明带有毫秒，删掉毫秒部分
        NSRange range = [timeStr rangeOfString:@"."];
        
        timeStr = [timeStr substringToIndex:range.location];
        
        
        
    }
    
    
    
    self.timeLabel.text = timeStr;

    
    
    


}


@end
