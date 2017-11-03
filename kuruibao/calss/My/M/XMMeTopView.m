//
//  XMMeTopView.m
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMMeTopView.h"
#import "LDXScore.h"
#import "SXAnimateVIew.h"

#import "UIImageView+WebCache.h"

#import "XMUser.h"

#import "XMLoginNaviController.h"

#import "XMLoginViewController.h"

@interface XMMeTopView ()

@property (weak, nonatomic) IBOutlet UILabel *starLabel;//!< 显示几颗星的文字
@property (weak, nonatomic) IBOutlet LDXScore *starView;//!< 显示星星图片
@property (weak, nonatomic) IBOutlet SXAnimateVIew *polygonView;//!< 显示五边形
@property (weak, nonatomic) IBOutlet UIView *iconView;//!< 容器
@property (weak, nonatomic) UIImageView *iconImageView;//!< 显示头像
@property (weak, nonatomic) SXAnimateVIew *gradientView;//!< 渐变层

@property (weak, nonatomic) UILabel *scoreLabel;//!< 显示分数

@end

@implementation XMMeTopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.starView.isSelect = NO;
    
    self.starView.space = 4;
    //!< 添加头像
    UIImageView *imageView = [UIImageView new];
    
    imageView.layer.cornerRadius = 75/2.0;
    
    imageView.layer.masksToBounds = YES;
    
    imageView.layer.borderColor = XMWhiteColor.CGColor;
    
    imageView.layer.borderWidth = 1.25;
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.iconView addSubview:imageView];
    
    self.iconImageView = imageView;
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self.iconView);
        
    }];
    
    //!< 修改icon
    self.iconView.layer.cornerRadius = 75/2.0;
    
    self.iconView.layer.masksToBounds = YES;
    
    self.iconView.layer.borderColor = XMWhiteColor.CGColor;

     //!< 设置星星
    self.starView.normalImg = [UIImage imageNamed:@"star W"];
    
    self.starView.highlightImg = [UIImage imageNamed:@"star R"];
    
    self.starScore = 0;//!< 选中0颗星默认

    self.starView.max_star = 5;
    
    self.starView.isSelect = NO;
    
    //!< 设置五边形（白色）
    
    self.polygonView.subScore1 = 2.5;
    
    self.polygonView.subScore2 = 2.5;

    self.polygonView.subScore3 = 2.5;

    self.polygonView.subScore4 = 2.5;
 
    self.polygonView.subScore5 = 2.5;

    self.polygonView.isGradient = NO;
    
    self.polygonView.showType = 2;//描边
    
    self.polygonView.showWidtn = 2;
    
    self.polygonView.showColor = [UIColor colorWithWhite:1 alpha:0.4];
    
    //!< 添加外边（灰色）
    SXAnimateVIew *grayView = [SXAnimateVIew new];
    
    grayView.backgroundColor = XMClearColor;
    
    grayView.isGradient = NO;
    
    grayView.showColor = XMGrayColor;
    
    grayView.showType = 2;
    
    grayView.showWidtn = 1;
    
    grayView.subScore1 = 5;
    
    grayView.subScore2 = 5;
    
    grayView.subScore3 = 5;
    
    grayView.subScore4 = 5;
    
    grayView.subScore5 = 5;
    
    [self.polygonView addSubview:grayView];
    
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self.polygonView);
        
    }];
    
    
    //!< 添加分割线
    UIImageView *lineView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fb_five"]];
    
    [self.polygonView insertSubview:lineView atIndex:0];
    
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(self.polygonView);
        
    }];
    
    //!< 添加渐变层
    SXAnimateVIew *gradient = [SXAnimateVIew new];
    
    gradient.isGradient = YES;
    
    gradient.showWidtn = 1;
    
    gradient.subScore1 = 2.5;
    
    gradient.subScore2 = 2.5;
    
    gradient.subScore3 = 2.5;
    
    gradient.subScore4 = 2.5;
    
    gradient.subScore5 = 2.5;
    
    gradient.startColor = XMWhiteColor;
    
    gradient.endColor = XMGrayColor;
    
    gradient.showType = 1;
    
    gradient.backgroundColor = XMClearColor;
    
    [self.polygonView addSubview:gradient];
    
    self.gradientView = gradient;
    
    [gradient mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.top.right.bottom.equalTo(self.polygonView);
    }];
    
    //!< 添加label
    UILabel *label = [UILabel new];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.backgroundColor = XMClearColor;
    
    label.textColor = XMWhiteColor;
    
    label.font = [UIFont boldSystemFontOfSize:34];
     
    label.adjustsFontSizeToFitWidth = YES;
   
    [self.polygonView addSubview:label];
    
    self.scoreLabel = label;
    
    CGSize size = [@"100" sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:34]}];
    
    size.width = ceil(size.width);
    
    size.height = ceil(size.height);
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.center.equalTo(self.polygonView);
        
        make.size.equalTo(size);
    
        
    }];

}

