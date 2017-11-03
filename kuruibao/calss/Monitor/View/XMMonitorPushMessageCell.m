//
//  XMMontorPushMessageCell.m
//  kuruibao
//
//  Created by x on 16/12/12.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMMonitorPushMessageCell.h"

@interface XMMonitorPushMessageCell()




/**
 显示0.1白色背景
 */
@property (nonatomic,weak)UIView* backView;



/**
 显示图标
 */
@property (weak, nonatomic) UIImageView *iconView;

@end

@implementation XMMonitorPushMessageCell

+(instancetype)dequeueReuseableCellWithTableView:(UITableView *)tableView
{
    static NSString * identifier = @"identifier_pushMessage";
    
    XMMonitorPushMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[XMMonitorPushMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
//
        //!< icon
        UIImageView *iconView = [[UIImageView alloc]init];
        
        
        iconView.image = [UIImage imageNamed:@"us_home_message_icon_nomal"];
        
        
        
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
        
//        messageLabel.backgroundColor = XMRedColor;
    }

    return self;

}

- (void)layoutSubviews
{

    [super layoutSubviews];
    
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self).offset(13);
        
        make.height.equalTo(20);
        
        make.width.equalTo(220);
        
    }];
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.equalTo(self);
        
        make.top.equalTo(self.timeLabel.mas_bottom).offset(8);
        
     }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(17, 14));
        
        make.centerY.equalTo(self.backView);
        
        make.left.equalTo(self.backView).offset(13);
        
        
    }];
    
    [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(self.backView).offset(13);
        
        make.left.equalTo(self.iconView.mas_right).offset(13);
        
        make.right.bottom.equalTo(self.backView).offset(-13);
        
        
        
    }];
    
    

}
//#error log下一句崩溃
- (void)setModel:(XMMessageModel *)model
{
    _model = model;
    
    _messageLabel.text = model.message;

//    //!< 将时间分离出来
//    NSRange range = [pushMessage rangeOfString:@"时间:"];
//    
//    XMLOG(@"---------%@---------",pushMessage);
//    
//    NSString *time = [pushMessage substringWithRange:NSMakeRange(range.location + range.length, 16)];
//    
//    
//    //!< 改造时间
//    NSArray *arr = [time componentsSeparatedByString:@"/"];
//    
//    NSString *year = arr.firstObject;
//    
//    NSString *month = arr[1];
//    
//    NSString *day = arr.lastObject;//!< 日 + 具体时间
//    
//    NSString *result;
//    
//    switch (month.intValue) {
//        case 1:
//            result = @"Jan";
//            break;
//        case 2:
//            result = @"Feb";
//            break;
//        case 3:
//            result = @"Mar";
//            break;
//        case 4:
//            result = @"Apr";
//            break;
//        case 5:
//            result = @"May";
//            break;
//        case 6:
//            result = @"Jun";
//            break;
//        case 7:
//            result = @"Jul";
//            break;
//        case 8:
//            result = @"Aug";
//            break;
//        case 9:
//            result = @"Sep";
//            break;
//        case 10:
//            result = @"Oct";
//            break;
//        case 11:
//            result = @"Nov";
//            break;
//        case 12:
//            result = @"Dec";
//            break;
//            
//        default:
//            
//            result = month;
//            break;
//    }
//    
//    NSString *showText = [NSString stringWithFormat:@"%@-%@-%@",year,result,day];
    
    //!< 对时间进行处理
    NSString *timeStr = model.happentime;
    
    if ([timeStr containsString:@"."])
    {
        //!< 如果包含"." 则说明带有毫秒，删掉毫秒部分
        NSRange range = [timeStr rangeOfString:@"."];
        
        timeStr = [timeStr substringToIndex:range.location];
        
        
        
    }
    
    
    
    self.timeLabel.text = timeStr;


}



- (void)setType:(BOOL)type
{

    _type = type;
    
    if (type)
    {
        self.iconView.image = [UIImage imageNamed:@"us_home_message_AD"];
    }

}






@end
