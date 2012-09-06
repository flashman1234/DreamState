//
//  AlarmSoundViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/24/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface AlarmSoundViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *alarmSoundTableView;
    AVAudioPlayer *audioPlayer;
    
}

@property (nonatomic, retain) UITableView *alarmSoundTableView;
@property (nonatomic, retain) NSArray *soundArray;
@property (nonatomic, retain) NSString *existingSound;

@end
