//
//  XMmanageCell.m
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMmanageCell.h"

@interface XMmanageCell ()

@property (weak, nonatomic) UIImageView *headerIV;//!< 头像
@property (weak, nonatomic) UILabel *label1;//!< 文字一
@property (weak, nonatomic) UILabel *label2;//!< 文字2
@property (weak, nonatomic) UIImageView *arrowIV;//!< 箭头
@property (weak, nonatomic) UIImageView *separaLineIV;//!< 分割线


@end

@implementation XMmanageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)dequeueResuableCellWithTableView:(UITableView *)tableView
{
    static NSString *identifier = @"cell";
    
    XMmanageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        cell = [[XMmanageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    return cell;
    
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.backgroundColor = XMAlphaColor;
        
         //!< 头像
        UIImageView *headerIV = [[UIImageView alloc]init];
        
        [self.contentView addSubview:headerIV];
        
        self.headerIV = headerIV;
        
        [headerIV mas_makeConstraints:^(MASConstraintMaker *make) {
           
            make.centerY.equalTo(self);
            
            make.size.equalTo(CGSizeMake(17, 17));
            
            make.left.equalTo(self).offset(13);
            
        }];
        
         //!< label1
        UILabel *label1 = [UILabel new];
        
        label1.textColor = XMGrayColor;
        
        label1.font = [UIFont systemFontOfSize:15];
        
        [self.contentView addSubview:label1];
        
        self.label1 = label1;
        
        [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self);
            
            make.width.equalTo(250);
            
            make.left.equalTo(headerIV.mas_right).offset(15);
            
        }];
        
        //!< 箭头
        UIImageView *arrowIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
        
        [self.contentView addSubview:arrowIV];
        
        self.arrowIV = arrowIV;
        
        [arrowIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self);
            
            make.size.equalTo(CGSizeMake(12, 17));
            
            make.right.equalTo(self).offset(-20);
            
        }];
        
         //!< label2
        
        UILabel *label2 = [UILabel new];
        
        label2.textColor = XMGrayColor;
        
        label2.font = [UIFont systemFontOfSize:15];
        
        label2.textAlignment = NSTextAlignmentRight;
        
        [self.contentView addSubview:label2];
        
        self.label2 = label2;
        
        [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.bottom.equalTo(self);
            
            make.width.equalTo(250);
            
            make.right.equalTo(arrowIV.mas_left).offset(-15);
            
        }];

         //!< 分割线
        UIImageView *separateIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Login_line"]];
        
        [self.contentView addSubview:separateIV];
        
        separateIV.hidden = YES;
        
        self.separaLineIV = separateIV;
        
        [separateIV mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.bottom.right.equalTo(self);
            
            make.height.equalTo(1);
            
        }];
        
    }
    
    return self;
  
    
}

 - (void)setShowLine:(BOOL)showLine
{
    _showLine = showLine;
    
    self.separaLineIV.hidden = showLine;


}

- (void)setCarImage:(UIImage *)carImage
{

    _carImage = carImage;
    
    self.headerIV.image =carImage;

}

- (void)setText1:(NSString *)text1
{
    _text1 = text1;
    
    self.label1.text = text1;

}

- (void)setText2:(NSString *)text2
{
    _text2 = text2;
    
    self.label2.text = text2;
    
}

- (void)setIsDefasult:(BOOL)isDefasult
{
    _isDefasult = isDefasult;
    
    if (isDefasult)
    {
        //!< 修改文字颜色
        self.label1.textColor = XMWhiteColor;
        
        self.label2.textColor = XMWhiteColor;
        
    }


}

@end
