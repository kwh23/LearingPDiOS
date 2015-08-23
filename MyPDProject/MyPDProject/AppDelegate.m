//
//  AppDelegate.m
//  MyPDProject
//
//  Created by Kieran Warner-Hunt on 28/07/2015.
//  Copyright (c) 2015 Kieran Warner-Hunt. All rights reserved.
//

#import "AppDelegate.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.pd = [[PdAudioController alloc]init];
    PdAudioStatus pdInit =[self.pd configureAmbientWithSampleRate:44100 numberChannels:2 mixingEnabled:YES];
    if (pdInit != PdAudioOK) {
        NSLog(@"Pd failed to initailize");
    }
    [PdBase setDelegate:self];
    [PdBase subscribe:@"play_cont_write"];
    NSLog(@"Booyah!");
    return YES;
}

- (void)receivePrint:(NSString *)message {
    NSLog(@"%@", message);
}

- (void)receiveFloat:(float)received fromSource:(NSString *)source {
    if([source isEqualToString:@"play_cont_write"]) {
        NSLog(@"Received float send from 'play_cont_write', with value (cast to int) %i: ", (int)received);
        NSLog(@"Will store to NSUserDefaults as the Fibonnaci play count");
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSNumber* fibNum = [NSNumber numberWithFloat:received];
        [defaults setObject:fibNum forKey:@"fib_play_count"];
        [defaults synchronize];
        NSLog(@"Saved data");
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    self.pd.active = NO;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    self.pd.active = YES;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