#pragma mark ------- setter

//!< 设置几颗星  3.5 等级区分,100 分,颜色 1,五颗星;85-99 分,颜色 2,四颗星;75-84,颜色 3,三颗星;60-74,颜色 4,两颗星;60 分一下,颜 色 5,一颗星
- (void)setStarScore:(int)starScore
{
    
    self.starView.show_star = starScore;//!< 设置星星选中数量
    
    //!< 设置label显示内容 (此需求已被更改)
    
    /*
    NSString *text = [NSString stringWithFormat:@"%d-Star Driver",starScore];
    
    if (starScore == 0)
    {
        text = @"";
    }
    
    self.starLabel.text = text;
    */

}

//!< 设置行为得分
- (void)setScores:(NSArray *)scores
{
    
    
    if (scores == nil) {
        
        XMLOG(@"---------分数数组为空---------");
        return;
    }
    
    self.gradientView.subScore1 = [scores[0] intValue] / 40 + 2.5;
    
    self.gradientView.subScore2 = [scores[1] intValue] / 40 + 2.5;
    
    self.gradientView.subScore3 = [scores[2] intValue] / 40 + 2.5;
    
    self.gradientView.subScore4 = [scores[3] intValue] / 40 + 2.5;
    
    self.gradientView.subScore5 = [scores[4] intValue] / 40 + 2.5;
    
    _scoreLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    int average = ([scores[0] intValue] + [scores[1] intValue] + [scores[2] intValue] + [scores[3] intValue] + [scores[4] intValue])/5;
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",average];
    
    self.gradientView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [self.gradientView setNeedsDisplay];
    
    [UIView animateWithDuration:0.9 animations:^{
        
        self.gradientView.transform = CGAffineTransformIdentity;
        
        self.scoreLabel.transform = CGAffineTransformIdentity;
        
    }];
    
    
    //!< 设置星星数量 的逻辑
    /**
     *  100分-五颗星  85-99 ：四颗星  75-84： 三颗星  60-74： 两颗星  60以下：一颗星
     */
    if (average < 60)
    {
        [self setStarScore:1];
        
    }else if(average <= 74)
    {
        [self setStarScore:2];
    
    }else if(average <= 84)
    {
        [self setStarScore:3];
        
    }else if(average <= 99)
    {
        [self setStarScore:4];
        
    }else if(average == 100)
    {
        [self setStarScore:5];
        
    }

}

 
- (void)setUserDic:(NSDictionary *)userDic
{
    _userDic = userDic;
    
    if ([userDic[@"msg"] isEqualToString:@"用户不存在"])
    {
        XMLOG(@"---------数据库已经被你清空---------");
      
        [UIApplication sharedApplication].keyWindow.rootViewController = [[XMLoginNaviController alloc]initWithRootViewController:[XMLoginViewController new]];
        
        return;
        
    }
    
    //!<
    if([userDic[@"data"] isKindOfClass:[NSString class]])
    {
        
        
        [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"ddd"] placeholderImage:nil];
        return ;
        
    }
    
    NSArray *arr = userDic[@"data"];
    
    NSDictionary *dic = arr.firstObject;
    
    NSString *userImage = dic[@"userimage"];
    
    NSString *nickname = dic[@"nickname"];
    
 
    
     [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:userImage] placeholderImage:nil];
    
    //!< 对昵称为空时候进行处理
    if (nickname.length == 0)
    {
        nickname = [XMUser user].mobil;
    }
    
    
    //!< calculate the length of nickname, if length < 75,set alignment is center and update constrains
    // if length larger than 75, set alignment left,and update constranis
    
   CGSize size = [nickname sizeWithAttributes:@{NSFontAttributeName:self.userName.font}];
    
    if (size.width <= 75)
    {
        self.userName.textAlignment = NSTextAlignmentCenter;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
           
            make.width.equalTo(75);
            
        }];
        
        
    }else
    {
        self.userName.textAlignment = NSTextAlignmentLeft;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
            
//            make.right.equalTo(self.polygonView.mas_left).offset(-10);
            make.width.equalTo(FITWIDTH(200));
            
            make.left.equalTo(self.iconImageView);
            
        }];
    
    }
    
    self.userName.text = JJLocalizedString(nickname, nil);
    


}

