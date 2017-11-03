//
//  XMTrackScoreViewController.m
//  kuruibao
//
//  Created by x on 16/12/2.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//


/**********************************************************
 class description:显示驾驶评分的控制器
 
 **********************************************************/

#import "XMTrackScoreViewController.h"
#import "SXAnimateVIew.h"
#import "XMRankView.h"
#import "AFNetworking.h"
#import "NSDictionary+convert.h"
#import "XMTrackScoreModel.h"
//#import <ShareSDK/ShareSDK.h>
#import "XMScoreScrollView.h"
 #import "XMShareView.h"
//#import <FBSDKShareKit/FBSDKShareKit.h>

//#import <TwitterKit/TwitterKit.h>
//#import <ShareSDKUI/ShareSDK+SSUI.h>

//#import "WXApi.h"

@interface XMTrackScoreViewController ()<UITableViewDelegate,XMShareViewDelegate,UIDocumentInteractionControllerDelegate>

@property (nonatomic,weak)SXAnimateVIew* fillView;//!< 填充显示平均值组成的View

//@property (nonatomic,weak)XMRankView* averageView;//!< 平均油耗
//
//@property (nonatomic,weak)XMRankView* totalOil;//!< 总油耗
//
//@property (nonatomic,weak)XMRankView* zhuanWan;//!< 急转弯
//
//@property (nonatomic,weak)XMRankView* shaChe;//!< 急刹车
//
//@property (nonatomic,weak)XMRankView* daiSu;//!< 怠速
//
//@property (nonatomic,weak)XMRankView* jiayou;//!< 急加油
//
//@property (nonatomic,weak)XMRankView* bianDao;//!< 变道
//
//@property (nonatomic,weak)XMRankView* wanDao;//!< 弯道加速

@property (nonatomic,weak)UILabel* scoreLabel;//!< 显示平均分

//@property (nonatomic,weak)UIView* shareView;
//
//@property (strong, nonatomic) UIImage *shareImage;

@property (weak, nonatomic) SXAnimateVIew *gradientView;

@property (weak, nonatomic) XMScoreScrollView *scroll;//!< 底部滑动的视图

@property (strong, nonatomic) XMShareView *shareView;

//@property (strong, nonatomic) UIImage *shareImage;//!< 需要分享的图片
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;


@end

@implementation XMTrackScoreViewController




- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupInit];
    
    
}



