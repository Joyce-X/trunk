//
//  XMCompany_section0_view.m
//  kuruibao
//
//  Created by x on 17/5/25.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import "XMCompany_section0_view.h"

@implementation XMCompany_section0_view

- (void)setCarModel:(XMCar *)carModel
{
    
    _carModel = carModel;
    
    
    UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",carModel.brandid]];
    
    self.imageView.image = image ? image : [UIImage imageNamed:@"companyList_placeholderImahe"];
    
    self.carNumberLabel.text = carModel.chepaino;
    
    
    
    UIColor *color;
    
    switch (carModel.currentstatus)
    {
        case 0:
            
            self.statusLabel.text = JJLocalizedString(@"停驶中", nil);
            
            color = XMRedColor;
            
            break;
            
        case 1:
            
            self.statusLabel.text = JJLocalizedString(@"行驶中", nil);
            
            color = XMGreenColor;
            
            break;
            
        case 2:
            
            self.statusLabel.text = JJLocalizedString(@"失联", nil);
            
            color = XMGrayColor;
            
            break;
            
        default:
            break;
    }
    
    self.statusLabel.textColor = color;
    
    NSString *name = [carModel.seriesname stringByAppendingFormat:@" %@",carModel.stylename];
    
    self.allNameLabel.text = name.length > 2 ? name : JJLocalizedString(@"暂无数据", nil);
    
}
@end
