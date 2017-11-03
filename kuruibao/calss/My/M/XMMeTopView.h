//
//  XMMeTopView.h
//  kuruibao
//
//  Created by x on 17/8/4.
//  Copyright © 2017年 ChexXiaoMi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "XMTrackScoreModel.h"

#import "XMInfoManager.h"

@class XMMeTopView;

@protocol XMMeTopViewDelegate <NSObject>

/**
 个人中心头像被点击

 @param topView trigger
 */
- (void)topViewProfileDidClick:(XMMeTopView *)topView;

/**
 正五边形被点击

 @param topView taigger
 */
- (void)topViewPentagonDidClick:(XMMeTopView *)topView;

@end


@interface XMMeTopView : UIView
/**
 显示设置用户昵称
 */
@property (weak, nonatomic) IBOutlet UILabel *userName;

@property (copy, nonatomic) NSString *nickName;//!< set nickName


/**
 用户信息数据
 */
@property (strong, nonatomic) NSDictionary *userDic;

/**
 用户得分数据
 */
@property (strong, nonatomic) XMTrackScoreModel *model;

@property (weak, nonatomic) id<XMMeTopViewDelegate> delegate;


/**
 没有网且没有缓存的时候设置数据
 */
@property (strong, nonatomic) XMInfoManager *manager;


/**
 头像
 */
@property (strong, nonatomic) UIImage *headerImage;




@end














