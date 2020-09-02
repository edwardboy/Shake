//
//  HAudioManager.h
//  TestiOS
//
//  Created by gyh on 2020/9/2.
//  Copyright © 2020 com.berman.www. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSingleton.h"

NS_ASSUME_NONNULL_BEGIN

@interface HAudioManager : NSObject
 
SingletonH(HAudioManager)

// 1、短音频播放示例(铃声、提示音等)
- (void)playSampleAudio;

// 2、主音频示例播放
- (void)playSampleMP3;

@end

NS_ASSUME_NONNULL_END
