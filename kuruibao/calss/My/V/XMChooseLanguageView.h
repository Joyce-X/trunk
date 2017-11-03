//
//  XMChooseLanguageView.h
//  kuruibao
//
//  Created by x on 17/10/16.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>
//
typedef NS_ENUM (NSInteger,XMLanguageType){
    
    XMLanguageTypeAuto,
    XMLanguageTypeEnglish,
    XMLanguageTypeChinese
};

@class XMChooseLanguageView;

@protocol XMChooseLanguageViewDelegate <NSObject>

/**
 通知代理内部已进行选择

 @param view trigger
 @param index 选择的下标
 */
- (void)chooseLanguageView:(XMChooseLanguageView *)view didSelectedIndex:(NSUInteger)index;

@end

@interface XMChooseLanguageView : UIView


@property (weak, nonatomic) id<XMChooseLanguageViewDelegate> delegate;

/**
 设置当前语言

 @param type 语言枚举值
 */
- (void)setLanguage:(XMLanguageType)type;

@end