- (void)setupInit
{
    
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"驾驶得分", nil);
  
    //!< 背景
    UIImageView *backIV = [self.view viewWithTag:7777];
    
 
    
    //-----------------------------seperate line---------------------------------------//
    //!< 添加分享按钮
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [shareBtn setImage:[UIImage imageNamed:@"Share icon"] forState:UIControlStateNormal];
    
    [shareBtn addTarget:self action:@selector(shareBtnDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:shareBtn];
    
    [shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).offset(53);
        
        make.right.equalTo(self.view).offset(-25);
        
        make.size.equalTo(CGSizeMake(35, 36));
        
    }];
    
    if (!iOS10)
    {
        shareBtn.hidden = YES;
    }
    
    //-----------------------------seperate line---------------------------------------//
    
    //!< 添加灰色五边形边框
    
    SXAnimateVIew *borderView = [SXAnimateVIew new];
    
    borderView.backgroundColor = [UIColor clearColor];
    
    borderView.subScore1 = 5;
    borderView.subScore2 = 5;
    borderView.subScore3 = 5;
    borderView.subScore4 = 5;
    borderView.subScore5 = 5;
    
    borderView.showColor = XMGrayColor;
    
    borderView.showType = 2;
    
    borderView.showWidtn = 1;
    
    [self.view addSubview:borderView];
    
    [borderView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(FITHEIGHT(170), FITHEIGHT(170)));
        
        make.centerX.equalTo(backIV);
        
        if (iOS10)
        {
              make.top.equalTo(self.view).offset(FITHEIGHT(170));
        }else
        {
            
              make.top.equalTo(self.view).offset(FITHEIGHT(145));
            
        }
        
      
        
    }];
    
    
    UIImageView *iv = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"fb_five"]];
    
    [borderView addSubview:iv];
    
    [iv mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.top.right.bottom.equalTo(borderView);
        
    }];
    
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
    
    [borderView addSubview:grayView];
    
    [grayView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.top.right.bottom.equalTo(borderView);
        
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
    
    [borderView addSubview:gradient];
    
    self.gradientView = gradient;
    
    [gradient mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.bottom.equalTo(borderView);
    }];
    
    //!< 添加分数
    
    UILabel *label = [[UILabel alloc]init];
    
    label.text = @"0";
    
    label.textColor = [UIColor whiteColor];
    
    label.textAlignment = NSTextAlignmentCenter;
    
    label.font = [UIFont fontWithName:@"Helvetica" size:48];
    
    [self.view addSubview:label];
    
    self.scoreLabel = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.size.equalTo(CGSizeMake(90, 90));
        
        make.center.equalTo(borderView);
        
    }];
    
    
    //-----------------------------seperate line---------------------------------------//
    //!< 添加label
    //!<  驾驶习惯
    UILabel *customLabel = [UILabel new];
    
    customLabel.font = [UIFont boldSystemFontOfSize:12];
    
    customLabel.text = JJLocalizedString(@"驾驶习惯", nil);
    
    customLabel.textAlignment = NSTextAlignmentCenter;
    
    customLabel.textColor = XMGrayColor;
    
    [self.view addSubview:customLabel];
    
    [customLabel mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.centerX.equalTo(borderView);
        
        make.height.equalTo(15);
        
        make.bottom.equalTo(borderView.mas_top).offset(-10);
        
        make.width.equalTo(150);
        
    }];
    
    //!<  行车安全
    UILabel *safeLabel = [UILabel new];
    
    safeLabel.font = [UIFont boldSystemFontOfSize:12];
    
    safeLabel.text = JJLocalizedString(@"安全驾驶", nil);
    
    safeLabel.textAlignment = NSTextAlignmentRight;
    
    safeLabel.textColor = XMGrayColor;
    
    [self.view addSubview:safeLabel];
    
    [safeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(borderView).offset(-20);
        
        make.height.equalTo(15);
        
        make.right.equalTo(borderView.mas_left).offset(-10);
        
        make.width.equalTo(150);
        
    }];
    
    //!<  行车速度
    UILabel *speedLabel = [UILabel new];
    
    speedLabel.font = [UIFont boldSystemFontOfSize:12];
    
    speedLabel.text = JJLocalizedString(@"行车速度", nil);
    
    speedLabel.textAlignment = NSTextAlignmentRight;
    
    speedLabel.textColor = XMGrayColor;
    
    [self.view addSubview:speedLabel];
    
    [speedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(borderView.left).offset(43);
        
        make.height.equalTo(15);
        
        make.top.equalTo(borderView.mas_bottom).offset(-2);
        
        make.width.equalTo(150);
        
    }];
    
    //!<  环保出行
    UILabel *footLabel = [UILabel new];
    
    footLabel.font = [UIFont boldSystemFontOfSize:12];
    
    footLabel.text = JJLocalizedString(@"环保出行", nil);
    
    footLabel.textAlignment = NSTextAlignmentLeft;
    
    footLabel.textColor = XMGrayColor;
    
    [self.view addSubview:footLabel];
    
    [footLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(borderView.mas_right).offset(-40);
        
        make.height.equalTo(15);
        
        make.top.equalTo(speedLabel);
        
        make.width.equalTo(150);
        
    }];
    
    //!<  低碳生活
    UILabel *lifeLabel = [UILabel new];
    
    lifeLabel.font = [UIFont boldSystemFontOfSize:12];
    
    lifeLabel.text = JJLocalizedString(@"低碳生活", nil);
    
    lifeLabel.textAlignment = NSTextAlignmentLeft;
    
    lifeLabel.textColor = XMGrayColor;
    
    [self.view addSubview:lifeLabel];
    
    [lifeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(borderView.mas_right).offset(10);
        
        make.height.equalTo(15);
        
        make.top.equalTo(safeLabel);
        
        make.width.equalTo(150);
        
    }];
    
  
    //!< 添加底部滑动视图
    XMScoreScrollView *scroll = [[XMScoreScrollView alloc]initWithFrame:CGRectMake(0, mainSize.height - FITHEIGHT(59) - 208, mainSize.width, 208)];
    
    
    [self.view addSubview:scroll];
    
    self.scroll = scroll;
    
    [self setDataWithDictionary:self.model];
    
}



//!< 获取成功之后进行数据展示
- (void)setDataWithDictionary:(XMTrackScoreModel *)model
{
    
     float score1 = model.xiguanscore.floatValue;
    float score2 = model.anquanscore.floatValue;
    float score3 = model.speedscore.floatValue;
    float score4 = model.huanbaoscore.floatValue;
    float score5 = model.ditanscore.floatValue;
    
    int average = (score1 + score2 + score3 + score4 + score5)/5;
    
    _scoreLabel.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    self.scoreLabel.text = [NSString stringWithFormat:@"%d",average];
    
    _gradientView.subScore1 = score1/40.0 + 2.5;
    _gradientView.subScore2 = score2/40.0 + 2.5;
    _gradientView.subScore3 = score3/40.0 + 2.5;
    _gradientView.subScore4 = score4/40.0 + 2.5;
    _gradientView.subScore5 = score5/40.0 + 2.5;
    
    _gradientView.transform = CGAffineTransformMakeScale(0.1, 0.1);
    
    [_gradientView setNeedsDisplay];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        _gradientView.transform = CGAffineTransformIdentity;
        
        _scoreLabel.transform = CGAffineTransformIdentity;
        
    }];
    
    self.scroll.model = model;

}

#pragma mark -------------- 按钮点击事件

