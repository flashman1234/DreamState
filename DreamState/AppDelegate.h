//
//  AppDelegate.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDreamViewController.h"
#import "HomeViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString *localReceived;

@interface AppDelegate : NSObject <UIApplicationDelegate, AVAudioPlayerDelegate, UITabBarControllerDelegate>{
    NSDictionary *alarmClockData;
    AVAudioPlayer *alarmSound;
    NSURL *fileURL;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) HomeViewController *viewController;
@property (nonatomic, retain) RecordDreamViewController *tdController;
@property (nonatomic, retain) NSUserDefaults *defaults;
@property (nonatomic, retain) NSDictionary *alarmClockData;
@property (nonatomic, retain) AVAudioPlayer *alarmSound;
@property (nonatomic, retain)  NSURL *fileURL;
@property (nonatomic, retain)  UINavigationController *navigationController;
@property BOOL appOpensFromAlarm;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end
