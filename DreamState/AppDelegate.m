//
//  AppDelegate.m
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import "AppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "HomeViewController.h"
#import "RecordDreamViewController.h"
#import "InAppSettings.h"
#import "CurrentDreamsViewController.h"
#import "Alarm.h"
#import "Day.h"
#import "Dream.h"
#import "NotificationLoader.h"
//#import "TestFlight.h"
#import "LegalViewController.h"
#import "Settings.h"
#import <AudioToolbox/AudioToolbox.h>

NSString *localReceived = @"localReceived";

@implementation AppDelegate{
    SystemSoundID beepOnSoundId;
}

@synthesize navigationController;
@synthesize appOpensFromAlarm;
@synthesize window = _window;
@synthesize defaults = _defaults;
@synthesize alarmClockData;
@synthesize managedObjectContext = __managedObjectContext;
@synthesize managedObjectModel = __managedObjectModel;
@synthesize persistentStoreCoordinator = __persistentStoreCoordinator;
@synthesize alarmSound;
@synthesize fileURL;

+ (void)initialize{
    if([self class] == [AppDelegate class]){
        //[InAppSettings registerDefaults];
    }
}

#pragma mark - notifications
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    [self stopAlarmSound];
    
    switch (buttonIndex) {
        case 0:
        {
            AudioServicesDisposeSystemSoundID(beepOnSoundId);
            break;
        }
        case 1: 
        {
            AudioServicesDisposeSystemSoundID(beepOnSoundId);
            [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
            break;
        }
            break;
    }
}

-(void)playAlarmSound:(NSString *)sound{
    
    CFURLRef soundUrl = CFBundleCopyResourceURL(
                                                CFBundleGetMainBundle(), 
                                                (__bridge CFStringRef)sound, 
                                                CFSTR("m4a"), 
                                                NULL
                                                );
    
    AudioServicesCreateSystemSoundID(soundUrl, &beepOnSoundId);
    
    AudioServicesPlaySystemSound(beepOnSoundId);
    
    
  /*  
    NSString *fileName = sound;
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"m4a"];
    NSURL *tempfileURL = [NSURL fileURLWithPath:path];
    fileURL = tempfileURL;
    
    NSError *error;
    AVAudioPlayer *theAudio=[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:&error];
    
    alarmSound = theAudio;
    
    if (error) {
        NSLog(@"playAlarmSound error : %@", error);
    }
    
    alarmSound.volume = 1.0;
    alarmSound.delegate = self;
    [alarmSound prepareToPlay];
    [alarmSound play];
   
   */
}

-(void)stopAlarmSound{
    [alarmSound stop];
}


-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
   
    appOpensFromAlarm = YES;
    NSDictionary *notDict = notification.userInfo;
    NSString *alarmSoundName = [notDict valueForKey:@"AlarmSound"];
    
    NSString *alarmName = [notification.userInfo valueForKey:@"AlarmName"];

    if (application.applicationState == UIApplicationStateInactive ) {
       
        [[NSNotificationCenter defaultCenter] postNotificationName:localReceived object:self];
    }
    
    if(application.applicationState == UIApplicationStateActive ) {
    
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat: @"yyyy-MM-dd HH:mm:ss zzz"]; 
        
        //NSString *stringFromDate = [dateFormat stringFromDate:notification.fireDate];
        
        [self playAlarmSound:alarmSoundName];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: NSLocalizedString(alarmName, nil)
                              message: NSLocalizedString(@"Would you like to record a dream?",nil)
                              delegate: self
                              cancelButtonTitle: NSLocalizedString(@"No",nil)
                              otherButtonTitles: NSLocalizedString(@"Yes",nil), nil];
        [alert show];
    }
}


#pragma mark plist and defaults
-(void)setAlarmClockPlist{
    NSString *Path = [[NSBundle mainBundle] bundlePath];
    NSString *DataPath = [Path stringByAppendingPathComponent:@"AlarmClock.plist"];
    NSDictionary *tempDict = [[NSDictionary alloc] initWithContentsOfFile:DataPath];
    self.alarmClockData = tempDict;
}

