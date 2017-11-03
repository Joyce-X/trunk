//
//  XMSet_helpViewController.m
//  kuruibao
//
//  Created by x on 16/9/12.
//  Copyright © 2016年 ChexXiaoMi. All rights reserved.
//

#import "XMSet_helpViewController.h"

@interface XMSet_helpViewController ()

@end

@implementation XMSet_helpViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupInit_help];
}


- (void)setupInit_help
{
//     self.message = @"帮助";
    
    [self.imageVIew removeFromSuperview];
    
    self.showBackArrow = YES;
    
    self.showBackgroundImage = YES;
    
    self.showTitle = YES;
    
    self.Title = JJLocalizedString(@"安装位置", nil);
  
    
    
    //-----------------------------seperate line---------------------------------------//
    //!< 添加图片
    
    UIImage *image = [UIImage imageNamed:@"showOBDPosition"];
   
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
    
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    if (mainSize.width == 320)
    {
        imageView.frame = CGRectMake(20, 120, mainSize.width-40,180);
        
    }else
    {
    
    imageView.frame = CGRectMake(20, 200, mainSize.width-40,180);
    
    }
    
    [self.view addSubview:imageView];
    
    NSString *title = @"A区域:通用、大众、福特、丰田、现代、雪铁龙、宝马等品牌的绝大部分车型\nB区域:本田、大众途安、进口雷克萨斯等车型\nC区域:东风雪铁龙、东风标致等少量车型\nD区域:东风雪铁龙等少量车型\nE区域:其他少量车型";
    
    
    title = @"Region A: Most of models of GM, Volkswagen, Ford, Toyota,Hyundai, Citreon, BMW, etc.\nRegion B: Most of models of Honda, Lexus, etc.\nRegion C: Some models of Cetreon, Peugeot, etc. \nRegion D: Some models of Cetreon, etc.\nRegion E: Some other models ";
    
    UILabel *label = [UILabel new];
    
    label.font = [UIFont systemFontOfSize:14];
    
    label.textColor = [UIColor whiteColor];
    
    label.text = @" ";
    
    label.backgroundColor = [UIColor clearColor];
    
    [self.view addSubview:label];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(15);
        
        make.top.equalTo(imageView.mas_bottom).offset(10);
        
        make.height.equalTo(3);
        
        make.width.equalTo(200);
        
        
    }];
    
    UITextView *textView = [UITextView new];
    
    textView.font = [UIFont systemFontOfSize:14];
    
    textView.backgroundColor = [UIColor clearColor];
    
//    textView.userInteractionEnabled = NO;
    textView.editable = NO;
    
    textView.selectable = NO;
    
    textView.showsVerticalScrollIndicator = NO;
    
    textView.textAlignment = NSTextAlignmentLeft;
    
    [self.view addSubview:textView];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    
    paragraphStyle.lineSpacing = 8;// 字体的行间距
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:[UIColor whiteColor]
                                 
                                 };
    textView.attributedText = [[NSAttributedString alloc] initWithString:title attributes:attributes];
    
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.left.equalTo(self.view).offset(15);
        
        make.right.equalTo(self.view).offset(-15);
        
        make.bottom.equalTo(self.view);
        
        make.top.equalTo(label.mas_bottom).offset(2);
        
    }];
    
    
    
    

    
    
}
@end
