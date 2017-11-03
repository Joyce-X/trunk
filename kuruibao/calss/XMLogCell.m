//
//  XMLogCell.m
//  kuruibao
//
//  Created by x on 17/9/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMLogCell.h"

@interface XMLogCell ()

/**
 显示日志信息
 */
@property (weak, nonatomic) UILabel *label;

@end


@implementation XMLogCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        UILabel *label = [UILabel new];
        
        label.numberOfLines = 0;
        
        [self.contentView addSubview:label];
        
        self.label = label;
        
    }

    return self;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.label.frame = CGRectMake(30, 15, mainSize.width - 60, self.bounds.size.height - 15);


}

- (void)setText:(NSString *)text
{
    _text = text;
    
    self.label.text = text;


}

@end
