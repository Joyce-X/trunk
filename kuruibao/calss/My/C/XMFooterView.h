//
//  XMFooterView.h
//  kuruibao
//
//  Created by x on 17/8/9.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol XMFooterViewDelegate <NSObject>

- (void)footerAddButtonClick;

@end

@interface XMFooterView : UIView

@property (weak, nonatomic) id<XMFooterViewDelegate> delegate;

@end
