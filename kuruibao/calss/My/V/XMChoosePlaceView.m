//
//  XMChoosePlaceView.m
//  kuruibao
//
//  Created by x on 17/8/22.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMChoosePlaceView.h"


@interface XMChoosePlaceView ()<UIPickerViewDataSource,UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;



@end


@implementation XMChoosePlaceView


-(void)awakeFromNib
{
    [super awakeFromNib];
    
    //!< 配置
    self.pickerView.dataSource = self;
    
    self.pickerView.delegate = self;


}



/**
 *  点击确定按钮
 */
- (IBAction)clickOK:(id)sender {
    
    [self clickWhiteSpace:nil];
    
    if (self.delegate )
    {
        [self.delegate pickerViewClickOK:self result:nil];
    }
    
    
    
}

/**
 *  点击空白处
 */
- (IBAction)clickWhiteSpace:(id)sender {
    
    //!< 动画取消
    [UIView animateWithDuration:0.2 animations:^{
        self.y = 250;
        
    } completion:^(BOOL finished) {
        
        [self removeFromSuperview];
        
    }];
    
    
    
}

- (void)showInView:(UIView *)view
{
    self.frame = CGRectMake(0, 250, mainSize.width, mainSize.height);
    
    [view addSubview:self];
    
    [UIView animateWithDuration:0.2 animations:^{
       
        self.y = 0;
        
    }];


}

#pragma mark ------- UIPickerViewDataSource
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    
    return 2;

}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInComponent:inPicker:)])
    {
       return  [self.delegate numberOfRowsInComponent:component inPicker:pickerView];
        
    }else
    {
    
        return 0;
        
    }

}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(titleForRow:forComponent:inPicker:)])
    {
        
      return  [self.delegate titleForRow:row forComponent:component inPicker:pickerView];
        
    }else
    {
    
        return @"---";
        
    }
    
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectRow:inComponent:inPicker:)])
    {
        [self.delegate didSelectRow:row inComponent:component inPicker:pickerView];
    }
    

}

@end
