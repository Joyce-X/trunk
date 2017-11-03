//
//  XMMapCustomCalloutView.m
//  kuruibao
//
//  Created by x on 16/11/27.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

/**********************************************************
 class description:自定义弹出气泡
 
 **********************************************************/

#import "XMMapCustomCalloutView.h"

#define kArrorHeight        10
#define kPortraitMargin     5
#define kPortraitWidth      70
#define kPortraitHeight     70

#define kTitleWidth         120
#define kTitleHeight        20

@interface XMMapCustomCalloutView ()

@property (nonatomic, strong) UIImageView *portraitView;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *titleLabel;
//@property (nonatomic, strong) UILabel *timeLabel;


@property (strong, nonatomic) UILabel *carnumberLabel;//!< 显示车牌
@property (strong, nonatomic) UILabel *carStateLabel;//!< 显示状态
@property (strong, nonatomic) UILabel *driverLabel;//!< 显示司机名称
@property (strong, nonatomic) UILabel *timeLabel;//!< 显示车牌



@end
@implementation XMMapCustomCalloutView


- (void)drawRect:(CGRect)rect {
    
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor =  [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    
}

- (void)drawInContext:(CGContextRef)context
{
    
    CGContextSetLineWidth(context, 2.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:0.8].CGColor);
//    CGContextSetFillColorWithColor(context, XMGreenColor.CGColor);
    
    
    [self getDrawPath:context];
    CGContextFillPath(context);
    
}

- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews
{
    // 添加图片，即商户图
    self.portraitView = [[UIImageView alloc] initWithFrame:CGRectMake(6, (85-33)/2, 33, 33)];
    
    self.portraitView.backgroundColor = [UIColor clearColor];
    
    self.portraitView.layer.borderColor = XMWhiteColor.CGColor;
    
    self.portraitView.layer.borderWidth = 1;
    
    [self addSubview:self.portraitView];
    
    self.carnumberLabel = [self createLabelWithFrame:CGRectMake(45, 12, 110, 13)];
    
    self.carStateLabel = [self createLabelWithFrame:CGRectMake(160, 12, 90, 13)];
    
    self.driverLabel = [self createLabelWithFrame:CGRectMake(45, 36, 170, 13)];
    
    self.timeLabel = [self createLabelWithFrame:CGRectMake(45, 60, 200, 13)];
    
    //!< 添加右边的箭头
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"next"]];
    
    [self addSubview:imageView];
    
    imageView.frame = CGRectMake(250-13-12, (85-18)/2, 12, 18);
    
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap:)];
    
    [self addGestureRecognizer:tap];
    
//    // 添加标题，即商户名
//    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin, kTitleWidth, kTitleHeight)];
//    self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
//    self.titleLabel.textColor = [UIColor whiteColor];
//    self.titleLabel.text = @"title";
//    [self addSubview:self.titleLabel];
//    
//    // 添加副标题，即商户地址
//    self.subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 3 + kTitleHeight * 2, kTitleWidth, kTitleHeight)];
//    self.subtitleLabel.font = [UIFont systemFontOfSize:12];
//    self.subtitleLabel.textColor = [UIColor whiteColor];
//    self.subtitleLabel.text = @"subtitle";
//    [self addSubview:self.subtitleLabel];
//    
//    // 添加时间
//    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitMargin * 2 + kPortraitWidth, kPortraitMargin * 2 + kTitleHeight, kTitleWidth + 20, kTitleHeight)];
//    self.timeLabel.font = [UIFont systemFontOfSize:12];
//    self.timeLabel.textColor = [UIColor whiteColor];
//    self.timeLabel.text = @"time";
//    [self addSubview:self.timeLabel];
    
    
    
    
    
}

//- (void)setTitle:(NSString *)title
//{
//    self.titleLabel.text = title;
//    _title = title;
//}
//
//- (void)setSubtitle:(NSString *)subtitle
//{
//    if (subtitle.length < 2)
//    {
//        subtitle = @"暂无";
//    }
//    self.subtitleLabel.text = subtitle;
//    
//    _subtitle = subtitle;
//}
//
- (void)setImage:(UIImage *)image
{
    self.portraitView.image = image;
    _image = image;
}
//
//-(void)setTime:(NSString *)time
//{
//    
//    if ([time containsString:@"T"])
//    {
//      time = [time stringByReplacingOccurrencesOfString:@"T" withString:@" "];
//    }
//    
//    if (time.length < 2)
//    {
//        time = @"暂无";
//    }
//
//    
//    self.timeLabel.text = time;
//    _time = time;
//}


- (UILabel *)createLabelWithFrame:(CGRect)frame
{
    UILabel *label = [[UILabel alloc]initWithFrame:frame];
    
    label.textColor = XMWhiteColor;
    
    label.font = [UIFont systemFontOfSize:13];
    
    [self addSubview:label];
    
    return label;
    
    
    
    
}

#pragma mark ------- setter

- (void)setCarNumber:(NSString *)carNumber
{
    _carNumber = carNumber;
    
    self.carnumberLabel.text = carNumber;
}

- (void)setState:(NSString *)state
{
    _state = state;
    
    self.carStateLabel.text = [NSString stringWithFormat:@"State: %@",state];

}

- (void)setDriver:(NSString *)driver
{
    _driver = driver;
    
    self.driverLabel.text = [NSString stringWithFormat:@"Driver: %@",driver];

}

-(void)setLastTime:(NSString *)lastTime
{
    
    lastTime = [lastTime stringByReplacingOccurrencesOfString:@"T" withString:@" "];
    
    _lastTime = lastTime;
    
    self.timeLabel.text = lastTime;

}

- (void)tap:(UITapGestureRecognizer *)sender
{
    
        XMLOG(@"---------tap click---------");

}


@end
