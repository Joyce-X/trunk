//
//  XMTroubleCell_us.m
//  kuruibao
//
//  Created by x on 17/8/1.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMTroubleCell_us.h"

@interface XMTroubleCell_us ()

@property (weak, nonatomic) UIView  *backView;

@property (weak, nonatomic) UILabel *label;

@end

@implementation XMTroubleCell_us

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



+(instancetype)dequeueReusedCellWithTableView:(UITableView *)tableview
{
    
    XMTroubleCell_us *cell = [tableview dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil)
    {
        cell = [[XMTroubleCell_us alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
        
        UIView *backView = [UIView new];
        
        backView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
        
        [self.contentView addSubview:backView];
        
        self.backView = backView;
        
        self.backgroundColor = XMClearColor;
        
        UILabel *label = [UILabel new];
     
        label.font = [UIFont systemFontOfSize:15];
        
        label.textColor = XMWhiteColor;
        
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        
        self.label = label;
        
      
    }
    
    return self;
    
}



-(void)layoutSubviews
{
    [super layoutSubviews];
    
//    self.textLabel.frame = CGRectMake(15, 0, self.bounds.size.width - 30, self.bounds.size.height - 13);
    
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.right.bottom.top.equalTo(self.contentView);
        
    }];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.top.equalTo(_backView).offset(13);
        
        make.left.equalTo(_backView).offset(25);
        
        make.bottom.equalTo(_backView).offset(-13);
        
        make.right.equalTo(_backView).offset(-25);
        
    }];

    
}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;


}
@end
