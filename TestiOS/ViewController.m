//
//  ViewController.m
//  TestiOS
//
//  Created by gyh on 2019/9/2.
//  Copyright © 2019 com.berman.www. All rights reserved.
//

#import "ViewController.h"
#import <fishhook/fishhook.h>

#import "HAudioManager.h"


@interface ViewController ()

@property (nonatomic, strong) HAudioManager *audioManager;

@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor cyanColor];
     
    [self audioModuleTest];
}

- (void)audioModuleTest {
    HAudioManager *audioManager = [HAudioManager sharedHAudioManager];
    self.audioManager = audioManager;
//    [audioManager playSampleAudio];
    [audioManager playSampleMP3];
}













static void(*sys_nslog)(NSString *format, ...);

void hook_nslog(NSString *format, ...){
    format = [format stringByAppendingString:@"=============="];
    sys_nslog(format);
}

- (void)testHook{
    struct rebinding nslog_reb;
    nslog_reb.name = "NSLog";
    nslog_reb.replacement = hook_nslog;
    nslog_reb.replaced = (void *)&sys_nslog;
    
    struct rebinding rebs[] = {nslog_reb};
    rebind_symbols(rebs, 1);
}

- (void)test{
    const int count = 200000;  // 15.3MB duration:2min
    
//    @autoreleasepool {
    for (int i = 0; i<count; i++) {
        
        NSString *str = [[NSString alloc] initWithFormat:@"test:%d",i];
//        [NSString stringWithFormat:@"test:%d",i];
            NSLog(str);
        
    }
//        }
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"click!!!");
}

@end
