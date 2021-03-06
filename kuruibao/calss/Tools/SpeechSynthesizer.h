//
//  SpeechSynthesizer.h
//  AMapNaviKit
//
//  Created by 刘博 on 16/4/1.
//  Copyright © 2016年 AutoNavi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>


/**
 *  iOS7及以上版本可以使用 AVSpeechSynthesizer 合成语音
 *
 *  或者采用"科大讯飞"等第三方的语音合成服务
 */
/***********************************************************************************************
    专门用来播放导航时候的音效，iOS7以后可以使用这个来播放
    之前的可以使用科大讯飞来播放
 
 ************************************************************************************************/
@interface SpeechSynthesizer : NSObject

+ (instancetype)sharedSpeechSynthesizer;

- (void)speakString:(NSString *)string;

- (void)stopSpeak;

@end