-(void)setUserDefaultsAndSync{
    
    self.defaults = [NSUserDefaults standardUserDefaults];
    
    NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:@"Audio",@"Recording",
                                 @"AutoRecord", [NSNumber numberWithBool:YES],
                                 nil];

    [self.defaults registerDefaults:appDefaults];
    [self.defaults synchronize];
}

#pragma audio session
-(void)setAudioSession{
    NSError *error;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dream State error" 
                                                        message:@"Device cannot record audio" 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    NSError *error2;
    [[AVAudioSession sharedInstance] setActive:YES error:&error2];
    if (error2) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Dream State error" 
                                                        message:@"Error setting the audo session to active" 
                                                       delegate:self cancelButtonTitle:@"Ok" 
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application{

    if (!appOpensFromAlarm) {
        ((UITabBarController *)self.window.rootViewController).selectedIndex = 0;
    }
}

-(void)checkSettings{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Settings" inManagedObjectContext:__managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError *error;
    
    
    NSArray *settings = [__managedObjectContext executeFetchRequest:fetchRequest error:&error];

    
    if (settings.count == 0) {
        Settings *settings = [NSEntityDescription
                 insertNewObjectForEntityForName:@"Settings"
                 inManagedObjectContext:__managedObjectContext];
        settings.autoRecord = [NSNumber numberWithBool:YES];
        
        NSError *saveError = nil;
        [__managedObjectContext save:&saveError];
        
        if (saveError) {
            NSLog(@"saveError : %@", saveError.localizedDescription);
        }
        
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NotificationLoader *notificationLoader = [[NotificationLoader alloc] init];
    notificationLoader.managedObjectContext = [self managedObjectContext];
    [notificationLoader loadNotifications];
    
    [self setAlarmClockPlist];
    //[self setUserDefaultsAndSync];
    [self setAudioSession];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    UITabBarController *tbc = [[UITabBarController alloc] init];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] init];
    RecordDreamViewController *recordDreamViewController = [[RecordDreamViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    CurrentDreamsViewController *currentDreamsViewController  = [[CurrentDreamsViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    LegalViewController *legalViewController = [[LegalViewController alloc] initWithManagedObjectContext:__managedObjectContext];
    
    NSMutableArray *tabBarViewControllers = [[NSMutableArray alloc] initWithCapacity:4];
    
    navigationController = nil;
    navigationController = [[UINavigationController alloc] initWithRootViewController:homeViewController];
    [tabBarViewControllers addObject:navigationController];
    navigationController = nil;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:recordDreamViewController];
    [tabBarViewControllers addObject:navigationController];
    navigationController = nil;
    
    navigationController = [[UINavigationController alloc] initWithRootViewController:currentDreamsViewController];
    [tabBarViewControllers addObject:navigationController];
    navigationController = nil;

    navigationController = [[UINavigationController alloc] initWithRootViewController:legalViewController];
    [tabBarViewControllers addObject:navigationController];
    navigationController = nil;

    
    [tbc setViewControllers:tabBarViewControllers];
    
    tbc.delegate = self;
    
    self.window.rootViewController = tbc;
    [self.window makeKeyAndVisible];
    
    
    UInt32 routeVar = kAudioSessionOverrideAudioRoute_Speaker;
    AudioSessionSetProperty(kAudioSessionProperty_OverrideAudioRoute, sizeof(routeVar), &routeVar);
    
    [self checkSettings];
    
    /*
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];

    [TestFlight takeOff:@"83adb1d1f3551e721ff1c9fb7195d17e_MTI5Mjk0MjAxMi0wOS0wNiAxMDo0NToxMC44NzQ5MTI"];
    */
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
//
//- (void)applicationDidBecomeActive:(UIApplication *)application
//{
//    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
//}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [self saveContext];
}


- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

- (BOOL)tabBarController:(UITabBarController *)theTabBarController shouldSelectViewController:(UIViewController *)viewController
{
    [(UINavigationController *)viewController popToRootViewControllerAnimated:NO];
    return YES;
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil) {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil) {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"DreamState" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return __managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil) {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DreamState.sqlite"];
    
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        //NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}




@end


