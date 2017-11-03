//
//  XMScoreBottomView.m
//  kuruibao
//
//  Created by x on 17/8/17.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMScoreBottomView.h"


@interface XMScoreBottomView ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel1;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel2;

@property (weak, nonatomic) IBOutlet UILabel *scoreLabel3;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


//!< 显示count字段，外界可修改
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation XMScoreBottomView

- (void)setTitle:(NSString *)title
{
    _title = title;
    
    self.titleLabel.text = title;

}


- (void)setScore1:(NSString *)score1
{
    
    if (score1.length == 0)
    {
        score1 = @"0";
    }
    _score1 = score1;
    
    self.scoreLabel1.text = score1;


}

- (void)setScore2:(NSString *)score2
{
    
    if (score2.length == 0)
    {
        score2 = @"0";
    }
    
    _score2 = score2;
    
    self.scoreLabel2.text = score2;
    
    
}

- (void)setScore3:(NSString *)score3
{
    
    if (score3.length == 0)
    {
        score3 = @"0";
    }
    
    _score3 = score3;
    
    self.scoreLabel3.text = score3;
    
    
}

- (void)setImageName:(NSString *)imageName
{
    _imageName = imageName;
    
    self.imageView.image = [UIImage imageNamed:imageName];

}

- (void)setSecondLabelTitle:(NSString *)secondLabelTitle
{
    _secondLabelTitle = secondLabelTitle;
    
    _countLabel.text = secondLabelTitle;

    _countLabel.adjustsFontSizeToFitWidth = YES;

}


@end
