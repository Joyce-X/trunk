//
//  XMScoreScrollView.m
//  kuruibao
//
//  Created by x on 17/8/17.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMScoreScrollView.h"
#import "XMScoreBottomView.h"

#define itemWidth 356/2
#define itemHeight 101

#define margin 13

#define columMargin 12

#define lineMargin 3

@interface XMScoreScrollView ()

@property (weak, nonatomic) XMScoreBottomView *view1;
@property (weak, nonatomic) XMScoreBottomView *view2;

@property (weak, nonatomic) XMScoreBottomView *view3;

@property (weak, nonatomic) XMScoreBottomView *view4;

@property (weak, nonatomic) XMScoreBottomView *view5;

@property (weak, nonatomic) XMScoreBottomView *view6;

@property (weak, nonatomic) XMScoreBottomView *view7;

@property (weak, nonatomic) XMScoreBottomView *view8;



@end

@implementation XMScoreScrollView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupSubviews];
        
        
    }
    return self;
}


- (void)setupSubviews
{
    
    UIScrollView *scroll = [UIScrollView new];
    
    scroll.showsHorizontalScrollIndicator = NO;
    
    //!< 计算宽度
    float width = (26 + 24 + 24 + 24 + 26 + 356 * 3 + 436)/2.0;
    
    scroll.contentSize = CGSizeMake(width, 0);
    
    scroll.frame = self.bounds;
    
    [self addSubview:scroll];
    
    //!< scroll添加子控件
    //!< 1
    XMScoreBottomView *view1 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view1.imageName = @"Rate of fuel used";
    
    view1.title = @"Rate of fuel used";
    
    view1.secondLabelTitle = @"gallon/mile";
    
    view1.frame = CGRectMake(margin, 0, itemWidth, itemHeight);
    
    [scroll addSubview:view1];
    
    self.view1 = view1;
    
    //!< 2
    XMScoreBottomView *view2 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view2.imageName = @"Total fuel used";
    
    view2.title = @"Total fuel used";
    
    view2.secondLabelTitle = @"gallon";
    
    view2.frame = CGRectMake(margin, itemHeight + lineMargin, itemWidth, itemHeight);
    
    [scroll addSubview:view2];
    
    self.view2 = view2;
    
    //!< 3
    XMScoreBottomView *view3 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view3.imageName = @"Total idle time";
    
    view3.title = @"Total idle time";
    
    view3.frame = CGRectMake(margin + (itemWidth + columMargin) * 1, 0, itemWidth, itemHeight);
    
    [scroll addSubview:view3];
    
    self.view3 = view3;
    
    //!< 4
    XMScoreBottomView *view4 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view4.imageName = @"Hard cornering";
    
    view4.title = @"Hard cornering";
    
    view4.frame = CGRectMake(margin + (itemWidth + columMargin) * 1, itemHeight + lineMargin, itemWidth, itemHeight);
    
    [scroll addSubview:view4];
    
    self.view4 = view4;
    
    //!< 5
    XMScoreBottomView *view5 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view5.imageName = @"Hard braking";
    
    view5.title = @"Hard braking";
    
    view5.frame = CGRectMake(margin + (itemWidth + columMargin) * 2, 0, itemWidth, itemHeight);
    
    [scroll addSubview:view5];
    
    self.view5 = view5;
    
    //!<6
    XMScoreBottomView *view6 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view6.imageName = @"Hard acceleration";
    
    view6.title = @"Hard acceleration";
    
    view6.frame = CGRectMake(margin + (itemWidth + columMargin) * 2, itemHeight + lineMargin, itemWidth, itemHeight);
    
    [scroll addSubview:view6];
    
    self.view6 = view6;
    
    //!< 7
    XMScoreBottomView *view7 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view7.imageName = @"Acceleration at corner";
    
    view7.title = @"Acceleration at corner";
    
    view7.frame = CGRectMake(margin + (itemWidth + columMargin) * 3, 0, 436/2, itemHeight);
    
    [scroll addSubview:view7];
    
    self.view7 = view7;
    
    //!< 8
    XMScoreBottomView *view8 = [[NSBundle mainBundle] loadNibNamed:@"ScoreBottomView" owner:nil options:nil
                                ].firstObject;
    
    view8.imageName = @"Frequent lane change";
    
    view8.title = @"Frequent lane change";
    
    view8.frame = CGRectMake(margin + (itemWidth + columMargin) * 3, lineMargin + itemHeight, 436/2, itemHeight);
    
    [scroll addSubview:view8];
    
    self.view8 = view8;
  
    
}

- (void)setModel:(XMTrackScoreModel *)model
{
    _model = model;
    
    //!< 开始设置数据 平均油耗
    self.view1.score1 = model.youhao100score;
//    self.view1.score2 = model.youhao100;
    self.view1.score2 = [XMUnitConvertManager convertLitreToGallonWithoutUnit:model.youhao100.floatValue];
    self.view1.score3 = model.youhao100no;
    
    [XMUnitConvertManager convertLitreToGallon:0];
    
    //!< 总油耗
    self.view2.score1 = model.penyouscore;
//    self.view2.score2 = model.penyou;
    self.view2.score2 = [XMUnitConvertManager convertLitreToGallonWithoutUnit:model.penyou.floatValue];

    self.view2.score3 = model.penyouno;
    
    //!< 怠速时长 对时间进行处理
    self.view3.score1 = model.daisuscore;
//    self.view3.score2 = model.daisutime;
    self.view3.score2 = [XMUnitConvertManager convertTimeToStandardFormat:model.daisutime.intValue];
    self.view3.score3 = model.daisuno;
    
    
    
    //!< 急转弯
    self.view4.score1 = model.jizhuanscore;
    self.view4.score2 = model.jizhuanwan;
    self.view4.score3 = model.jizhuanwanno;
    
    
    //!< 急刹车
    self.view5.score1 = model.jishachescore;
    self.view5.score2 = model.jishache;
    self.view5.score3 = model.jishacheno;
    
    
    
    //!< 急加油
    self.view6.score1 = model.jijiayouscore;
    self.view6.score2 = model.jijiayou;
    self.view6.score3 = model.jijiayouno;
    
    
    //!< 弯道加速
    self.view7.score1 = model.wandaojiasuscore;
    self.view7.score2 = model.wandaojiasu;
    self.view7.score3 = model.wandaojiasuno;
    
    
    
    //!< 频繁变道
    self.view8.score1 = model.pinfanbiandaoscore;
    self.view8.score2 = model.pinfanbiandao;
    self.view8.score3 = model.pinfanbiandaono;
    
    
    
    
}


 
@end
