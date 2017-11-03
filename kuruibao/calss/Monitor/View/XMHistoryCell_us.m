//
//  XMHistoryCell_us.m
//  kuruibao
//
//  Created by x on 17/7/31.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMHistoryCell_us.h"

@interface XMHistoryCell_us ()

/**
 时间
 */
@property (weak, nonatomic) UILabel *dateLabel;

/**
 内容
 */
@property (weak, nonatomic) UILabel *contentLabel;

/**
 分割线
 */
@property (weak, nonatomic) UIView *line;

@property (weak, nonatomic) UIView *backView;

@end

@implementation XMHistoryCell_us

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(instancetype)dequeueReusedCellWithTableView:(UITableView *)tableview
{
    
    XMHistoryCell_us *cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[XMHistoryCell_us alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
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
        
        timeLabel.backgroundColor = XMClearColor;
        
        timeLabel.textAlignment = NSTextAlignmentCenter;
        
        [self.contentView addSubview:timeLabel];
        
        self.dateLabel = timeLabel;
        
        
        UIView *line = [UIView new];
        
        line.backgroundColor = XMGrayColor;
        
        [self.contentView addSubview:line];
        
        self.line = line;
        
        
        UIView *view = [UIView new];
        
        view.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        
        [self.contentView addSubview:view];
        
        self.backView = view;
        
        UILabel *contentLabel = [UILabel new];
        
        contentLabel.backgroundColor = XMClearColor;
        
//        contentLabel.textAlignment = NSTextAlignmentCent;
        
        contentLabel.textColor = XMWhiteColor;
        
        contentLabel.font = [UIFont systemFontOfSize:16];
        
        contentLabel.numberOfLines = 0;
        
        [self.backView addSubview:contentLabel];
        
        self.contentLabel = contentLabel;
        
        
        
        
    }

    return self;

}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.contentView);
        
//        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(13));
        
        make.width.equalTo(80);
        
        make.height.equalTo(40);
        
        make.centerY.equalTo(self.contentView);
        
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.bottom.equalTo(self.contentView);
        
        make.right.equalTo(self.dateLabel);
        
         make.width.equalTo(1);
        
    }];

    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.line).offset(13);
        
        make.top.equalTo(self.contentView);
        
        make.bottom.equalTo(self.contentView).offset(-FITHEIGHT(8));

        make.right.equalTo(self.contentView).offset(-FITWIDTH(13));
        
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.equalTo(self.backView).offset(10);
        
        make.bottom.equalTo(self.backView).offset(-10);
        
        make.right.equalTo(self.backView).offset(-10);

        
        
    }];


}

- (void)setData:(NSDictionary *)data
{
    
    
    NSString *errorCode = data[@"errorcodeindex"];
    
    NSString *str = [errorCode stringByAppendingFormat:@" %@",data[@"codecontent"]];
    
    self.contentLabel.text = str;
    
    //!< 在显示事件的时候需要对时间字符串进行处理
    NSString *time = data[@"createtime"];

    //!< 时间字符串格式： 2016-12-15T19:39:54.25
    
    if(time.length < 10)
    {
        return;
        
    }
    
    NSString *month = [time substringWithRange:NSMakeRange(5, 2)];
    
    NSString *day = [time substringWithRange:NSMakeRange(8, 2)];
    
    XMLOG(@"---------%@-%@---------",month,day);
    
    NSString *result;
    
    switch (month.intValue) {
        case 1:
            result = @"Jan";
            break;
        case 2:
            result = @"Feb";
            break;
        case 3:
            result = @"Mar";
            break;
        case 4:
            result = @"Apr";
            break;
        case 5:
            result = @"May";
            break;
        case 6:
            result = @"Jun";
            break;
        case 7:
            result = @"Jul";
            break;
        case 8:
            result = @"Aug";
            break;
        case 9:
            result = @"Sep";
            break;
        case 10:
            result = @"Oct";
            break;
        case 11:
            result = @"Nov";
            break;
        case 12:
            result = @"Dec";
            break;
        
        default:
            
            result = month;
            break;
    }
    
    self.dateLabel.text = [NSString stringWithFormat:@"%@ %@",result,day];
    
}

@end
