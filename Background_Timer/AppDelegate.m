//
//  AppDelegate.m
//  Background_Timer
//
//  Created by ShenTong on 2016/12/6.
//  Copyright © 2016年 ShenTong. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>

@interface AppDelegate ()

@end

@implementation AppDelegate
{
    NSTimer *_timer;
    NSInteger _count;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //应用可以后台运行的设置
    NSError *setCategoryErr = nil;
    NSError *activationErr = nil;
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:&setCategoryErr];
    [[AVAudioSession sharedInstance] setActive:YES error:&activationErr];
    //添加定时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(startListen:) userInfo:nil repeats:YES];
    [_timer setFireDate:[NSDate distantFuture]];//关闭定时器
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    //设置永久后台运行
    UIApplication *app = [UIApplication sharedApplication];
    __block UIBackgroundTaskIdentifier bgTask;
    bgTask = [app beginBackgroundTaskWithExpirationHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            if (bgTask != UIBackgroundTaskInvalid)
            {
                bgTask = UIBackgroundTaskInvalid;
            }
        });
    }];
    //开启定时器
    [_timer setFireDate:[NSDate distantPast]];
    _count = 0;
}


- (void)startListen:(NSTimer *)timer
{
    _count++;
    NSLog(@"正在后台运行");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    //关闭定时器
    [_timer setFireDate:[NSDate distantFuture]];
    NSLog(@"后台运行计数值为:%ld",_count);
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
