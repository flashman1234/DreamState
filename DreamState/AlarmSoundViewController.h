//
//  AlarmSoundViewController.h
//  DreamState
//
//  Created by Michal Thompson on 8/24/12.
//  Copyright (c) 2012 NA. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlarmSoundViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>{
    IBOutlet UITableView *alarmSoundTableView;
}

@property (nonatomic, retain) UITableView *alarmSoundTableView;
@property (nonatomic, retain) NSArray *soundArray;

@end
