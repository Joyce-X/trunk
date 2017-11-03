//
//  XMChooseSexView.m
//  kuruibao
//
//  Created by x on 17/8/7.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMChooseSexView.h"

@interface XMChooseSexView ()


@property (weak, nonatomic) IBOutlet UILabel *maleLabel;
@property (weak, nonatomic) IBOutlet UILabel *femaleLabel;

@property (weak, nonatomic) IBOutlet UILabel *otherLabel;
@end


@implementation XMChooseSexView



- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _maleLabel.text = JJLocalizedString(@"男", nil);
    
    _femaleLabel.text = JJLocalizedString(@"女", nil);
    
    _otherLabel.text = JJLocalizedString(@"其他", nil);

}


- (IBAction)clickmale:(id)sender {
    
    if (self.callBack)
    {
        self.callBack(1);
    }
    
}



- (IBAction)clickFemale:(id)sender {
    
    if (self.callBack)
    {
        self.callBack(2);
    }
}



- (IBAction)clickOther:(id)sender {
    
    if (self.callBack)
    {
        self.callBack(3);
    }
}

@end
