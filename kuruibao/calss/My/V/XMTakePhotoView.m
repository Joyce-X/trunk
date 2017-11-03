//
//  XMTakePhotoView.m
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMTakePhotoView.h"

@interface XMTakePhotoView ()

@property (weak, nonatomic) IBOutlet UILabel *photoLabel;

@property (weak, nonatomic) IBOutlet UILabel *camerLabel;

@property (weak, nonatomic) IBOutlet UILabel *cancelLabel;

@end

@implementation XMTakePhotoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _photoLabel.text = JJLocalizedString(@"从相册选择", nil);
    
    _camerLabel.text = JJLocalizedString(@"拍照", nil);
    
    _cancelLabel.text = JJLocalizedString(@"取消", nil);


}

/**
 *  点击相册
 */
- (IBAction)clickAlbum:(id)sender {
    
    if(self.callBack)
    {
    
        self.callBack(1);
    
    }
    
}

//!< 点击拍照
- (IBAction)clickTakePhoto:(id)sender {
    
    if(self.callBack)
    {
        
        self.callBack(2);
        
    }
}

//!< 点击取消
- (IBAction)clickCancel:(id)sender {
    
    if(self.callBack)
    {
        
        self.callBack(3);
        
    }
}

@end
