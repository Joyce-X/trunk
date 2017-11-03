//
//  XMChoosePlaceView.h
//  kuruibao
//
//  Created by x on 17/8/22.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>


@class XMChoosePlaceView;

@protocol XMChoosePlaceViewDelegate <NSObject>

@optional
/**
 pickerView点击确定按钮

 @param picker trigger
 
 @param result 选择的结果，可能为空，代表没有选择（没有滚动picker）
 */
- (void)pickerViewClickOK:(XMChoosePlaceView*)picker result:(NSString *)result;

@required

- (NSInteger)numberOfRowsInComponent:(NSInteger)component inPicker:(UIPickerView *)picker;

- (NSString *)titleForRow:(NSInteger)row forComponent:(NSInteger)component inPicker:(UIPickerView *)picker;

- (void)didSelectRow:(NSInteger)row inComponent:(NSInteger)component inPicker:(UIPickerView *)picker;

@end

@interface XMChoosePlaceView : UIView


@property (weak, nonatomic) id<XMChoosePlaceViewDelegate> delegate;
/**
 调用显示方法

 @param view 父视图
 */
- (void)showInView:(UIView *)view;

@end