- (void)shareBtnDidClick
{
    
    
        NSString* savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.png"];
        
        [UIImageJPEGRepresentation([self getShareImage], 1.0) writeToFile:savePath atomically:YES];
        
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
        
        _documentInteractionController.UTI = @"net.whatsapp.image";
        
        _documentInteractionController.delegate = self;
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
        
    
    return;
    
//    XMLOG(@"---------click share btn---------");
//    if (self.shareView == nil)
//    {
//        self.shareView = [[NSBundle mainBundle] loadNibNamed:@"XMShareView" owner:nil options:nil].firstObject;
//        
//        self.shareView.delegate = self;
//        
//        [self.view addSubview:self.shareView];
//        
//        UIImage *image = [UIImage imageNamed:@"defaultImage.jpg"];
//        
//        FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc]init];
//        
//        photo.image = image;
//        
//        photo.userGenerated = YES;
//        
//        FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc]init];
//        
//        content.photos = @[photo];
//        
//        FBSDKShareButton *button = (FBSDKShareButton *)[self.shareView viewWithTag:10];
//    
//        button.shareContent = content;
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Facebook"] forState:UIControlStateNormal];
//        
//        [button setBackgroundImage:[UIImage imageNamed:@"Facebook"] forState:UIControlStateHighlighted];
//
//        [button.titleLabel removeFromSuperview];
//        
//        [button setImage:nil forState:UIControlStateHighlighted];
//        
//        [button setImage:nil forState:UIControlStateNormal];
//        
//    }
//    
    [self.shareView animateToShow];
    
    
    
}

#pragma mark ------- XMShareViewDelegate
//- (void)shareViewClickFacebook:(XMShareView *)view
//{
//    XMLOG(@"---------shareViewClickFacebook---------");
////    [self shareWithType:SSDKPlatformTypeFacebook];
//    UIImage *image = [UIImage imageNamed:@"defaultImage.jpg"];
//    
//    FBSDKSharePhoto *photo = [[FBSDKSharePhoto alloc]init];
//    
//    photo.image = image;
//    
//    photo.userGenerated = YES;
//    
//    FBSDKSharePhotoContent *content = [[FBSDKSharePhotoContent alloc]init];
//    
//    content.photos = @[photo];
//    
//    FBSDKShareButton *button = [[FBSDKShareButton alloc] init];
//    
//    button.frame = CGRectMake(100, 100, 100, 100);
//    
//    button.shareContent = content;
//    
//    [button.imageView removeFromSuperview];
//    
//    [button.titleLabel removeFromSuperview];
//    
//    button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
//    
//    [self.view addSubview:button];
//    
////    [FBSDKShareDialog showFromViewController:self withContent:content delegate:nil];弹出提示框进行分享
//    
//   
//    
//    
//    
//}
- (void)shareViewClickTwitter:(XMShareView *)view
{
    
//    [self shareWithType:SSDKPlatformTypeTwitter];
    
    XMLOG(@"---------shareViewClickTwitter---------");
    
//    [[TWTRAPIClient clientWithCurrentUser] sendTweetWithText:@"Joyce" image:[UIImage imageNamed:@"defaultImage.jpg"] completion:^(TWTRTweet * _Nullable tweet, NSError * _Nullable error) {
//       
//        XMLOG(@"---------%@---------",error);
//        
//    }];

    
//    TWTRComposer *composer = [TWTRComposer new];
//    
//    BOOL a = [composer setImage:[self getShareImage]];
//    
//    [composer showFromViewController:self completion:^(TWTRComposerResult result) {
//       
//        if (result == TWTRComposerResultCancelled)
//        {
//            XMLOG(@"---------Twitter分享取消---------");
//        }else
//        {
//            
//            XMLOG(@"---------Twitter分享成功---------");
//        
//        }
//        
//    }];
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
- (void)shareViewClickWhatsapp:(XMShareView *)view
{
    
//    [self shareWithType:SSDKPlatformTypeWhatsApp];
    XMLOG(@"---------shareViewClickWhatsapp---------");
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"whatsapp://"]])
    {
        NSString    * savePath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/whatsAppTmp.png"];
        
        [UIImageJPEGRepresentation([self getShareImage], 1.0) writeToFile:savePath atomically:YES];
        
        _documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:[NSURL fileURLWithPath:savePath]];
       
        _documentInteractionController.UTI = @"net.whatsapp.image";
        
        _documentInteractionController.delegate = self;
        
        [_documentInteractionController presentOpenInMenuFromRect:CGRectMake(0, 0, 0, 0) inView:self.view animated: YES];
        
        
    }else
    {
        
//        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"WhatsApp not installed." message:@"Your device has no WhatsApp installed." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        
//        [alert show];
    
    }
    
}



//!< 获取截屏
- (UIImage *)getShareImage
{
    
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, 0);
    
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
//    float x = 0;
//    float y = 80 * [UIScreen mainScreen].scale;
//    float w = image.size.width * [UIScreen mainScreen].scale;
//    float h = image.size.height  * [UIScreen mainScreen].scale - y;
//    CGImageRef cut = CGImageCreateWithImageInRect(image.CGImage, CGRectMake(x, y, w, h));
//    
//    UIImage *result = [UIImage imageWithCGImage:cut];
//    
//    CFRelease(cut);
    
    return image;



}



#pragma mark -------------- system

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;

}

@end
