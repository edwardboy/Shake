//
//  HAudioManager.m
//  TestiOS
//
//  Created by gyh on 2020/9/2.
//  Copyright © 2020 com.berman.www. All rights reserved.
//

#import "HAudioManager.h"

#import <AudioUnit/AudioUnit.h>
#import <CoreAudioKit/CoreAudioKit.h>
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

@interface HAudioManager ()<AVAudioPlayerDelegate>

@property (nonatomic, assign) double sampleRate;

@property (nonatomic, strong) AVAudioPlayer *audioPlayer;

@end

@implementation HAudioManager

SingletonM(HAudioManager)

void soundCompleteCallback(SystemSoundID soundId, void * clientData){
    NSLog(@"===播放完成===");
}

// 1、短音频播放示例(铃声、提示音等)
- (void)playSampleAudio {
    /*
     AudioToolbox.framework是一套基于C语言的框架，使用它来播放音效其本质是将短音频注册到系统声音服务（System Sound Service）。System Sound Service是一种简单、底层的声音播放服务，但是它本身也存在着一些限制：
     
     音频播放时间不能超过30s
     数据必须是PCM或者IMA4格式
     音频文件必须打包成.caf、.aif、.wav中的一种（注意这是官方文档的说法，实际测试发现一些.mp3也可以播放）
     */
    NSString *audioName = @"call.caf";
    NSString *audioFilePath = [[NSBundle mainBundle] pathForResource:audioName ofType:nil];
    NSURL *audioFileUrl = [NSURL fileURLWithPath:audioFilePath];
    
    SystemSoundID soundID = 0;
    
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)audioFileUrl, &soundID);
    
    AudioServicesAddSystemSoundCompletion(soundID, NULL, NULL, soundCompleteCallback, NULL);
    
    AudioServicesPlaySystemSound(soundID);
    
}


- (AVAudioPlayer *)audioPlayer{
    if (!_audioPlayer){
        NSString *fileName = @"不才 - 化身孤岛的鲸.mp3";
        NSString *urlStr = [[NSBundle mainBundle]pathForResource:fileName ofType:nil];
        NSURL *url = [NSURL fileURLWithPath:urlStr];
        NSError *error = nil;
        
        [self initialManager];
        
        _audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops = 0;
        _audioPlayer.delegate = self;
    }
    
    return _audioPlayer;
}

- (void)initialManager{
    //    const sampleRate = 10.0;
    NSError *error = nil;

    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    [audioSession setPreferredSampleRate:sampleRate error:&error];
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:&error];
    [audioSession setActive:true error:&error];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];

    //    获取采样率
//    self.sampleRate = [audioSession sampleRate];

}

/**
 *  一旦输出改变则执行此方法
 *
 *  @param notification 输出改变通知对象
 */
-(void)routeChange:(NSNotification *)notification{
    NSDictionary *dic=notification.userInfo;
    int changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
        //原设备为耳机则暂停
        if ([portDescription.portType isEqualToString:@"Headphones"]) {
//            [self pause];
        }
    }
}



// 2、主音频示例播放
- (void)playSampleMP3 {
    if (![self.audioPlayer isPlaying]) {
        [self.audioPlayer play];
//        self.timer.fireDate=[NSDate distantPast];//恢复定时器
    }
}


#pragma mark - AVAudioPlayerDelegate
/* audioPlayerDidFinishPlaying:successfully: is called when a sound has finished playing. This method is NOT called if the player is stopped due to an interruption. */
- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    NSLog(@"---audioPlayerDidFinishPlaying---");
}

/* if an error occurs while decoding it will be reported to the delegate. */
- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError * __nullable)error{
    NSLog(@"---audioPlayerDecodeErrorDidOccur---");
}


@end
