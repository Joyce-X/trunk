//
//  XMAnimateCell.m
//  kuruibao
//
//  Created by x on 17/7/29.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMAnimateCell.h"

@implementation XMAnimateCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}
+ (instancetype)dequeueReusedCellWithTableView:(UITableView *)tableView
{
    XMAnimateCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if ( cell == nil)
    {
        cell = [[XMAnimateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    
    return cell;

}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        
        
        self.backgroundColor = XMClearColor;
        
        self.textLabel.textColor = XMWhiteColor;
        
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        
        self.textLabel.font = [UIFont systemFontOfSize:13];
        
        self.textLabel.numberOfLines = 0;
        
        
    }

    return self;

}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.textLabel.frame = CGRectMake(15, 0, self.bounds.size.width - 30, self.bounds.size.height);


}


@end
