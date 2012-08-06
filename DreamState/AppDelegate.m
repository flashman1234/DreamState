//
//  AppDelegate.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "MenuViewController.h"
#import "RecordDreamViewController.h"
#import "InAppSettings.h"


NSString *localReceived = @"localReceived";

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize tdController = _tdController;
@synthesize defaults = _defaults;
@synthesize alarmClockData;

@synthesize alarmSound;
@synthesize fileURL;

+ (void)initialize{
    if([self class] == [AppDelegate class]){
        [InAppSettings registerDefaults];
    }
}





-(void)playAlarmSound{
    
    NSString *fileName = @"alarm-clock-1";
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"caf"];
    
    NSURL *tempfileURL = [NSURL fileURLWithPath:path];

    fileURL = tempfileURL;
    
    NSError *error;
    AVAudioPlayer *theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    
    alarmSound = theAudio;
    
    if (error) {
        NSLog(@"error : %@", error);
    }
    
    alarmSound.volume = 1.0;
    
    alarmSound.delegate = self;
    
    [alarmSound prepareToPlay];
    
    [alarmSound play];
    
}

-(void)stopAlarmSound{
    [alarmSound stop];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self stopAlarmSound];
    
    switch (buttonIndex) {
    case 1: 
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
        }
            break;
    }
}



-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    
    if (application.applicationState == UIApplicationStateInactive ) {
        [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
    }
    
    if(application.applicationState == UIApplicationStateActive ) {
       
        [self playAlarmSound];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(@"Dream alarm clock",nil)
                              message: NSLocalizedString(@"Would you like to record a dream?",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"No",nil)
                              otherButtonTitles: NSLocalizedString(@"Yes",nil), nil];
        [alert show];
    }
}

-(void)setAlarmClockPlist{
    NSString *Path = [[NSBundle mainBundle] bundlePath];
    NSString *DataPath = [Path stringByAppendingPathComponent:@"AlarmClock.plist"];
    
    NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:DataPath];
    self.alarmClockData = tempDict;
}

-(void)setUserDefaultsAndSync{
    NSUserDefaults *defaults2 = [NSUserDefaults standardUserDefaults];
    self.defaults = defaults2;
    
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"Audio",@"Recording",
                                 @"AutoRecord", [NSNumber numberWithBool:YES],
                                 nil];

    [self.defaults registerDefaults:appDefaults];
    [self.defaults synchronize];
}

-(void)setAudioSession{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dream State error" 
                                                        message:@"Error is setting up the audo session record category" 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSError *error2;
    [[AVAudioSession sharedInstance] setActive:YES error:&error2];
    if (error2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dream State error" 
                                                        message:@"Error is setting the audo session to active" 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    [self setAlarmClockPlist];
    
    [self setUserDefaultsAndSync];
    
    [self setAudioSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
//    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        self.viewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPhone" bundle:nil];
//    } else {
//        self.viewController = [[MenuViewController alloc] initWithNibName:@"MenuViewController_iPad" bundle:nil];
//    }
    
    UINavigationController *navigationViewController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    
    self.window.rootViewController = navigationViewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
