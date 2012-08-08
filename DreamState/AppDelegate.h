//
//  AppDelegate.h
//  DreamState
//
//  Created by Michal Thompson on 7/20/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordDreamViewController.h"
#import "MenuViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import <AudioToolbox/AudioToolbox.h>

extern NSString *localReceived;


//@interface AppDelegate : UIResponder <UIApplicationDelegate>{
@interface AppDelegate : NSObject <UIApplicationDelegate, AVAudioPlayerDelegate>{
    NSDictionary *alarmClockData;
    
     AVAudioPlayer *alarmSound;
    
    NSURL *fileURL;
    
    //NSString *alarmSoundName;
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MenuViewController *viewController;
@property (nonatomic, retain) RecordDreamViewController *tdController;

@property (nonatomic, retain) NSUserDefaults *defaults;


@property (nonatomic, retain) NSDictionary *alarmClockData;


@property (nonatomic, retain) AVAudioPlayer *alarmSound;

@property (nonatomic, retain)  NSURL *fileURL;


//@property (nonatomic, retain) NSString *alarmSoundName;





@end