- (void)setManager:(XMInfoManager *)manager
{
    
    _manager = manager;
    
    [self.iconImageView setImage:[UIImage imageWithData:manager.profileData]];
    
    //!< 对昵称为空时候进行处理
    if (manager.nickName.length == 0)
    {
        manager.nickName = [XMUser user].mobil;
    }
    
    //!< calculate the length of nickname, if length < 75,set alignment is center and update constrains
    // if length larger than 75, set alignment left,and update constranis
    
    CGSize size = [ manager.nickName sizeWithAttributes:@{NSFontAttributeName:self.userName.font}];
    
    if (size.width <= 75)
    {
        self.userName.textAlignment = NSTextAlignmentCenter;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(75);
            
        }];
        
        
    }else
    {
        self.userName.textAlignment = NSTextAlignmentLeft;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
            
            //            make.right.equalTo(self.polygonView.mas_left).offset(-10);
            make.width.equalTo(FITWIDTH(200));
            
            make.left.equalTo(self.iconImageView);
            
        }];
        
    }
    
    self.userName.text = JJLocalizedString( manager.nickName, nil);


}

- (void)setHeaderImage:(UIImage *)headerImage
{
    _headerImage = headerImage;
    
    self.iconImageView.image = headerImage;

}

- (void)setModel:(XMTrackScoreModel *)model
{
    _model = model;
    
    float score1 = model.xiguanscore.floatValue;
    float score2 = model.anquanscore.floatValue;
    float score3 = model.speedscore.floatValue;
    float score4 = model.huanbaoscore.floatValue;
    float score5 = model.ditanscore.floatValue;
    
    [self setScores:@[@(score1),@(score2),@(score3),@(score4),@(score5)]];



}

#pragma mark ------- click event

- (IBAction)clickIcon:(id)sender {
    
    XMLOG(@"---------click icon view---------");
    
    //!< 调用代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewProfileDidClick:)])
    {
        [self.delegate topViewProfileDidClick:self];
    }
    
    
}
- (IBAction)clickPolygon:(UITapGestureRecognizer *)sender {
    
    XMLOG(@"---------click polygon view---------");
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(topViewPentagonDidClick:)])
    {
        [self.delegate topViewPentagonDidClick:self];
    }
    
}

- (void)setNickName:(NSString *)nickName
{
    _nickName = nickName;
    
    CGSize size = [nickName sizeWithAttributes:@{NSFontAttributeName:self.userName.font}];
    
    if (size.width <= 75)
    {
        self.userName.textAlignment = NSTextAlignmentCenter;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(75);
            
        }];
        
        
    }else
    {
        self.userName.textAlignment = NSTextAlignmentLeft;
        
        [self.userName updateConstraints:^(MASConstraintMaker *make) {
            
            make.width.equalTo(FITWIDTH(200));
          
            
        }];
        
    }

    self.userName.text = nickName;


}


@end
